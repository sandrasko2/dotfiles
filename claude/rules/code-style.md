---
description: Cross-language code style conventions
globs:
---

# Code Style

## General
- Clarity over cleverness — no over-engineering, no unrequested features
- Comment why, not what — let formatters handle formatting
- Do not add docstrings, comments, or type annotations to code you did not change

## Python
- Type hints on all function signatures
- pyright strict mode compliance
- ruff for formatting and linting
- Prefer Polars over pandas for new code (lazy API where possible)

## TypeScript
- strict mode enabled
- prettier for formatting
