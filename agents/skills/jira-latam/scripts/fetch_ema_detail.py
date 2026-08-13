#!/usr/bin/env python3
"""Fetch detailed EMA experiment data for manual review.

Uso: python3 fetch_ema_detail.py <EMA_ID_o_URL> [<EMA_ID_o_URL> ...]

Ejemplos:
  python3 fetch_ema_detail.py <EMA_EXPERIMENT_ID>
  python3 fetch_ema_detail.py https://ema.appslatam.com/experiments/<EMA_EXPERIMENT_ID>
  python3 fetch_ema_detail.py ID1 ID2 ID3
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
        raise RuntimeError(proc.stderr.strip())
    return proc.stdout.strip()


def get_experiment(exp_id: str) -> dict:
    body = fetch_via_chrome(f"{EMA_BASE}/api/experiments/{exp_id}")
    if not body or body.lstrip().startswith("<"):
        raise RuntimeError("Sesión IAP expirada — abre Chrome y visita ema.appslatam.com")
    return json.loads(body)


def print_experiment(exp_id: str) -> None:
    print(f"\n{'='*60}")
    print(f"  {exp_id}")
    print(f"{'='*60}")
    try:
        data = get_experiment(exp_id)
    except Exception as e:
        print(f"  ERROR: {e}")
        return

    exp = data["experiment"]
    report = data.get("latestReport", {})
    results = report.get("measurement_outcomes", {})
    run_status = report.get("run_status", {})

    print(f"  Nombre  : {exp.get('name')}")
    print(f"  Status  : {exp.get('current_status', {}).get('status')}")
    sample = run_status.get('sample_size', '—')
    print(f"  Sample  : {sample:,}" if isinstance(sample, int) else f"  Sample  : {sample}")
    print(f"  EMA URL : {EMA_BASE}/experiments/{exp_id}")

    jira_rfc = exp.get("rfc", "")
    if jira_rfc:
        match = re.search(r"/browse/([A-Z]+-\d+)", jira_rfc)
        if match:
            print(f"  Jira    : {match.group(1)}")

    for field in ["description", "hypothesis", "learnings", "conclusion", "next_steps", "notes"]:
        val = exp.get(field)
        if val:
            print(f"  {field.capitalize()}: {str(val)[:200]}")

    for metric_key, metric_data in results.items():
        print(f"\n  Métrica: {metric_key}")
        for s in metric_data.get("estimates_summary", []):
            sig = s.get("is_significant")
            sig_str = "✓ SIGNIFICATIVO" if sig else ("✗ no significativo" if sig is False else "?")
            impact = s.get("estimated_impact")
            rel = s.get("relative_impact")
            lower = s.get("lower_bound")
            upper = s.get("upper_bound")
            print(f"    {s['variant']:12} | units={s['units']:20} | "
                  + (f"uplift={impact:+.4f}  rel={rel:+.2%}  IC=[{lower:.4f}, {upper:.4f}]  {sig_str}"
                     if impact is not None else "sin uplift"))

    for field in ["winner", "winning_variant", "recommendation", "decision"]:
        val = exp.get(field) or report.get(field)
        if val:
            print(f"\n  {field}: {val}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python3 fetch_ema_detail.py <EMA_ID_o_URL> [<EMA_ID_o_URL> ...]")
        sys.exit(1)

    exp_ids = [parse_id(arg) for arg in sys.argv[1:]]
    for exp_id in exp_ids:
        print_experiment(exp_id)
