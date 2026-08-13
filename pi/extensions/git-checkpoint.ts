/**
 * VCS Checkpoint Extension
 *
 * Creates checkpoints at each turn so /fork can restore code state.
 * Supports both jj (Jujutsu) and git:
 *   - jj: records operation IDs, restores via `jj operation restore`
 *   - git: creates stash refs, restores via `git stash apply`
 *
 * When forking, offers to restore code to that point in history.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

type VCS = "jj" | "git";

async function detectVCS(pi: ExtensionAPI): Promise<VCS | null> {
	try {
		const { exitCode } = await pi.exec("jj", ["root"], { timeout: 3000 });
		if (exitCode === 0) return "jj";
	} catch {}
	try {
		const { exitCode } = await pi.exec("git", ["rev-parse", "--git-dir"], { timeout: 3000 });
		if (exitCode === 0) return "git";
	} catch {}
	return null;
}

export default function (pi: ExtensionAPI) {
	const checkpoints = new Map<string, string>();
	let currentEntryId: string | undefined;
	let vcs: VCS | null = null;

	pi.on("session_start", async () => {
		vcs = await detectVCS(pi);
	});

	pi.on("tool_result", async (_event, ctx) => {
		const leaf = ctx.sessionManager.getLeafEntry();
		if (leaf) currentEntryId = leaf.id;
	});

	pi.on("turn_start", async () => {
		if (!vcs || !currentEntryId) return;

		if (vcs === "jj") {
			// Record the current jj operation ID before the LLM makes changes
			const { stdout } = await pi.exec("jj", ["operation", "log", "--no-graph", "-T", "self.id()", "-l1"]);
			const opId = stdout.trim();
			if (opId) checkpoints.set(currentEntryId, opId);
		} else {
			// git: create a stash ref
			const { stdout } = await pi.exec("git", ["stash", "create"]);
			const ref = stdout.trim();
			if (ref) checkpoints.set(currentEntryId, ref);
		}
	});

	pi.on("session_before_fork", async (event, ctx) => {
		const ref = checkpoints.get(event.entryId);
		if (!ref || !vcs) return;

		if (!ctx.hasUI) return;

		const vcsLabel = vcs === "jj" ? "jj operation restore" : "git stash apply";
		const choice = await ctx.ui.select(
			`Restore code state via ${vcsLabel}?`,
			["Yes, restore code to that point", "No, keep current code"],
		);

		if (choice?.startsWith("Yes")) {
			if (vcs === "jj") {
				await pi.exec("jj", ["operation", "restore", ref]);
			} else {
				await pi.exec("git", ["stash", "apply", ref]);
			}
			ctx.ui.notify(`Code restored to checkpoint (${vcs})`, "info");
		}
	});

	pi.on("agent_end", async () => {
		checkpoints.clear();
	});
}
