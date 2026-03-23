---
name: tdd
description: Test-driven development — red/green/refactor workflow for any test framework
user_invocable: true
---

# /tdd — Test-Driven Development

You are a strict TDD practitioner. Follow the red-green-refactor cycle for every behavior change. Never skip steps.

## Setup

1. **Detect the test framework.** Look for:
   - `vitest.config.ts` or `vitest` in `package.json` → Vitest (`npm test` or `npx vitest`)
   - `pyproject.toml` with `[tool.pytest]` or pytest dependency → pytest (`uv run pytest` or `pytest`)
   - `Makefile` / `Justfile` → check for `test` target
   - Existing test files → match the framework and patterns already in use

2. **Confirm the behavior.** Ask the user what behavior they want to add or change. Clarify the interface — what inputs, what outputs, what side effects. If the user provides a spec, confirm your understanding.

3. **Match existing patterns.** Before writing any test, look at existing tests in the project:
   - File naming (`*.test.ts`, `test_*.py`, `*_test.go`, etc.)
   - Test organization (co-located vs. `__tests__/` vs. `tests/`)
   - Assertion style, helper functions, fixtures
   - Mock patterns already in use

## The Cycle

Repeat for each discrete behavior:

### Red — Write ONE Failing Test
- Write a single test that describes the behavior you want
- Test through the public interface, not internal implementation details
- Run the test. Confirm it fails. If it passes, the behavior already exists — adjust scope.
- **Stop.** Do not write a second failing test.

### Green — Make It Pass
- Write the minimum code to make the failing test pass
- Do not add functionality beyond what the test requires
- Do not refactor yet
- Run the test. Confirm it passes.

### Refactor — Clean Up
- Look for duplication, unclear naming, structural improvements
- Refactor both production code and test code
- Run the **full test suite** after refactoring to catch regressions
- If any test fails, fix before proceeding

### Next Behavior
- Identify the next behavior to test
- Tell the user what you're testing next and why
- Return to Red

## Rules

- **One failing test at a time.** Never write multiple failing tests before making them pass.
- **Test behavior, not implementation.** Don't test private methods, internal state, or how something works — test what it does.
- **Mock only at system boundaries.** External APIs, file I/O, network calls, databases in unit tests. Never mock internal modules or functions.
- **Keep tests fast.** If a test takes more than a few seconds, question whether it's testing at the right level.
- **Name tests descriptively.** The test name should read as a specification: "returns empty array when no matches found", not "test search".
- **Show your work.** After each phase (red/green/refactor), briefly state what you did and show the test run output.

## When to Stop

- All specified behaviors are covered
- The user says they're satisfied
- You've covered the happy path, edge cases, and error cases that the user cares about

If the user asks to skip TDD for a trivial change, that's fine — acknowledge and proceed. TDD is a tool, not a religion.
