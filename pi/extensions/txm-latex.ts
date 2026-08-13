/**
 * txm LaTeX Renderer (additive, non-destructive)
 *
 * Renders LaTeX math found in assistant messages as Unicode box-art using the
 * external `txm` binary (https://github.com/thatmagicalcat/txm), shown as a
 * separate panel BELOW the message.
 *
 * Design guarantees:
 *  - Never rewrites message content. `message_end` returns undefined, so the
 *    model's text (markdown, code, diffs) renders exactly as normal. The math
 *    box is an *additional* custom entry, not a replacement.
 *  - Custom entries do NOT participate in LLM context, so nothing here can
 *    pollute the conversation the model sees.
 *  - A mis-detected "formula" is cosmetic only (an extra box), never
 *    destructive to formatting.
 *
 * Requirements:
 *  - `txm` on PATH (`cargo install txm`), or set env `TXM_BIN` to its path.
 *
 * Removal (zero trouble):
 *  - Delete this file and `/reload`. It is auto-discovered (not declared in
 *    settings.json) and has no npm deps, so nothing else needs unwinding.
 *  - Old sessions keep inert `tex-render` entries; they simply stop rendering
 *    and were never sent to the LLM.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Text } from "@earendil-works/pi-tui";

const TXM_BIN = process.env.TXM_BIN || "txm";
const MAX_FORMULAS_PER_MESSAGE = 8;
const TXM_TIMEOUT_MS = 5000;

interface TexBlock {
	latex: string;
	art: string;
}

/** Concatenate the text parts of a message's content. */
function extractText(content: unknown): string {
	if (typeof content === "string") return content;
	if (Array.isArray(content)) {
		return content
			.filter((p): p is { type: string; text: string } => !!p && (p as any).type === "text")
			.map((p) => p.text)
			.join("\n");
	}
	return "";
}

/** Remove fenced/inline code so we never treat `$` inside code as math. */
function stripCode(text: string): string {
	return text
		.replace(/```[\s\S]*?```/g, " ")
		.replace(/~~~[\s\S]*?~~~/g, " ")
		.replace(/`[^`\n]*`/g, " ");
}

/**
 * Heuristic to avoid matching prose/currency inside single-`$` spans
 * (e.g. "$5 to $10"). Strong delimiters ($$, \[ \], \( \)) skip this check.
 */
function hasLatexSignal(s: string): boolean {
	if (/[\\^_{}]/.test(s)) return true; // \frac, x^2, a_i, {..}
	if (/=/.test(s) && /[A-Za-z]/.test(s)) return true; // a = b
	return false;
}

interface Span {
	start: number;
	end: number;
	latex: string;
}

/** Find non-overlapping LaTeX spans in reading order. */
function findLatex(text: string): Span[] {
	const src = stripCode(text);
	const patterns: Array<{ re: RegExp; strong: boolean }> = [
		{ re: /\$\$([\s\S]+?)\$\$/g, strong: true }, // display: $$ ... $$
		{ re: /\\\[([\s\S]+?)\\\]/g, strong: true }, // display: \[ ... \]
		{ re: /\\\(([\s\S]+?)\\\)/g, strong: true }, // inline:  \( ... \)
		{ re: /\$([^$\n]+?)\$/g, strong: false }, // inline:  $ ... $
	];

	const found: Span[] = [];
	for (const { re, strong } of patterns) {
		let m: RegExpExecArray | null;
		while ((m = re.exec(src)) !== null) {
			const latex = m[1].trim();
			if (!latex) continue;
			if (!strong && !hasLatexSignal(latex)) continue;
			found.push({ start: m.index, end: m.index + m[0].length, latex });
		}
	}

	// Prefer longer (display) matches; drop anything overlapping an accepted span.
	found.sort((a, b) => a.start - b.start || b.end - b.start - (a.end - a.start));
	const accepted: Span[] = [];
	let lastEnd = -1;
	for (const f of found) {
		if (f.start >= lastEnd) {
			accepted.push(f);
			lastEnd = f.end;
		}
	}
	return accepted;
}

export default function (pi: ExtensionAPI) {
	let txmAvailable = false;
	let warned = false;

	async function detectTxm(): Promise<boolean> {
		try {
			const r = await pi.exec(TXM_BIN, ["x"], { timeout: 3000 });
			// txm prints a Unicode box to stdout for valid input and exits 0.
			return r.code === 0 && r.stdout.includes("┌");
		} catch {
			return false;
		}
	}

	/** Run txm on one formula. Returns null on panic (exit != 0) or bad output. */
	async function renderLatex(latex: string, signal?: AbortSignal): Promise<string | null> {
		try {
			const r = await pi.exec(TXM_BIN, [latex], { signal, timeout: TXM_TIMEOUT_MS });
			if (r.code !== 0) return null; // txm panics (exit 101) on malformed input
			const art = r.stdout.replace(/\n+$/, "");
			return art.includes("┌") ? art : null;
		} catch {
			return null;
		}
	}

	pi.on("session_start", async (_event, ctx) => {
		txmAvailable = await detectTxm();
		if (!txmAvailable && !warned && ctx.hasUI) {
			warned = true;
			ctx.ui.notify(
				`txm-latex: '${TXM_BIN}' not found. Install with 'cargo install txm' or set TXM_BIN.`,
				"warning",
			);
		}
	});

	pi.on("message_end", async (event, ctx) => {
		// Non-destructive: we read only and never return a replacement message.
		if (!txmAvailable || !ctx.hasUI) return;
		if (event.message.role !== "assistant") return;

		const text = extractText((event.message as any).content);
		if (!text) return;

		const spans = findLatex(text).slice(0, MAX_FORMULAS_PER_MESSAGE);
		if (spans.length === 0) return;

		const blocks: TexBlock[] = [];
		for (const span of spans) {
			const art = await renderLatex(span.latex, ctx.signal);
			if (art) blocks.push({ latex: span.latex, art });
		}

		if (blocks.length > 0) pi.appendEntry("tex-render", { blocks });
		// return undefined -> assistant message is left untouched
	});

	pi.registerEntryRenderer("tex-render", (entry, _options, theme) => {
		const blocks = ((entry.data as any)?.blocks ?? []) as TexBlock[];
		const parts: string[] = [];
		for (const b of blocks) {
			parts.push(theme.fg("dim", `tex: ${b.latex}`));
			parts.push(b.art);
		}
		return new Text(parts.join("\n"), 0, 0);
	});

	pi.registerCommand("tex", {
		description: "Render a LaTeX math expression with txm",
		handler: async (args, ctx) => {
			if (!txmAvailable) txmAvailable = await detectTxm();
			if (!txmAvailable) {
				ctx.ui.notify(`txm-latex: '${TXM_BIN}' not found.`, "error");
				return;
			}
			const latex = args.trim().replace(/^\$+|\$+$/g, "").trim();
			if (!latex) {
				ctx.ui.notify("Usage: /tex E = mc^2", "info");
				return;
			}
			const art = await renderLatex(latex, ctx.signal);
			if (!art) {
				ctx.ui.notify("txm could not render that expression.", "warning");
				return;
			}
			pi.appendEntry("tex-render", { blocks: [{ latex, art }] });
		},
	});
}
