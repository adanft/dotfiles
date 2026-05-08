---
name: code-quality
description: >
  Apply universal code quality principles to write or improve clear, simple,
  maintainable, testable, and secure code.
  Trigger: when creating code, improving implementation quality, choosing structure,
  naming things, separating responsibilities, or checking general code quality.
license: MIT
metadata:
  author: adanft
  version: "1.0"
---

# Code Quality

Use this skill to keep code correct, readable, simple, maintainable, testable,
secure, and proportional to the problem being solved.

## When to Use

- Writing new code.
- Improving existing code quality.
- Choosing names, function boundaries, or module structure.
- Separating responsibilities.
- Reducing real duplication.
- Checking if a solution is too clever, too coupled, or overengineered.

## Critical Patterns

| Pattern | Rule |
|---------|------|
| Clean code objective | Optimize for code another person can quickly understand, safely modify, and maintain. |
| Correctness first | Make the behavior right before polishing the structure. |
| Default priority | Prefer clarity, simplicity, visual order, and maintainability before performance unless performance is critical. |
| Clarity over cleverness | Prefer code that is obvious to maintainers over code that looks advanced. |
| Proportional design | Match architecture to the actual size, risk, and complexity of the problem. |
| KISS | Use the simplest complete solution that can be understood and maintained. |
| YAGNI | Do not build abstractions, configuration, plugins, or layers for imaginary futures. |
| DRY with restraint | Remove duplicated business logic, but tolerate small repetition before creating a bad abstraction. |
| Visual order | Use whitespace, grouping, indentation, line length, and extracted conditions to make intent scannable. |
| Logical file order | Prefer predictable file shape: imports/dependencies, constants, types/models, main behavior, helpers, exports. |
| Separation of concerns | Keep UI, business rules, persistence, external APIs, and formatting in separate places when the problem justifies it. |
| High cohesion | Keep related behavior together around one clear concept. |
| Low coupling | Make modules depend on as little as practical, especially across volatile boundaries. |
| Fail fast | Validate external input early and fail with clear, safe error messages. |
| Least surprise | Names should match behavior; `getUser` must not delete or mutate unrelated data. |
| Composition first | Prefer composed behavior and explicit dependencies over deep inheritance or hidden globals. |
| Explicit contracts | Make preconditions, postconditions, invariants, inputs, outputs, errors, and assumptions visible in code or tests. |
| Invalid states are hard | Use types, enums, value objects, validation, or clear structures so critical invalid data is difficult to represent. |
| Predictable functions | Keep parameters and returns explicit; avoid hidden mutation, globals, invisible dependencies, and surprising side effects. |
| Idiomatic code | Respect the language/ecosystem style; do not force patterns from another language when a simpler native solution exists. |
| Testability | Prefer small functions, explicit dependencies, pure logic, and isolated side effects. |
| Security by default | Treat user input, files, headers, cookies, environment variables, and external APIs as untrusted. |

## Default Workflow

1. Understand the behavior and business rules before writing code.
2. Start with the simplest complete implementation.
3. Name concepts clearly: functions as actions, booleans as questions, types/classes as domain concepts.
4. Separate pure logic from side effects when it improves testability.
5. Extract functions or modules only when they reduce complexity.
6. Validate external input and produce clear errors.
7. Add or update relevant tests when behavior changes.
8. Re-check for overengineering before finishing.

## Decision Rules

| Situation | Prefer |
|-----------|--------|
| One simple case | Direct code, no pattern ceremony. |
| Repeated business rule with one reason to change | Extract a named function, type, or module. |
| Similar code with different reasons to change | Keep duplication until the abstraction is obvious. |
| External provider/API | Hide it behind a small adapter or boundary. |
| Important domain concept represented by primitives | Consider a value object or named type. |
| Many related parameters | Prefer a named parameter object or value object. |
| Many boolean flags controlling behavior | Split flows, introduce explicit state, or name the rule. |
| Critical side effect | Add validation, clear errors, logging context, and idempotency when needed. |

## Related Skills

Use `code-quality` as the base skill, then load the more specific skill when the
task needs depth:

| Need | Skill |
|------|-------|
| SOLID, OOP, FP, design patterns | `design-principles` |
| Tests and testability strategy | `testing-strategy` |
| Security and error handling | `secure-error-handling` |
| Performance, concurrency, idempotency | `performance-reliability` |
| API/database contracts and data integrity | `api-data-design` |
| Docs, tooling, Git, maintainability habits | `engineering-practices` |

## Code Examples

### Name important conditions

```js
const canPurchase =
  user.age >= 18 &&
  user.status === "active" &&
  user.balance > 0 &&
  !user.blocked;

if (canPurchase) {
  allowPurchase();
}
```

### Inject dependencies that need to be replaced in tests

```js
function createUser(userData, userRepository) {
  validateUserData(userData);

  return userRepository.save(userData);
}
```

## Checklist

- [ ] Behavior is correct.
- [ ] Names explain intent.
- [ ] Functions and modules have clear responsibilities.
- [ ] Visual grouping, whitespace, indentation, and line lengths support quick reading.
- [ ] Conditions read like phrases or are extracted into named variables/functions.
- [ ] Files have one clear purpose and predictable internal order.
- [ ] Parameters and return values are explicit and not surprising.
- [ ] The solution is not bigger than the problem.
- [ ] Real duplication is reduced without premature abstraction.
- [ ] External input is validated.
- [ ] Critical preconditions, postconditions, invariants, and assumptions are explicit.
- [ ] Important invalid states are hard to represent or rejected at boundaries.
- [ ] Errors are clear and do not expose secrets.
- [ ] Important behavior is testable.
- [ ] Style, names, file structure, imports, errors, and tests are consistent with the surrounding code.
- [ ] A future maintainer can modify this without reconstructing hidden context.
- [ ] API, database, concurrency, and production risks were considered when relevant.
- [ ] The implementation fits the idioms of the language/ecosystem.
- [ ] Formatter, linter, type checker, and tests were run when available and appropriate.

## Commands

```bash
# Check whitespace and conflict-marker issues before finishing
git diff --check

# Review the size and shape of local changes
git diff --stat
```
