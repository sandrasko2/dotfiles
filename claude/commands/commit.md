Run `git status --short`, `git diff --stat` (staged + unstaged), and `git log --oneline -5` to see the changes and recent commit style.

If $ARGUMENTS is provided, use it as the commit message directly. Otherwise, write a concise commit message following these rules:
- Imperative mood ("Add feature" not "Added feature")
- Subject line under 72 characters
- No period at the end of the subject
- Body only if the change needs explanation

Stage files by name (never `git add .` or `git add -A`).

Append this trailer to the commit message:
Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>

Do NOT run `git status` after committing. Do NOT use the Agent or TodoWrite tools.
