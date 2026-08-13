#!/usr/bin/env python3
"""
EMA → Jira sync
Lee cookies de Chrome automáticamente (no requiere copiar nada).
Uso: python3 ema_sync.py <EMA_EXPERIMENT_URL_OR_ID>
"""

import sys
import re
import json
import os
from pathlib import Path
import requests

# Cargar .env si existe
_env_file = Path(__file__).parent / ".env"
if _env_file.exists():
    for line in _env_file.read_text().splitlines():
        if "=" in line and not line.startswith("#"):
            k, v = line.split("=", 1)
            os.environ.setdefault(k.strip(), v.strip())

# ── Configuración ────────────────────────────────────────────────────────────

CHROME_PROFILE = os.path.expanduser(
    "~/Library/Application Support/Google/Chrome/Profile 4/Cookies"
)
JIRA_BASE = "https://projectmanagement.appslatam.com"
EMA_BASE  = "https://ema.appslatam.com"

# Credenciales Jira desde env (o hardcodear si es un entorno privado)
JIRA_TOKEN = os.environ.get("JIRA_TOKEN", "")

# ── Helpers ──────────────────────────────────────────────────────────────────

def fetch_via_chrome(url: str) -> str:
    """
    Usa el Chrome que ya tiene la sesión IAP activa para hacer el fetch.
    Abre una pestaña nueva, obtiene el body y la cierra.
    Requiere que Chrome esté abierto y autenticado en EMA.
    """
    import subprocess, time

    script = f"""
set targetUrl to "{url}"
tell application "Google Chrome"
    set theWindow to front window
    set newTab to make new tab at end of tabs of theWindow
    set URL of newTab to targetUrl
    delay 5
    set bodyText to execute newTab javascript "document.body.innerText"
    close newTab
    return bodyText
end tell
"""
    proc = subprocess.run(
        ["osascript", "-e", script],
        capture_output=True, text=True, timeout=20
    )
    if proc.returncode != 0:
        raise RuntimeError(f"AppleScript error: {proc.stderr.strip()}")
    return proc.stdout.strip()


def get_experiment(exp_id: str) -> dict:
    url = f"{EMA_BASE}/api/experiments/{exp_id}"
    body = fetch_via_chrome(url)
    if not body or body.lstrip().startswith("<"):
        raise RuntimeError(
            "EMA devolvió HTML en vez de JSON — sesión IAP expirada.\n"
            "Solución: abre Chrome, visita ema.appslatam.com y vuelve a intentar."
        )
    return json.loads(body)


def extract_jira_key(rfc_url: str) -> str | None:
    """Extrae el key de Jira desde la URL del campo rfc."""
    match = re.search(r"/browse/([A-Z]+-\d+)", rfc_url or "")
    return match.group(1) if match else None


def build_jira_update(data: dict) -> dict:
    """Mapea campos de EMA al formato de Jira update."""
    exp     = data["experiment"]
    report  = data.get("latestReport", {})
    results = report.get("measurement_outcomes", {})

    fields = {}

    # ── Sample size / Amount of units ────────────────────────────────────────
    run_status = report.get("run_status", {})
    sample_size = run_status.get("sample_size")

    summary_key = next(iter(results), None)
    if summary_key:
        summary = results[summary_key].get("estimates_summary", [])
        control = next((s for s in summary if s["variant"] == "Control"), None)
        variant = next((s for s in summary if s["variant"] != "Control"), None)

        if control and variant and sample_size:
            fields["customfield_60007"] = (
                f"Total: {sample_size:,} | "
                f"Control: {int(control['units'].split()[0].replace(',',''))} ({control['units'].split()[1]}) | "
                f"{variant['variant']}: {int(variant['units'].split()[0].replace(',',''))} ({variant['units'].split()[1]})"
            )

        # ── Uplift / bounds ───────────────────────────────────────────────────
        if variant:
            uplift       = variant.get("estimated_impact")
            upper        = variant.get("upper_bound")
            lower        = variant.get("lower_bound")
            rel_impact   = variant.get("relative_impact")

            if uplift  is not None: fields["customfield_57405"] = round(uplift, 8)
            if upper   is not None: fields["customfield_57406"] = round(upper, 8)
            if lower   is not None: fields["customfield_57407"] = round(lower, 8)

            # Tipo de uplift → Absoluto por defecto
            fields["customfield_59300"] = {"id": "65600"}  # Absoluto

    # ── Analysis platform URL (EMA link) ────────────────────────────────────
    fields["customfield_57600"] = f"{EMA_BASE}/experiments/{exp['id']}"

    return {"fields": fields}


def update_jira(issue_key: str, payload: dict) -> requests.Response:
    url = f"{JIRA_BASE}/rest/api/2/issue/{issue_key}"
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {JIRA_TOKEN}",
    }
    return requests.put(url, json=payload, headers=headers)


# ── Main ─────────────────────────────────────────────────────────────────────

def main():
    if len(sys.argv) < 2:
        print("Uso: python3 ema_sync.py <EMA_URL_o_ID> [JIRA_KEY_override]")
        sys.exit(1)

    # Extraer experiment ID de URL o usarlo directo
    arg = sys.argv[1]
    match = re.search(r"/experiments/([A-Za-z0-9_-]+)", arg)
    exp_id = match.group(1) if match else arg

    print(f"[1/4] Obteniendo experimento {exp_id} vía Chrome...")
    print(f"      (Chrome debe estar abierto y autenticado en EMA)")
    data = get_experiment(exp_id)
    exp = data["experiment"]
    print(f"      Nombre : {exp['name']}")
    print(f"      Status : {exp['current_status']['status']}")
    print(f"      RFC    : {exp.get('rfc', 'sin RFC')}")

    jira_key = sys.argv[2] if len(sys.argv) > 2 else extract_jira_key(exp.get("rfc", ""))
    if not jira_key:
        print("\nERROR: No se encontró ticket Jira. Pásalo como segundo argumento.")
        sys.exit(1)
    print(f"      Jira   : {jira_key}")

    print(f"\n[2/4] Construyendo payload de actualización...")
    payload = build_jira_update(data)
    fields_to_update = list(payload["fields"].keys())
    print(f"      Campos : {fields_to_update}")

    report = data.get("latestReport", {})
    results = report.get("measurement_outcomes", {})
    summary_key = next(iter(results), None)
    if summary_key:
        for s in results[summary_key].get("estimates_summary", []):
            rel = s.get("relative_impact")
            impact = s.get("estimated_impact")
            print(f"      {s['variant']}: units={s['units']}"
                  + (f", uplift={impact:.6f}, rel={rel:.2%}" if impact else ""))

    print(f"\n[3/4] Actualizando {jira_key} en Jira...")
    if not JIRA_TOKEN:
        print("\nAVISO: JIRA_TOKEN no configurado.")
        print("Payload que se enviaría:")
        print(json.dumps(payload, indent=2))
        print(f"\nConfigura: export JIRA_TOKEN='tu_token_aqui'")
        print(f"O usa el MCP de Jira desde Claude Code.")
        return

    r = update_jira(jira_key, payload)
    if r.status_code == 204:
        print(f"      ✓ {jira_key} actualizado correctamente")
        print(f"      Link: {JIRA_BASE}/browse/{jira_key}")
    else:
        print(f"      ERROR {r.status_code}: {r.text[:200]}")


if __name__ == "__main__":
    main()
