---
name: safe-refactoring
description: >
  Refactor code safely by improving structure, names, and responsibilities while
  preserving existing behavior and avoiding unnecessary redesign.
  Trigger: when refactoring code, improving maintainability, simplifying complex logic,
  extracting functions, reducing duplication, or reorganizing code without changing behavior.
license: MIT
metadata:
  author: adanft
  version: "1.0"
---

# Safe Refactoring

Use this skill when the goal is to improve code structure without changing what
the code does. Refactoring is surgery, not a feature rewrite.

## When to Use

- Refactoring existing code.
- Improving names, function boundaries, or module boundaries.
- Reducing real duplication.
- Splitting long functions or classes.
- Separating side effects from pure logic.
- Making code easier to test without changing behavior.

## Critical Patterns

| Pattern | Rule |
|---------|------|
| Preserve behavior | Do not change outputs, side effects, public contracts, or error semantics unless explicitly requested. |
| Work in small steps | Prefer several safe improvements over one dramatic rewrite. |
| Lock behavior first | Use existing tests, add characterization tests, or document assumptions before risky changes. |
| Improve names before architecture | Many designs become obvious after concepts are named correctly. |
| Extract by intention | Extract functions around business meaning, not arbitrary line counts. |
| Separate effects | Pull calculations away from I/O, persistence, network calls, logging, and UI when useful. |
| Abstract late | Remove real duplication only when the abstraction has a clear name and one reason to change. |
| Stop before redesign | If the refactor requires a new architecture, call that out as a separate change. |

## Refactoring Workflow

1. State the current behavior that must not change.
2. Identify the smallest structural problem worth fixing now.
3. Check or add tests around important behavior when possible.
4. Rename unclear concepts.
5. Extract small functions or modules around intention.
6. Reduce nesting with guard clauses when it improves readability.
7. Remove duplication only when it is truly the same rule.
8. Review the diff for accidental behavior changes.

## Refactoring Moves

| Smell | Prefer |
|-------|--------|
| Long function | Extract intention-revealing functions. |
| Deep nesting | Use guard clauses or split cases. |
| Vague names | Rename to business meaning. |
| Repeated business rule | Extract a named rule/function/type. |
| Mixed validation, persistence, and notification | Split orchestration from details. |
| Global mutable dependency | Inject the dependency or wrap it behind a boundary. |
| Many flags | Replace with explicit states or separate flows. |
| Boolean hell | Replace flag-driven branching with explicit cases, state, or policies. |
| God object/class | Split by responsibility and reason to change. |
| Shotgun surgery | Move the rule behind one stable boundary. |
| Feature envy | Move behavior closer to the data/concept it uses most. |
| Primitive obsession | Introduce a named type or value object for important domain concepts. |
| Magic numbers | Replace with named constants or domain terms. |
| Temporal coupling | Make required order explicit in the API or workflow. |
| Anemic domain model | Move important domain behavior into entities, value objects, or domain services. |
| Overengineering | Remove abstractions, layers, or patterns that do not solve current complexity. |
| Spaghetti code | Untangle flow into named steps, guard clauses, and clear boundaries. |
| Copy-paste programming | Extract the shared rule only when duplicated code has the same reason to change. |
| Lava flow | Delete or isolate obsolete code once behavior is protected. |

## Code Examples

### Before

```js
function registerUser(user) {
  if (!user.email || !user.email.includes("@")) {
    throw new Error("Invalid email");
  }

  database.save(user);
  emailService.send(user.email, "Welcome");
}
```

### After

```js
function registerUser(user) {
  validateUserEmail(user.email);
  saveUser(user);
  sendWelcomeEmail(user.email);
}
```

## Do Not Do This During Refactoring

- Do not add unrelated features.
- Do not change API contracts silently.
- Do not replace the architecture just because the code is imperfect.
- Do not introduce patterns unless they reduce current complexity.
- Do not mix formatting-only changes with risky logic movement when avoidable.
- Do not refactor concurrency, migrations, or public API contracts without extra safety checks.

## Ready-to-use Pragmatic Refactoring Prompt

```txt
Refactor this code pragmatically without changing its current behavior.

Improve names, remove real duplication, separate responsibilities, improve visual
readability, apply SOLID only where it adds value, use patterns only when they
simplify the current code, avoid full Clean Architecture for small problems, and
improve testability.

Return: diagnosis, minimum recommended refactor, ideal refactor if the project
grows, improved code, and final checklist.
```

## Checklist

- [ ] Behavior is preserved.
- [ ] The diff is reviewable.
- [ ] Names are clearer.
- [ ] Functions or modules now have sharper responsibilities.
- [ ] Tests were considered or updated for important behavior.
- [ ] No unnecessary framework, pattern, or architecture was introduced.

## Commands

```bash
# Check for whitespace and conflict-marker issues
git diff --check

# Review refactor size before handing it off
git diff --stat
```
