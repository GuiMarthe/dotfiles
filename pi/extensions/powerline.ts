/**
 * Powerline footer extension.
 *
 * Displays: [AGENT MODE] model │ ctx usage │ ↑in ↓out $cost │ git branch
 *
 * Vim mode is shown by pi-vim in the editor border — not duplicated here.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import type { AssistantMessage } from "@earendil-works/pi-ai";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

const PERSIST_KEY = "modes-state";

// ── ANSI ────────────────────────────────────────────────────────────
const RESET = "\x1b[0m";
const BOLD = "\x1b[1m";
const FG_WHITE = "\x1b[97m";
const FG_BLACK = "\x1b[30m";
const BG_GREEN = "\x1b[42m";
const BG_GRAY = "\x1b[100m";
const BG_YELLOW = "\x1b[43m";
const BG_CYAN = "\x1b[46m";
const BG_MAGENTA = "\x1b[45m";
const BG_RED = "\x1b[41m";
const FG_GRAY = "\x1b[90m";

const pill = (bg: string, fg: string, text: string) =>
  `${bg}${fg}${BOLD} ${text} ${RESET}`;

const AGENT_MODE_COLORS: Record<string, string> = {
  edit: BG_GREEN,
  plan: BG_YELLOW,
  ask: BG_CYAN,
  review: BG_MAGENTA,
  debug: BG_RED,
};

function getAgentMode(ctx: { sessionManager: { getEntries(): any[] } }): string {
  const entries = ctx.sessionManager.getEntries();
  for (let i = entries.length - 1; i >= 0; i--) {
    const e = entries[i];
    if (e.type === "custom" && e.customType === PERSIST_KEY) {
      const data = e.data as { modeId?: string } | undefined;
      if (data?.modeId) return data.modeId;
    }
  }
  return "edit";
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    ctx.ui.setFooter((tui, _theme, footerData) => {
      const unsub = footerData.onBranchChange(() => tui.requestRender());

      return {
        dispose: unsub,
        invalidate() {},
        render(width: number): string[] {
          const fmt = (n: number) =>
            n < 1000 ? `${n}` : `${(n / 1000).toFixed(1)}k`;

          // ── Agent mode pill ───────────────────────────
          const agentMode = getAgentMode(ctx);
          const agentBg = AGENT_MODE_COLORS[agentMode] || BG_GRAY;
          const agentFg = agentMode === "plan" ? FG_BLACK : FG_WHITE;
          const agentStr = pill(agentBg, agentFg, agentMode.toUpperCase());

          // ── Model pill ────────────────────────────────
          const modelId = ctx.model?.id || "no-model";
          const modelStr = pill(BG_GRAY, FG_WHITE, modelId);

          // ── Context usage ─────────────────────────────
          const usage = ctx.getContextUsage();
          let ctxStr = "";
          if (usage) {
            const { tokens, contextWindow: window, percent: pct } = usage;
            if (tokens !== null && pct !== null) {
              const color =
                pct >= 80 ? "\x1b[31m" : pct >= 50 ? "\x1b[33m" : FG_GRAY;
              ctxStr = ` ${color}${BOLD}ctx ${fmt(tokens)}/${fmt(window)} (${Math.round(pct)}%)${RESET}`;
            } else {
              ctxStr = ` ${FG_GRAY}ctx ?/${fmt(window)}${RESET}`;
            }
          }

          // ── Session token totals ──────────────────────
          let input = 0,
            output = 0,
            cost = 0;
          for (const e of ctx.sessionManager.getBranch()) {
            if (e.type === "message" && e.message.role === "assistant") {
              const m = e.message as AssistantMessage;
              input += m.usage.input;
              output += m.usage.output;
              cost += m.usage.cost.total;
            }
          }
          const statsStr = `${FG_GRAY}↑${fmt(input)} ↓${fmt(output)} $${cost.toFixed(3)}${RESET}`;

          // ── Git branch ────────────────────────────────
          const branch = footerData.getGitBranch();
          const branchStr = branch
            ? `${FG_GRAY}  ${branch}${RESET}`
            : "";

          const left = `${agentStr} ${modelStr}${ctxStr} ${statsStr}`;
          const right = branchStr;
          const pad = " ".repeat(
            Math.max(1, width - visibleWidth(left) - visibleWidth(right)),
          );
          return [truncateToWidth(left + pad + right, width)];
        },
      };
    });
  });
}
