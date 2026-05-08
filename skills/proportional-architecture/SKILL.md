---
name: proportional-architecture
description: >
  Design software architecture that matches the real size, risk, and domain
  complexity of the problem without underdesigning or overengineering.
  Trigger: when designing a system, module, feature architecture, service boundary,
  API, domain model, data flow, or technical approach.
license: MIT
metadata:
  author: adanft
  version: "1.0"
---

# Proportional Architecture

Use this skill to design architecture that protects important change without
turning every problem into an enterprise framework cosplay.

## When to Use

- Designing a new system, module, or feature.
- Choosing boundaries between domain, application, infrastructure, and interface code.
- Deciding whether Clean Architecture, DDD, events, CQRS, or other patterns are justified.
- Designing APIs, persistence, integrations, or service boundaries.
- Evaluating whether a design is underengineered or overengineered.

## Critical Patterns

| Pattern | Rule |
|---------|------|
| Architecture is a tradeoff | Every layer, abstraction, and boundary must pay rent. |
| Proportionality first | Match structure to current complexity and likely change, not imagined scale. |
| Protect the core | Business rules should not depend directly on frameworks, databases, HTTP, or external providers. |
| Boundaries by volatility | Put boundaries around things that change for different reasons. |
| Explicit dependencies | Make important dependencies visible and replaceable. |
| Patterns solve problems | Use Factory, Strategy, Adapter, Observer, DDD, or Clean Architecture only when the problem asks for them. |
| Security is design | Authorization, validation, secrets, and data trust boundaries belong in the architecture discussion. |
| Observability is part of production | Important flows need useful logs, metrics, traces, or auditability when production risk justifies it. |

## Architecture Scale Guide

| Context | Prefer |
|---------|--------|
| Script or tiny tool | Direct code with clear functions. |
| Small app or CRUD | Routes/controllers, services, data access, and simple tests. |
| Medium app with real business rules | Use cases, repositories/ports, validation, domain concepts, integration tests. |
| Large app | Clear modules, boundaries, adapters, observability, stronger test strategy. |
| Complex business domain | DDD selectively: entities, value objects, aggregates, domain events, bounded contexts. |
| Distributed system | Service boundaries only when team, deployment, scaling, or domain independence justifies them. |

## Design Workflow

1. Describe the business problem and the change forces.
2. Identify core rules that must be protected.
3. Identify external details: UI, framework, database, providers, queues, files, network.
4. Choose the smallest architecture that separates stable rules from volatile details.
5. Define module boundaries and dependency direction.
6. Define error handling, validation, authorization, and trust boundaries.
7. Define the testing strategy.
8. Call out what should deliberately stay simple for now.

## Decision Rules

| Question | Guidance |
|----------|----------|
| Do we need Clean Architecture? | Yes if business rules are important and external details may change; simplify it for small apps. |
| Do we need DDD? | Yes when the domain language and rules are complex; no for simple CRUD. |
| Do we need a Factory? | Yes when creation varies by type/config; no for one obvious constructor. |
| Do we need Strategy? | Yes for interchangeable algorithms; no for one simple condition. |
| Do we need events? | Yes when multiple independent reactions follow a business event; no when a direct call is clearer. |
| Do we need microservices? | Yes for independent teams/domains/deployments; no because it sounds modern. |
| Do we need caching? | Yes after measured repeated cost and clear freshness/invalidation rules; no as a guess. |
| Do we need CQRS? | Yes when read/write models truly diverge; no for normal CRUD. |
| Do we need event sourcing? | Yes when replayable history/audit is a core requirement; no for simple state storage. |
| Do we need stronger testing? | Yes as risk rises; no to replacing focused unit/integration tests with only giant e2e suites. |

## DDD Tactical Concepts

Use DDD language only when the domain complexity earns it.

| Concept | Use for |
|---------|---------|
| Entity | Domain object with identity, like `User`, `Order`, or `Invoice`. |
| Value Object | Concept defined by value, like `Money`, `Email`, or `Address`. |
| Aggregate | Cluster of objects changed as one consistency boundary. |
| Repository | Abstraction for loading/saving aggregates without leaking persistence details. |
| Domain Service | Domain rule that does not naturally belong to one entity/value object. |
| Domain Event | Important business fact, like `OrderPaid` or `UserRegistered`. |
| Bounded Context | Area where a model and language have a specific meaning. |

## Architecture Risk Checklist

| Area | Consider |
|------|----------|
| API | Contracts, versioning, pagination, validation, authorization, consistent errors, compatibility. |
| Database | Modeling, indexes, transactions, constraints, migrations, relations, backups, auditing. |
| Security | Trust boundaries, auth/authz, secrets, injection risks, safe logs. |
| Operations | Logs, metrics, tracing, alerts, dashboards for production-critical flows. |
| Async/concurrency | Idempotency, retries, timeouts, locks, deadlocks, races, retry storms. |
| Delivery | Reviewable slices, migration order, rollback boundaries, no mixed giant PRs. |

## Recommended Output Shape

Use this structure for architecture answers:

```md
## Recommendation
<The smallest architecture that fits the problem>

## Boundaries
| Boundary | Responsibility |
|----------|----------------|
| <module/layer> | <what it owns> |

## Patterns to Use
- <Pattern> — <why it earns its complexity>

## Patterns to Avoid
- <Pattern> — <why it would be premature>

## Testing Strategy
- <unit/integration/e2e/contract guidance>

## Risks
- <technical risk and mitigation>
```

## Code Shape Example

```txt
interface/controller -> application/use-case -> domain rule
                                      |
                                      v
                              port/interface
                                      |
                                      v
                          infrastructure adapter
```

## Ready-to-use Architecture Design Prompt

```txt
Design a software architecture for this project using pragmatic technical judgment.

Consider project size, domain complexity, KISS/YAGNI, responsibility boundaries,
SOLID where useful, Clean Architecture only if justified, DDD only for complex
domains, testing, security, database design, APIs, observability, performance,
and overengineering risk.

Return: recommended architecture, folder/module structure, responsibility of each
layer/module, patterns to use, patterns to avoid, testing strategy, technical
risks, and the simplest first version with a path to grow.
```

## Checklist

- [ ] The architecture is smaller than the problem, not bigger than the ego.
- [ ] Core rules are protected from external details.
- [ ] Dependencies point inward or toward stable abstractions.
- [ ] The design has clear test seams.
- [ ] Security and error handling are part of the design.
- [ ] Avoided patterns are named explicitly.
- [ ] The first version can grow without pretending to be the final version.

## Commands

```bash
# Inspect local design-related documentation changes
git diff --stat -- '*.md'

# Check markdown diffs before review
git diff --check -- '*.md'
```
