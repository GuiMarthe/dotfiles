#!/usr/bin/env python3
"""
Experiments Weekly Reminder
Envía un mensaje a Google Chat con los experimentos abiertos del dominio configurado,
ordenados por informador según criticidad (ticket con más días sin avanzar primero).

Uso:     python3 eloyalty_reminder.py
Cron:    0 9 * * 1 /usr/bin/python3 $HOME/.claude/scripts/jira-latam/eloyalty_reminder.py
Config:  DOMAIN_FILTER, REMINDER_TITLE, JIRA_TOKEN, GOOGLE_CHAT_WEBHOOK en .env
"""

import os
import re
import sys
import json
import requests
from datetime import datetime, timezone
from pathlib import Path

# ── Cargar .env ──────────────────────────────────────────────────────────────

_env_file = Path(__file__).parent / ".env"
if _env_file.exists():
    for line in _env_file.read_text().splitlines():
        if "=" in line and not line.startswith("#"):
            k, v = line.split("=", 1)
            os.environ.setdefault(k.strip(), v.strip())

# ── Config ───────────────────────────────────────────────────────────────────

JIRA_BASE            = "https://projectmanagement.appslatam.com"
JIRA_TOKEN           = os.environ.get("JIRA_TOKEN", "")
GOOGLE_CHAT_WEBHOOK  = os.environ.get("GOOGLE_CHAT_WEBHOOK", "")
DOMAIN_FILTER        = os.environ.get("DOMAIN_FILTER", "eLoyalty")
REMINDER_TITLE       = os.environ.get("REMINDER_TITLE", f"{DOMAIN_FILTER} Experiments")

TODAY      = datetime.now(timezone.utc)
YEAR_START = f"{TODAY.year}-01-01"

STATUS_ORDER = [
    "Created",
    "DEFINING HYPOTESIS",
    "EXPERIMENT PLANNING",
    "READY TO RUN",
    "RUNNING",
]

# ── Helpers ──────────────────────────────────────────────────────────────────

def days_since(dt_str: str) -> int:
    # Jira returns offsets like -0400; Python needs -04:00
    normalized = re.sub(r"([+-])(\d{2})(\d{2})$", r"\1\2:\3", dt_str.replace("Z", "+00:00"))
    dt = datetime.fromisoformat(normalized)
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=timezone.utc)
    return (TODAY - dt).days


def days_in_status(issue: dict) -> int:
    """Días desde el último cambio de estado, o desde creación si nunca cambió."""
    histories = issue.get("changelog", {}).get("histories", [])
    for history in sorted(histories, key=lambda h: h["created"], reverse=True):
        for item in history.get("items", []):
            if item.get("field") == "status":
                return days_since(history["created"])
    return days_since(issue["fields"]["created"])


def clean_name(display_name: str | None) -> str:
    if not display_name:
        return "NA"
    return re.sub(r"\s*\([^)]+\)\s*$", "", display_name).strip()


def clean_squad(project_name: str) -> str:
    return re.sub(r"^PROY\s*[-–]\s*", "", project_name).strip()


def staleness_emoji(days: int) -> str:
    if days >= 60:
        return "🔴"
    elif days >= 30:
        return "🟡"
    return "🟢"


# ── Jira ─────────────────────────────────────────────────────────────────────

def fetch_experiments() -> list[dict]:
    jql = (
        f'issuetype = Experimentos AND cf[62001] = "{DOMAIN_FILTER}" '
        f'AND created >= "{YEAR_START}" AND statusCategory != Done '
        f'ORDER BY reporter ASC'
    )
    url = f"{JIRA_BASE}/rest/api/2/search"
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {JIRA_TOKEN}",
    }
    params = {
        "jql": jql,
        "maxResults": 200,
        "fields": "summary,status,reporter,assignee,project,created",
        "expand": "changelog",
    }
    resp = requests.get(url, headers=headers, params=params)
    resp.raise_for_status()
    data = resp.json()
    total = data["total"]
    issues = data["issues"]
    print(f"  {len(issues)}/{total} tickets obtenidos")
    return issues


def build_rows(issues: list[dict]) -> list[dict]:
    rows = []
    for issue in issues:
        f = issue["fields"]
        reporter_raw = (f.get("reporter") or {}).get("displayName")
        assignee_raw = (f.get("assignee") or {}).get("displayName")
        rows.append({
            "key":      issue["key"],
            "summary":  f["summary"][:58] + ("…" if len(f["summary"]) > 58 else ""),
            "status":   f["status"]["name"],
            "squad":    clean_squad(f["project"]["name"]),
            "reporter": clean_name(reporter_raw),
            "assignee": clean_name(assignee_raw) if assignee_raw else "Sin asignar",
            "days":     days_in_status(issue),
        })
    # Ordenar: informador por su ticket más crítico (días desc) → días desc dentro del informador
    max_days = {}
    for r in rows:
        max_days[r["reporter"]] = max(max_days.get(r["reporter"], 0), r["days"])
    rows.sort(key=lambda r: (-max_days[r["reporter"]], r["reporter"].lower(), -r["days"]))
    return rows


# ── Google Chat ───────────────────────────────────────────────────────────────

def pad(text: str, width: int) -> str:
    return text[:width].ljust(width)


STATUS_SHORT = {
    "Created":              "Created",
    "DEFINING HYPOTESIS":   "Defining Hypothesis",
    "EXPERIMENT PLANNING":  "Experiment Planning",
    "READY TO RUN":         "Ready to Run",
    "RUNNING":              "Running",
}


def build_message(rows: list[dict]) -> dict:
    date_str = TODAY.strftime("%-d %b %Y")

    # Stats por estado
    by_status = {s: 0 for s in STATUS_ORDER}
    for r in rows:
        by_status[r["status"]] = by_status.get(r["status"], 0) + 1

    # ── Mini tabla de resumen por estado ─────────────────────────────────────
    S_W = 21
    summary_lines = [
        pad("ESTADO", S_W) + "   #",
        "─" * S_W + "  ──",
    ]
    for s in STATUS_ORDER:
        if by_status.get(s):
            summary_lines.append(pad(STATUS_SHORT[s], S_W) + "  " + str(by_status[s]).rjust(2))

    # ── Tabla principal (DÍAS primero) ────────────────────────────────────────
    # Nota: emoji ocupa ~2 chars visuales; columna DÍAS usa 8 para compensar
    C = {
        "dias":       8,
        "informador": 20,
        "key":        12,
        "estado":     21,
    }
    sep = "─"
    main_header = (
        pad("DÍAS",       C["dias"])       + "  " +
        pad("INFORMADOR", C["informador"]) + "  " +
        pad("KEY",        C["key"])        + "  " +
        "ESTADO"
    )
    main_divider = "  ".join(sep * w for w in C.values()) + "  " + sep * C["estado"]

    main_lines = [main_header, main_divider]
    current_reporter = None
    for r in rows:
        if r["reporter"] != current_reporter and current_reporter is not None:
            main_lines.append("")
        current_reporter = r["reporter"]

        emoji = staleness_emoji(r["days"])
        days_str = f"{emoji} {r['days']}d"
        main_lines.append(
            pad(days_str,      C["dias"])       + "  " +
            pad(r["reporter"], C["informador"]) + "  " +
            pad(r["key"],      C["key"])        + "  " +
            r["status"][:C["estado"]]
        )

    # ── Bloque único ──────────────────────────────────────────────────────────
    legend = "🔴 >60d sin avanzar  ·  🟡 30–60d  ·  🟢 <30d"
    full_block = (
        "\n".join(summary_lines) +
        "\n\n" + legend + "\n\n" +
        "\n".join(main_lines)
    )

    header_text = (
        f"🧪 *{REMINDER_TITLE} — Recordatorio semanal*\n"
        f"_{date_str}  ·  {len(rows)} tickets abiertos_\n"
    )

    return {"text": header_text + "\n```\n" + full_block + "\n```"}


def send(payload: dict) -> None:
    resp = requests.post(
        GOOGLE_CHAT_WEBHOOK,
        json=payload,
        headers={"Content-Type": "application/json"},
    )
    resp.raise_for_status()
    print(f"  ✅ Mensaje enviado ({resp.status_code})")


# ── Main ─────────────────────────────────────────────────────────────────────

def main() -> None:
    errors = []
    if not JIRA_TOKEN:
        errors.append("JIRA_TOKEN no está en .env")
    if not GOOGLE_CHAT_WEBHOOK:
        errors.append("GOOGLE_CHAT_WEBHOOK no está en .env")
    if errors:
        for e in errors:
            print(f"❌ {e}")
        sys.exit(1)

    print("Consultando Jira...")
    issues = fetch_experiments()

    print("Procesando...")
    rows = build_rows(issues)

    print("Enviando a Google Chat...")
    payload = build_message(rows)
    send(payload)


if __name__ == "__main__":
    main()
