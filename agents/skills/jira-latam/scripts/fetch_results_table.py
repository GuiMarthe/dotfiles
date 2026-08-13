#!/usr/bin/env python3
"""Fetch EMA experiment results and print a consolidated table.

Uso: python3 fetch_results_table.py <EMA_ID_o_URL> [<EMA_ID_o_URL> ...]

Ejemplos:
  python3 fetch_results_table.py <EMA_EXPERIMENT_ID>
  python3 fetch_results_table.py https://ema.appslatam.com/experiments/<EMA_EXPERIMENT_ID>
  python3 fetch_results_table.py ID1 ID2 ID3
"""

import re, json, subprocess, sys

EMA_BASE = "https://ema.appslatam.com"


def parse_id(arg: str) -> str:
    match = re.search(r"/experiments/([A-Za-z0-9_-]+)", arg)
    return match.group(1) if match else arg


def fetch_via_chrome(url: str) -> str:
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
    proc = subprocess.run(["osascript", "-e", script], capture_output=True, text=True, timeout=30)
    if proc.returncode != 0:
        raise RuntimeError(f"AppleScript error: {proc.stderr.strip()}")
    return proc.stdout.strip()


def get_experiment(exp_id: str) -> dict:
    body = fetch_via_chrome(f"{EMA_BASE}/api/experiments/{exp_id}")
    if not body or body.lstrip().startswith("<"):
        raise RuntimeError("EMA devolvió HTML — sesión IAP expirada.")
    return json.loads(body)


def extract_jira_key(rfc_url: str) -> str:
    match = re.search(r"/browse/([A-Z]+-\d+)", rfc_url or "")
    return match.group(1) if match else "—"


def extract_row(exp_id: str) -> dict:
    try:
        data = get_experiment(exp_id)
    except Exception as e:
        return {"id": exp_id, "error": str(e)}

    exp = data["experiment"]
    report = data.get("latestReport", {})
    results = report.get("measurement_outcomes", {})
    run_status = report.get("run_status", {})

    summary_key = next(iter(results), None)
    control = variant = None
    metric_name = summary_key or "—"
    if summary_key:
        summary = results[summary_key].get("estimates_summary", [])
        control = next((s for s in summary if s["variant"] == "Control"), None)
        variant = next((s for s in summary if s["variant"] != "Control"), None)

    return {
        "id": exp_id,
        "name": exp.get("name", "—"),
        "status": exp.get("current_status", {}).get("status", "—"),
        "jira": extract_jira_key(exp.get("rfc", "")),
        "metric": metric_name,
        "sample_size": f"{run_status.get('sample_size', '—'):,}" if isinstance(run_status.get('sample_size'), int) else str(run_status.get('sample_size', '—')),
        "control_units": control.get("units", "—") if control else "—",
        "variant_name": variant.get("variant", "—") if variant else "—",
        "variant_units": variant.get("units", "—") if variant else "—",
        "uplift_abs": f"{variant['estimated_impact']:.4f}" if variant and variant.get("estimated_impact") is not None else "—",
        "uplift_rel": f"{variant['relative_impact']:.2%}" if variant and variant.get("relative_impact") is not None else "—",
        "lower": f"{variant['lower_bound']:.4f}" if variant and variant.get("lower_bound") is not None else "—",
        "upper": f"{variant['upper_bound']:.4f}" if variant and variant.get("upper_bound") is not None else "—",
        "significant": str(variant.get("is_significant", "—")) if variant else "—",
        "error": None,
    }


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python3 fetch_results_table.py <EMA_ID_o_URL> [<EMA_ID_o_URL> ...]")
        sys.exit(1)

    exp_ids = [parse_id(arg) for arg in sys.argv[1:]]

    rows = []
    for i, exp_id in enumerate(exp_ids, 1):
        print(f"[{i}/{len(exp_ids)}] Fetching {exp_id}...", flush=True)
        rows.append(extract_row(exp_id))

    print("\n\n=== RESULTADOS CONSOLIDADOS ===\n")

    headers = ["#", "Nombre", "Estado EMA", "Jira", "Métrica", "Sample",
               "Control", "Variante", "Uplift Abs", "Uplift Rel", "Lower", "Upper", "Signif."]

    col_data = []
    for i, r in enumerate(rows, 1):
        if r.get("error"):
            col_data.append([str(i), r["id"], f"ERROR: {r['error']}", *["—"] * 10])
        else:
            col_data.append([
                str(i), r["name"][:40], r["status"], r["jira"],
                r["metric"][:30], r["sample_size"], r["control_units"],
                r["variant_name"] + " " + r["variant_units"],
                r["uplift_abs"], r["uplift_rel"], r["lower"], r["upper"], r["significant"],
            ])

    all_rows = [headers] + col_data
    widths = [max(len(str(row[c])) for row in all_rows) for c in range(len(headers))]

    def fmt_row(row):
        return " | ".join(str(cell).ljust(widths[i]) for i, cell in enumerate(row))

    sep = "-+-".join("-" * w for w in widths)
    print(fmt_row(headers))
    print(sep)
    for row in col_data:
        print(fmt_row(row))
    print()
