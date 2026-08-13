/**
 * Permission Gate Extension
 *
 * Prompts for confirmation before running potentially dangerous bash commands.
 * Patterns checked: rm -rf, sudo, chmod/chown 777
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	const dangerousPatterns = [/\brm\s+(-rf?|--recursive)/i, /\bsudo\b/i, /\b(chmod|chown)\b.*777/i];

	// Per-session approved commands (cleared on session start)
	const sessionApprovals = new Set<string>();

	pi.on("session_start", () => {
		sessionApprovals.clear();
	});

	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName !== "bash") return undefined;

		const command = event.input.command as string;
		const isDangerous = dangerousPatterns.some((p) => p.test(command));

		if (isDangerous) {
			// Check if already approved this session
			const approvalKey = dangerousPatterns.find((p) => p.test(command))?.source ?? command;
			if (sessionApprovals.has(approvalKey)) return undefined;

			if (!ctx.hasUI) {
				return { block: true, reason: "Dangerous command blocked (no UI for confirmation)" };
			}

			const choice = await ctx.ui.select(
				`⚠️ Dangerous command:\n\n  ${command}\n\nAllow?`,
				["Yes (once)", "Yes (this session)", "No"],
			);

			if (choice === "No") {
				return { block: true, reason: "Blocked by user" };
			}

			if (choice === "Yes (this session)") {
				sessionApprovals.add(approvalKey);
			}
		}

		return undefined;
	});
}
