---
name: engineering-practices
description: >
  Maintain healthy engineering workflows through documentation, ADRs, developer
  experience, quality tools, CI, code review, Git hygiene, maintainability, and
  learning order for good software craftsmanship.
  Trigger: when improving documentation, developer workflow, quality gates,
  team practices, Git/PR habits, maintainability checklists, or learning paths.
license: MIT
metadata:
  author: adanft
  version: "1.0"
---

# Engineering Practices

Use this skill for the practices around the code: documentation, quality gates,
Git hygiene, reviewability, maintainability, and learning order. Good code lives
inside a system of habits.

## When to Use

- Writing README, ADRs, API docs, changelogs, or architecture notes.
- Improving developer experience or project quality tools.
- Setting up formatter, linter, type checker, tests, CI, hooks, coverage, or dependency scanning.
- Planning commits, branches, PRs, and reviewable work units.
- Creating maintainability checklists.
- Explaining how to learn good code topics in order.

## Critical Patterns

| Pattern | Rule |
|---------|------|
| Automate repetition | Formatters, linters, type checkers, tests, and CI should catch repeatable issues. |
| Document decisions | Use comments for non-obvious why, ADRs for architecture decisions, README for usage. |
| Reviewable units | Small commits and focused PRs beat giant mixed changes. |
| No secrets | Never commit tokens, passwords, keys, credentials, or sensitive local config. |
| Maintainability first | Code should be easy to understand, change, test, and safely delete. |
| Progressive learning | Learn clarity and testing before advanced architecture patterns. |

## Documentation Guide

| Doc type | Use for |
|----------|---------|
| README | How to run, understand, and contribute to the project. |
| Comments | Why a non-obvious decision exists, not what obvious code does. |
| ADR | Architecture decision, alternatives, tradeoffs, consequences. |
| API docs | Contracts, inputs, outputs, auth, errors, examples. |
| Changelog | User-visible or operationally important changes. |
| Diagram | Simple system/module flow when text becomes harder to follow. |

## Quality Tooling

| Tool | Purpose |
|------|---------|
| Formatter | Removes formatting debates. |
| Linter | Catches common mistakes and style rules. |
| Type checker | Catches invalid shapes and contracts early. |
| Automated tests | Prove behavior before merge/deploy. |
| CI/CD | Runs quality gates consistently. |
| Dependency scanner | Finds known vulnerable packages. |
| Code review | Reviews human decisions and tradeoffs. |
| Git hooks | Prevents obvious bad commits locally. |
| Coverage | Reveals untested areas; do not worship the number blindly. |

## Git and Teamwork Rules

- Keep commits small and cohesive.
- Use clear commit messages that explain the change.
- Keep one feature/fix per branch when practical.
- Keep PRs reviewable; avoid mixing refactors, formatting, and features unnecessarily.
- Check diffs before committing.
- Never commit secrets.
- Resolve conflicts deliberately, not by blindly accepting one side.

## Learning Order

| Level | Focus |
|-------|-------|
| 1 | Readability, names, small functions, visual order. |
| 2 | KISS, YAGNI, DRY/WET, responsibilities. |
| 3 | Testing basics and safe refactoring. |
| 4 | OOP well-used and functional core ideas. |
| 5 | SOLID and dependency inversion. |
| 6 | Design patterns as problem-specific tools. |
| 7 | Layered architecture and boundaries. |
| 8 | Clean Architecture and data/API design. |
| 9 | Security, errors, observability, performance. |
| 10 | DDD, concurrency, distributed systems, cloud. |

## Good Code Formula

```txt
Good code =
  correctness
+ clarity
+ simplicity
+ separation of concerns
+ low coupling
+ high cohesion
+ clear errors
+ testability
+ security
+ proportional architecture
+ discipline against overengineering
```

## Master Decision Rule

| Step | Rule |
|------|------|
| 1 | Understand the real problem and current constraints. |
| 2 | Start with the simplest correct solution. |
| 3 | Measure or observe real pain before optimizing or adding architecture. |
| 4 | Refactor when the current structure makes change harder. |
| 5 | Add patterns only when the code asks for them. |

## Final Decision Questions

- Which option is easier to understand?
- Which option is easier to test?
- Which option changes fewer parts of the system?
- Which option is safer for data, users, and operations?
- Which option is proportional to the real problem?
- Which option will be easier to maintain six months from now?

The best solution is not always the shortest, most advanced, or most architectural.
It is the one that solves the real problem with the least sustainable complexity.

## Maintainability Checklist

- [ ] The next engineer can understand the intent quickly.
- [ ] Important decisions are documented or obvious from names/structure.
- [ ] Quality gates are automated where possible.
- [ ] The change is reviewable.
- [ ] The code can be tested in useful pieces.
- [ ] Old code can be safely changed or deleted when needed.

## Commands

```bash
# Review changed files before commit or PR
git status --short

# Inspect local changes for reviewability
git diff --stat
```
