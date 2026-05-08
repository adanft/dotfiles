# Good Code Skill Selection Guide

Use this guide to choose the right skill set for a project without loading every
skill every time. Start small, then add specialized skills when the work touches
that risk area.

## Quick rule

Always start with `code-quality`. Add only the skills that match the project,
change, or review risk.

For small changes, `code-quality` plus one specific skill is usually enough.

```txt
Base skill + project context + current risk = right skill set
```

## Skill catalog

| Skill | Use when |
|---|---|
| `code-quality` | Writing or improving clear, simple, maintainable code. This is the default baseline. |
| `design-principles` | Designing code-level responsibilities, SOLID/OOP/FP choices, dependency inversion, or design patterns. |
| `pragmatic-code-review` | Reviewing code or PRs with risk-based feedback and no unnecessary redesign. |
| `safe-refactoring` | Changing structure safely while preserving existing behavior. |
| `proportional-architecture` | Designing system/module boundaries, architecture shape, DDD, or Clean Architecture only when justified. |
| `testing-strategy` | Adding tests, improving testability, or choosing test types. |
| `secure-error-handling` | Handling validation, auth/authz, secrets, safe errors, or security risks. |
| `performance-reliability` | Handling performance, concurrency, async jobs, retries, timeouts, idempotency, or resources. |
| `api-data-design` | Designing APIs, schemas, contracts, migrations, transactions, indexes, or data integrity. |
| `engineering-practices` | Improving docs, ADRs, tooling, CI, Git workflow, maintainability, or team practices. |
| `nextjs-project-structure` | Structuring small, medium, and large Next.js App Router apps with route groups, feature/modules, server-only boundaries, proxy, and instrumentation. |
| `react-vite-project-structure` | Structuring small, medium, and large React + Vite apps with app/pages/widgets/features/entities/shared boundaries, state placement, API clients, env safety, and testing layout. |
| `go-api-project-structure` | Structuring small, medium, and large Go APIs with idiomatic `cmd/` and `internal/`, thin handlers, domain modules, transport boundaries, platform infrastructure, migrations, and deployment layout. |

## By project type

| Project type | Recommended skills | Why |
|---|---|---|
| Small script / automation | `code-quality`, `safe-refactoring`, `testing-strategy` | Keep it direct, readable, and safe to change without architecture ceremony. |
| CLI tool | `code-quality`, `testing-strategy`, `secure-error-handling`, `engineering-practices` | CLIs need clear errors, predictable behavior, docs, and basic test coverage. |
| Frontend app | `code-quality`, `design-principles`, `testing-strategy`, `secure-error-handling`, `performance-reliability`, `engineering-practices` | Covers components, state, UI behavior, accessibility/security risks, rendering/data performance, and team consistency. |
| Frontend consuming APIs | Frontend app set + `api-data-design` | Add API contracts, error shapes, pagination, compatibility, and validation. |
| React + Vite app | Frontend app set + `react-vite-project-structure`; add `api-data-design` when backend contracts matter | Keep bootstrapping in `app/`, screens in `pages/`, user actions in `features/`, business concepts in `entities/`, and generic code in `shared/`. |
| Next.js App Router app | Frontend app set + `nextjs-project-structure`; add `api-data-design` when routes/actions expose contracts | Keep `app/` as the routing shell, product logic in features/modules, and server-only code behind safe boundaries. |
| Backend API | `code-quality`, `design-principles`, `api-data-design`, `secure-error-handling`, `testing-strategy`, `performance-reliability` | APIs need contracts, validation, auth, data consistency, tests, and reliability. |
| Go API | Backend API set + `go-api-project-structure`; add `proportional-architecture` when domain boundaries matter | Keep entry points in `cmd/`, private app code in `internal/`, HTTP in transport/httpapi, and business logic in clear domain modules. |
| Backend with business rules | Backend API set + `proportional-architecture` | Add use cases, boundaries, domain rules, and architecture proportionality. |
| Data-heavy backend | Backend API set + `proportional-architecture` | Add schema design, transactions, indexes, migrations, performance, and domain boundaries. |
| Worker / queue / async system | `code-quality`, `performance-reliability`, `secure-error-handling`, `testing-strategy`, `api-data-design` | Focus on retries, idempotency, timeouts, transactions, duplicate events, and failure recovery. |
| Library / SDK | `code-quality`, `design-principles`, `api-data-design`, `testing-strategy`, `engineering-practices` | Public APIs must be small, stable, documented, tested, and easy to evolve. |
| Monolith | `code-quality`, `proportional-architecture`, `design-principles`, `testing-strategy`, `api-data-design`, `secure-error-handling` | Keep boundaries clear before the code turns into a big ball of mud. |
| Microservices / distributed system | `proportional-architecture`, `api-data-design`, `performance-reliability`, `secure-error-handling`, `testing-strategy`, `engineering-practices` | Requires service boundaries, contracts, observability, retries, security, and rollout discipline. |
| Legacy codebase | `safe-refactoring`, `pragmatic-code-review`, `testing-strategy`, `code-quality`, `engineering-practices` | Stabilize behavior, review risk, add characterization tests, and improve incrementally. |
| Critical system | `secure-error-handling`, `performance-reliability`, `testing-strategy`, `api-data-design`, `proportional-architecture` | Security, reliability, auditability, idempotency, and observability become design requirements. |

## Frontend guide

| Situation | Use these skills |
|---|---|
| Component or UI cleanup | `code-quality`, `safe-refactoring` |
| State, hooks, or behavior design | `code-quality`, `design-principles`, `testing-strategy` |
| Forms, validation, auth UI, user input | `secure-error-handling`, `api-data-design`, `testing-strategy` |
| API integration | `api-data-design`, `secure-error-handling`, `testing-strategy` |
| Rendering, loading states, large lists, async UI | `performance-reliability`, `testing-strategy` |
| Frontend architecture / feature modules | `proportional-architecture`, `design-principles`, `code-quality` |
| React + Vite app structure | `react-vite-project-structure`, `proportional-architecture`, `testing-strategy`, `api-data-design` when API contracts matter |
| Next.js App Router structure | `nextjs-project-structure`, `proportional-architecture`, `secure-error-handling`, `testing-strategy` |
| Accessibility, docs, conventions, team workflow | `engineering-practices`, `code-quality` |

Do not use full Clean Architecture by default in frontend work. Use boundaries,
feature modules, and clear contracts first. Add more structure only when state,
domain rules, or team scale justify it.

## Backend guide

| Situation | Use these skills |
|---|---|
| Endpoint or handler implementation | `code-quality`, `api-data-design`, `secure-error-handling` |
| Go API structure / module boundaries | `go-api-project-structure`, `code-quality`, `testing-strategy`, `secure-error-handling` |
| Business use case | `code-quality`, `design-principles`, `proportional-architecture`, `testing-strategy` |
| Database schema or migration | `api-data-design`, `performance-reliability`, `secure-error-handling` |
| Auth, permissions, secrets, user data | `secure-error-handling`, `api-data-design`, `testing-strategy` |
| External provider integration | `design-principles`, `api-data-design`, `performance-reliability`, `testing-strategy` |
| Background job / event consumer | `performance-reliability`, `api-data-design`, `secure-error-handling`, `testing-strategy` |
| Performance incident | `performance-reliability`, `api-data-design`, `pragmatic-code-review` |
| Large module or service boundary | `proportional-architecture`, `design-principles`, `testing-strategy` |

Backend work usually needs stronger attention to validation, authorization,
transactions, idempotency, observability, and data integrity.

## By task type

| Task | Use these skills |
|---|---|
| Write new feature | `code-quality`, then add project-specific risk skills. |
| Review code or PR | `pragmatic-code-review`, plus the relevant domain skill. |
| Refactor safely | `safe-refactoring`, `testing-strategy`, `code-quality`. |
| Design architecture | `proportional-architecture`, `design-principles`, `api-data-design`, `testing-strategy`. |
| Design API or data model | `api-data-design`, `secure-error-handling`, `performance-reliability`. |
| Add tests | `testing-strategy`, plus the implementation skill. |
| Improve security | `secure-error-handling`, `api-data-design`, `pragmatic-code-review`. |
| Improve performance | `performance-reliability`, `api-data-design`, `pragmatic-code-review`. |
| Improve docs / process | `engineering-practices`. |

## Minimum recommended bundles

### General coding

```txt
code-quality
testing-strategy
```

### Frontend feature

```txt
code-quality
design-principles
testing-strategy
secure-error-handling
performance-reliability
```

Add `api-data-design` when the frontend depends on API contracts.

### React + Vite app structure

```txt
code-quality
react-vite-project-structure
testing-strategy
```

Add `api-data-design` when API contracts, client/server data shapes, or backend
integration matter. Add `proportional-architecture` when Feature-Sliced or
domain boundaries are part of the work.

### Next.js App Router structure

```txt
code-quality
nextjs-project-structure
secure-error-handling
testing-strategy
```

Add `proportional-architecture` when feature/module boundaries or domain rules
matter. Add `api-data-design` when Route Handlers, Server Actions, or external
API contracts are part of the work.

### Backend API feature

```txt
code-quality
api-data-design
secure-error-handling
testing-strategy
performance-reliability
```

Add `proportional-architecture` when business rules or module boundaries matter.

### Go API structure

```txt
code-quality
go-api-project-structure
testing-strategy
secure-error-handling
```

Add `api-data-design` when OpenAPI, Protobuf, migrations, data integrity, or
external contracts matter. Add `performance-reliability` when timeouts,
workers, queues, retries, idempotency, or observability matter.

### Architecture/design work

```txt
proportional-architecture
design-principles
api-data-design
testing-strategy
```

### Review work

```txt
pragmatic-code-review
code-quality
```

Then add the risk-specific skill: `secure-error-handling`,
`performance-reliability`, `api-data-design`, or `proportional-architecture`.

## Anti-overengineering rule

Do not load every skill automatically. More context is not better if it makes the
agent overthink a small change.

Use this rule:

```txt
Small problem -> base skills.
Specific risk -> specialized skill.
Growing complexity -> architecture skill.
```

The best skill set is the smallest one that protects correctness, clarity,
security, testability, and maintainability for the work at hand.
