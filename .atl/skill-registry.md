# Skill Registry — docker-ci-container

Generated: 2026-04-21
Project: docker-ci-container
Stack: Docker / Nginx / PHP 7.4 / MariaDB / CodeIgniter 3

---

## User Skills

| Skill | Trigger |
|-------|---------|
| `branch-pr` | Creating a PR, opening a PR, preparing changes for review |
| `go-testing` | Writing Go tests, Bubbletea TUI testing, test coverage |
| `issue-creation` | Creating GitHub issues, bug reports, feature requests |
| `judgment-day` | "judgment day", "dual review", "juzgar", adversarial review |
| `skill-creator` | Creating a new skill, adding agent instructions |
| `skill-registry` | "update skills", "skill registry", after installing/removing skills |

---

## Compact Rules

### branch-pr
- Always create issue FIRST (issue-first enforcement)
- PR title: `type(scope): description` (Conventional Commits)
- Include issue reference in PR body (`Closes #N`)
- Run tests/lint before opening PR
- Branch naming: `type/short-description`

### go-testing
- Table-driven tests with `t.Run` subtests
- Use `teatest` for Bubbletea TUI components
- Golden file testing for snapshot assertions
- Integration tests use real dependencies, no mocks
- `t.Cleanup` for resource teardown

### issue-creation
- Issue-first: create issue before any branch or PR
- Bug: steps to reproduce + expected vs actual behavior
- Feature: user story format ("As a X, I want Y so that Z")
- Add labels: `bug`, `enhancement`, `documentation`
- Link related issues/PRs

### judgment-day
- Launches 2 independent blind judge sub-agents simultaneously
- Agents review same target with NO knowledge of each other
- Synthesize findings, apply fixes, re-judge (max 2 iterations)
- Escalate if both don't pass after 2 rounds
- Use for pre-merge reviews on significant changes

### skill-creator
- Follow Agent Skills spec format with frontmatter
- Include: name, description, trigger, when-to-use, rules
- Write compact rules (5-15 lines) for registry injection
- Skills live in `~/.claude/skills/{name}/SKILL.md`
- Test skill by triggering it in a real scenario

### skill-registry
- Scan all `*/SKILL.md` across user + project skill dirs
- Deduplicate by name (project-level wins)
- Write `.atl/skill-registry.md` (always, mode-independent)
- Save to engram with topic_key `skill-registry`
- Re-run after any skill install/remove

---

## Project Conventions

No project-level CLAUDE.md, AGENTS.md, or .cursorrules found.
Global conventions from `~/.claude/CLAUDE.md` apply.

### Key Global Rules
- No `cat/grep/find/sed/ls` → use `bat/rg/fd/sd/eza`
- Conventional Commits only (no AI attribution)
- Never build after changes
- Verify claims before stating them
- Spanish input → Rioplatense voseo response
