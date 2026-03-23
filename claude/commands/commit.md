Run `git diff --cached --stat` to see staged changes. If nothing is staged, run `git diff --stat` and suggest what to stage.

Write a concise commit message following these rules:
- Imperative mood ("Add feature" not "Added feature")
- Subject line under 72 characters
- No period at the end of the subject
- Body only if the change needs explanation

Stage files by name (never `git add .` or `git add -A`).

Append this trailer to the commit message:
Co-Authored-By: Claude <noreply@anthropic.com>

Do NOT run `git status` after committing.
