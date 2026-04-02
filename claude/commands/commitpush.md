Create exactly ONE commit with ALL staged changes, then push.

## 1. Gather context

Run these three commands in parallel:
- `git status --short`
- `git diff --stat` (staged + unstaged)
- `git log --oneline -5`

## 2. Stage and commit

- Stage changed files by name (never `git add .` or `git add -A`)
- If `$ARGUMENTS` is provided, use it as the commit message directly
- Otherwise, write a concise commit message:
  - Imperative mood ("Add feature" not "Added feature")
  - Subject line under 72 characters, no trailing period
  - Body only if the change needs explanation
- Append this trailer to every commit message:
  Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>

## 3. Push

Run `git push`. If there is no upstream tracking branch, use `git push -u origin HEAD`.

## Rules

- Create exactly ONE commit. Do NOT create multiple commits.
- If a pre-commit hook fails, fix the issue and retry the SAME commit — do NOT create additional commits.
- Do NOT use the Agent or TodoWrite tools.
- Do NOT run `git status` after pushing.
