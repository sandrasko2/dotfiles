---
description: Git workflow conventions applied to all repositories
globs:
---

# Git Workflow

- Conventional commits: imperative mood, subject line under 72 characters, no trailing period
- Never force push or `git reset --hard` without explicit user confirmation
- Never amend published (pushed) commits without asking
- Stage files by name — never use `git add .` or `git add -A`
- Check `git status` before committing to avoid surprise inclusions
