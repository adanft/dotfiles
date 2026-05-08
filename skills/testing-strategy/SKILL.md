---
name: testing-strategy
description: >
  Design and review test coverage across unit, integration, end-to-end,
  contract, regression, smoke, and load tests with a practical testing pyramid.
  Trigger: when adding tests, improving testability, choosing test types,
  reviewing coverage, preventing regressions, or validating risky changes.
license: MIT
metadata:
  author: adanft
  version: "1.0"
---

# Testing Strategy

Use this skill to choose the right tests for the risk. Good tests protect
behavior without making refactors painful.

## When to Use

- Adding tests for new behavior.
- Covering a bug fix with regression tests.
- Deciding between unit, integration, e2e, contract, smoke, or load tests.
- Making code easier to test.
- Reviewing whether a change is safe to merge.
- Designing test seams around side effects, providers, databases, or APIs.

## Critical Patterns

| Pattern | Rule |
|---------|------|
| Behavior over implementation | Test observable behavior, not private structure. |
| Pyramid by default | Many unit tests, some integration tests, few end-to-end tests. |
| Risk-based coverage | Critical, complex, or frequently changed logic deserves stronger tests. |
| Regression safety | Every fixed bug should get a test that would have failed before the fix. |
| Stable test seams | Inject dependencies or use ports/fakes for external effects. |
| Fast feedback | Keep most tests fast enough to run often. |
| Determinism | Avoid time, network, randomness, and global state unless controlled. |
| Clear failures | A failing test should explain the broken behavior quickly. |

## Test Type Guide

| Test type | What it proves | Use when |
|-----------|----------------|----------|
| Unit | One function/class/module in isolation. | Business rules, pure logic, edge cases. |
| Integration | Multiple real pieces working together. | Database, framework, provider adapter, module interaction. |
| End-to-end | A full user/system flow. | Critical flows like checkout, login, payment. |
| Contract | An API/provider honors an agreed interface. | Multiple services or external integrations depend on a shape. |
| Regression | A known bug does not return. | After fixing production or reported bugs. |
| Smoke | The app's basic path is not completely broken. | Deployments, CI sanity checks, startup checks. |
| Load | Behavior under volume/concurrency. | Performance or capacity is a real requirement. |

## Testability Checklist

- [ ] Business rules can be tested without DB, HTTP, UI, or network.
- [ ] Dependencies can be injected, faked, or adapted.
- [ ] Controllers/routes contain minimal logic.
- [ ] Side effects are separated from calculations where useful.
- [ ] Error paths and edge cases are covered for important behavior.
- [ ] Tests use meaningful names and arrange/act/assert structure.
- [ ] No test depends on hidden order, local machine state, or real time unless controlled.

## What to Avoid

- Testing only happy paths.
- Mocking so much that no real behavior is proven.
- Giant e2e suites for logic that belongs in unit tests.
- Snapshot tests that hide important behavior changes.
- Flaky tests accepted as normal. Flaky tests destroy trust.

## Commands

```bash
# Discover likely project test commands from changed files/config
git diff --name-only

# Check test-related changes before review
git diff --stat
```
