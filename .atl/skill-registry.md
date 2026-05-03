# Skill Registry

**Delegator use only.** Any agent that launches sub-agents reads this registry to resolve compact rules, then injects them directly into sub-agent prompts. Sub-agents do NOT read this registry or individual SKILL.md files.

See `_shared/skill-resolver.md` for the full resolution protocol.

## User Skills

| Trigger | Skill | Path |
|---------|-------|------|
| When creating a pull request, opening a PR, or preparing changes for review | branch-pr | ~/.config/opencode/skills/branch-pr/SKILL.md |
| When creating a GitHub issue, reporting a bug, or requesting a feature | issue-creation | ~/.config/opencode/skills/issue-creation/SKILL.md |
| When writing Go tests, using teatest, or adding test coverage | go-testing | ~/.config/opencode/skills/go-testing/SKILL.md |
| When user says "judgment day", "judgment-day", "review adversarial", "dual review", "doble review", "juzgar", "que lo juzguen" | judgment-day | ~/.config/opencode/skills/judgment-day/SKILL.md |
| When user asks to create a new skill, add agent instructions, or document patterns for AI | skill-creator | ~/.config/opencode/skills/skill-creator/SKILL.md |

## Compact Rules

Pre-digested rules per skill. Delegators copy matching blocks into sub-agent prompts as `## Project Standards (auto-resolved)`.

### branch-pr
- Every PR MUST link an approved issue (`status:approved` label) — no exceptions
- Every PR MUST have exactly one `type:*` label
- Branch naming: `^(feat|fix|chore|docs|style|refactor|perf|test|build|ci|revert)\/[a-z0-9._-]+$`
- Commits MUST follow conventional commits: `type(scope)?: description`
- Run shellcheck on modified scripts before pushing
- PR body MUST contain: `Closes #N`, PR type checkbox, summary, changes table, test plan
- No `Co-Authored-By` trailers in commits

### issue-creation
- Blank issues are disabled — MUST use a template (Bug Report or Feature Request)
- Every issue gets `status:needs-review` automatically on creation
- A maintainer MUST add `status:approved` before any PR can be opened
- Questions go to Discussions, not issues
- Bug reports require: description, steps to reproduce, expected/actual behavior, OS, agent, shell
- Feature requests require: problem description, proposed solution, affected area

### go-testing
- Use table-driven tests for pure functions with multiple cases
- Test Bubbletea Model state transitions directly via `m.Update(tea.KeyMsg{...})`
- Use teatest.NewTestModel() for full TUI flow integration tests
- Use golden file testing for visual output comparison
- Mock system info via struct injection for controlled test environments
- Use `t.TempDir()` for file operation tests
- Organize tests as `*_test.go` alongside source files, `testdata/` for golden files

### judgment-day
- Launch TWO judge sub-agents via `delegate` (async, parallel) — never sequential
- Neither judge knows about the other — no cross-contamination
- Orchestrator synthesizes: Confirmed (both), Suspect A/B (one only), Contradiction (disagree)
- WARNING classification: real (normal user can trigger) vs theoretical (contrived scenario)
- After fixes, re-launch both judges in parallel for re-judgment
- After 2 fix iterations, ASK user before continuing — never escalate automatically
- MUST NOT declare APPROVED until: Round 1 CLEAN, or Round 2 with 0 CRITICALs + 0 real WARNINGs
- Orchestrator NEVER reviews code itself — only launches judges, reads results, synthesizes

### skill-creator
- Create skills when: pattern repeats, conventions differ, complex workflows, decision trees help
- Don't create when: docs exist, pattern trivial, one-off task
- Structure: `skills/{name}/SKILL.md` (required), `assets/` (templates), `references/` (local docs)
- Frontmatter required: name, description (with Trigger), license (Apache-2.0), metadata.author, metadata.version
- DO: start with critical patterns, use tables for decisions, minimal examples, include Commands section
- DON'T: add Keywords section, duplicate docs, lengthy explanations, web URLs in references
- Register skill in AGENTS.md after creation

## Project Conventions

| File | Path | Notes |
|------|------|-------|
| .gga | /home/lxuxer/proyectos/termux/termux-toolkit/.gga | GGA config — provider: claude, file patterns outdated (TS/TSX, project is Bash) |

No AGENTS.md, CLAUDE.md, .cursorrules, or other convention index files found in project root.

Read the convention files listed above for project-specific patterns and rules. All referenced paths have been extracted — no need to read index files to discover more.
