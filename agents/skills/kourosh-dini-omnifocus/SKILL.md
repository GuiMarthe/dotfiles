---
name: kourosh-dini-omnifocus
description: >
  Summarize, explain, and advise on how this user applies the Kourosh Dini
  OmniFocus framework. Trigger for questions about their task management system,
  OmniFocus structure, settle/shutdown rituals, parked/engaged/planned
  activations, the consume/reading queue, the Miscellaneous project, tags, or
  anything touching this person's productivity workflow.
---

# Kourosh Dini OmniFocus — Personal Implementation

Inferred directly from the OmniFocus database.

---

## Navigation Folder (the cockpit)

Flagged projects always visible in the Flagged perspective.

| Project | Status | Purpose |
|---------|--------|---------|
| `routine` | active, flagged | Time-anchored recurring habits |
| `engaged` | active, flagged | Current deep-focus project (pointer layer) |
| `planned activations` | active, flagged | Scheduled "Considere…" soft reminders |
| `parked` | **on hold** | Holding area for potential recurring tasks |

### `routine`
Habits anchored to `manhã`/`noite` tags. Tasks link via `omnifocus:///` deep
links to detailed checklist projects in `Rotinas Explicitas` — `routine` is a
*trigger layer*, not where the steps live.
- "Considere pagar as contas" — monthly, `consider`
- "Preparar para corrida amanhã cedo" — Tue/Thu, `noite`, links to checklist

### `engaged`
One project gets focused attention. Tasks point (via note deep links) to the
actual project in a domain folder. `engaged` is a window, not where work lives.
- Current: "artigo de temas…dissertação" — daily, links to `orientador` (USP)

### `planned activations`
Recurring soft reminders ("Considere…"); user chooses yes/no each time.
- "Considere mandar msg para a mãe" — Mon/Wed/Fri, `zap`, `consider`
- "Considere rever as tarefas com o orientador" — weekly Tue, `mestrado`
- "revisão profunda de melhorias da casa" — monthly, links to household project
- "Tomar venvance!" — daily medication

### `parked`
On-hold container; tasks are blocked/invisible. Holds two ritual checklists
("Settle!!" and "Shudown!!" are their recurring triggers, also in `parked`).

**`settle` ritual** (morning, tagged `settle`):
clear inbox → review navigation perspective → review forecast → clear review
→ review flagged → review latam perspective → review this week → review house
tasks in reminders

**`shutdown` ritual** (end-of-day, tagged `shutdown`):
mind dump to inbox → mark completed → review accomplishments → reschedule
incomplete → review tomorrow's forecast → flag tomorrow's priorities → clear
desktop/inbox → commit to git → say "shutdown complete"

Each step has an `omnifocus:///` deep link to the exact perspective or app.

---

## Domain Folders

| Folder | Domain |
|--------|--------|
| `latam` | Work — Latin America data science |
| `tw` | Work — Thoughtworks |
| `USP` | Academic — Master's/PhD (statistics, articles, advisor) |
| `household` | Home, family, finance, pets, friends |
| `rest > personal` | Health, consumption, tools/courses |
| `rest` | Contains `eventualmente` (someday/maybe) |
| `Rotinas Explicitas` | Detailed physical routine checklists |
| `projetos` | Personal side projects |
| `Templates` | Reusable project checklists (e.g. beach trip) |

**Communications pattern:** every domain has a `communications - [domain]`
project for tracking emails, follow-ups, and messages.

**Ideas (USP):** `USP > ideas` folder captures academic writing ideas —
`posts and documents` project and specific paper idea projects.

---

## Rotinas Explicitas

Holds the actual step-by-step checklist projects that `routine` tasks point to.
- `Preparar para corrida` (13 tasks) — running prep
- `Medicamentos da Manhã` — morning medications
- `Medicamentos da Noite` — night medications

---

## Catch-All Projects

**`Miscellaneous`** (no folder, ~65 tasks) — primary landing zone for one-off
tasks without a domain home: purchases (`comprar`/`compras`/`roupas`), media
queue (`consume`/`reading`/`learning` + URL), stray work tasks, small ideas.
Distinct from `eventualmente` (longer horizon) and `consume` (older backlog).

**`consume`** (`rest > personal`, ~43 tasks) — older reading/learning backlog
(since July 2024). Overlaps with `Miscellaneous`. An open `eventualmente`
sub-task exists to consolidate both into one perspective.

**`eventualmente`** (`rest`, ~20 tasks) — someday/maybe list. Also contains
"Revisar melhorias no omnifocus" (recurring every 2 weeks), a meta-review of
the OmniFocus setup itself with sub-tasks like "review engaged tasks" and
"organize consumption into a single perspective".

---

## Tags

**Ritual:** `settle`, `shutdown`

**Time-of-day** (mutually exclusive under parent `rotina`): `manhã`, `noite`

**Scheduling:** `fds` (fins de semana / weekend), `this week`,
`cursos-2026` (annual course batching)

**Effort/mode:** `consider` (soft invitation), `now` (urgent), `quick`/`slow`,
`leftover` (carried over from previous day)

**Context:** `computer`, `mobile`, `web`, `email`, `zap` (channel);
`Home`, `work`, `real parque`, `são paulo`, `errands` (location);
`comprar`, `compras`, `mercado`, `miniso` (purchasing)

**People:** `Gilberto` (advisor), `Igor` (USP colleague), `mãe`, `pai`,
`livs`, `Tatiane` (family), `PA` (assistant)

**Domain:** `latam`, `usp`, `tw`, `mestrado`, `Academic`, `Thoughtworks`

**Work-type:** `writting`, `planning`, `reflect`, `organize`, `create`,
`reading`, `research`, `learning`, `consume`, `data-prep`, `analysis`,
`visualization`, `documentation`, `validation`, `functions`, `latex`, `jira`

**Housekeeping:** `dropped` (soft-marked stale, not system-dropped),
`resources` (reference items)

---

## Deep Linking Convention

Note fields store `omnifocus:///` links to projects, perspectives, and tasks,
separating *what to attend to* (Navigation layer) from *where work lives*
(Project layer). Also present: `obsidian://` links — Obsidian is a companion
note-taking tool.

---

## Review Cadences

| Frequency | Projects |
|-----------|---------|
| Weekly | engaged, planned activations, latam general, communications |
| Bi-weekly | routine, Melhorias da casa, ferramentas e cursos |
| 3-weekly | most USP, household, latam |
| Monthly | parked, manutenção carro, health |
| 2-monthly | general usp |
| 10-weekly | site pessoal (on hold) |

---

## "Consider" Pattern

Core Dini principle: frame recurring tasks as *invitations* to reduce
resistance. Applied as: name "Considere [X]" + tag `consider` + place in
`planned activations` with recurrence.

---

## Advising on This System

| Situation | Where it goes |
|-----------|--------------|
| New recurring habit | `routine` (manhã/noite + recurrence); if multi-step, add checklist to `Rotinas Explicitas` + deep link |
| New focus project | Update `engaged` with pointer task (deep link note) to project in domain folder |
| New soft reminder | `planned activations`, "Considere…" framing, `consider` tag, recurrence |
| One-off errand / article | `Miscellaneous` with appropriate tag |
| Long-horizon someday | `eventualmente` |
| New domain project | Domain folder, 3-week review default; add `communications - [domain]` if needed |
| Ritual change | Edit task group in `parked` (`settle` or `shutdown`) |
| Weekend task | Tag `fds` + `slow` |
| System improvement idea | Sub-task under "Revisar melhorias no omnifocus" in `eventualmente` |
| Repeatable project template | `Templates` folder, on-hold |
