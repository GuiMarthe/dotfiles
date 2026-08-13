# Career Coach Skill for Claude Code

A Claude Code skill that runs a structured career coaching session and produces a Career Blueprint (a markdown document with goals, skills assessment, and a milestone-based development plan).

## What it does

The skill turns Claude into a career development coach that guides you through a 20-30 exchange discovery conversation. It asks about your background, what drives you, where you want to go, and what's actually realistic given your constraints. At the end, it writes a `career-blueprint.md` file to your working directory with everything organized into a format you can revisit and update over time.

The coaching methodology is a 5-phase process:

1. **Document Analysis** — Reviews your resume, portfolio, or whatever professional context you provide (including files on disk)
2. **Guided Discovery** — Conversational interview covering your current reality, future vision, and development path
3. **Skills Assessment** — Evidence-based method that separates actual skills from experiences and catches impostor syndrome
4. **Goal Synthesis** — Drafts goals across 1-year, 3-year, 5-year, 10-15 year, and ultimate time horizons
5. **Milestones** — Concrete next steps with success criteria, timelines, and an accountability structure

The output covers career goals, a categorized skills inventory (current and desired, each tied to evidence or a specific goal), immediate actions for this week, and a reflection section that captures trade-offs, constraints, and whether the plan actually feels authentic.

## Install

```bash
npx skills add ryanxkh/career-coach-skill
```

Or clone it and symlink manually:

```bash
git clone https://github.com/ryanxkh/career-coach-skill.git
ln -s "$(pwd)/career-coach-skill" ~/.claude/skills/career-coach
```

## Usage

Start a Claude Code session and say something like:

- "coach me"
- "career blueprint"
- "help me think through my career direction"

The skill activates automatically based on the description in `SKILL.md`. You can also invoke it directly with `/career-coach`.

For the best results, have a resume or professional summary ready. You can paste it into the conversation or point Claude to a file path and it will read it. The process works without materials too, it just takes a bit longer because the coach needs to build context through conversation instead.

## What the blueprint looks like

The final `career-blueprint.md` includes:

- **Career Goals** across five time horizons (1yr through ultimate)
- **Current Skills** with evidence from your actual accomplishments
- **Desired Skills** connected to specific goals and distinguished from experiences
- **Immediate Actions** for this week
- **Milestone Tracker** with due dates, status, and success criteria
- **Reflection** covering motivation, trade-offs, constraints, and accountability

## How the coaching works

The methodology was built through A/B testing across synthetic personas, universality testing across healthcare, creative, sales, and engineering backgrounds, and GTM bias testing across 7 personas. It's designed to work regardless of industry, career stage, or whether you follow a traditional career ladder.

A few things the coach does that are worth calling out: it catches "should" language (when you say what you think you're supposed to want instead of what you actually want), it challenges impostor syndrome with your own evidence, it separates skills from experiences explicitly and teaches you the test so you can use it on your own, and it names its own biases when it notices them influencing the conversation.

It also won't let you skip phases because you're excited about a specific company or actively interviewing. The blueprint is the product, and the process exists to make sure it's grounded in self-understanding rather than built around whatever opportunity happens to be in front of you right now.

## Background

This skill is adapted from the Universal Career Development Coaching Prompt v3.7, which also powers the [Career Blueprint web app](https://career-blueprint-eight.vercel.app/). The web app runs the same coaching methodology through a browser-based chat interface with persistence, auth, and a visual blueprint viewer. The skill is the same coaching experience in your terminal.

## License

MIT
