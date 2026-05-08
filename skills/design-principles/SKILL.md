---
name: design-principles
description: >
  Apply SOLID, OOP, functional programming ideas, dependency inversion, and
  design patterns with pragmatic judgment instead of ceremony.
  Trigger: when designing classes, modules, domain behavior, abstractions,
  interfaces, object collaboration, functional cores, or choosing a design pattern.
license: MIT
metadata:
  author: adanft
  version: "1.0"
---

# Design Principles

Use this skill when code needs better object design, functional structure,
SOLID reasoning, or pattern selection. The goal is not to look advanced. The
goal is to make change safer.

## When to Use

- Designing classes, modules, interfaces, or services.
- Applying SOLID to growing code.
- Deciding between OOP, functional style, or a mix.
- Choosing whether a design pattern is justified.
- Introducing dependency injection, ports, strategies, adapters, or events.
- Fixing rigid, coupled, or responsibility-heavy code.

## Critical Patterns

| Pattern | Rule |
|---------|------|
| SRP | A module/class should have one main reason to change. |
| OCP | Extend behavior without editing stable code when variants are frequent. |
| LSP | A subtype must honor the parent contract without surprising callers. |
| ISP | Prefer small, specific interfaces over fat contracts. |
| DIP | Depend on stable abstractions for important external or variable behavior. |
| Composition over inheritance | Prefer composed behavior unless the hierarchy is natural and stable. |
| Encapsulation | Put behavior where the concept owns the rule; avoid anemic objects when domain rules matter. |
| Functional core | Keep calculations pure and push side effects to boundaries when useful. |
| Immutability | Prefer immutable data when state, concurrency, or reasoning becomes difficult. |
| Pattern restraint | A pattern is good only when it reduces current complexity. |
| Idiomatic design | Use patterns in the language's natural style; do not force Java-style classes, FP pipelines, or framework habits where they do not fit. |

## OOP and Functional Design

| Area | Good use | Bad smell |
|------|----------|-----------|
| OOP | Objects own meaningful behavior and protect state. | Classes with only getters/setters or giant services. |
| OOP | Interfaces describe what callers need. | Classes depend on framework/provider details directly. |
| OOP | Names should reveal real domain concepts. | Manager/helper/utils dumping grounds hide missing responsibilities. |
| FP | Pure functions for calculations and rules. | Hidden mutation and side effects inside innocent-looking functions. |
| FP | Composition of small transformations. | Clever chains that hide business meaning. |
| FP | Declarative transformations are good when they make intent clearer. | Declarative style used as cleverness instead of clarity. |
| Mixed style | Functional core, imperative shell. | Everything coupled to I/O, DB, HTTP, or global state. |

## Pattern Selection

| Pattern | Use when | Avoid when |
|---------|----------|------------|
| Factory | Object creation varies by type, config, or provider. | There is only one obvious constructor. |
| Builder | An object has many optional or ordered construction steps. | The object is simple. |
| Singleton | One controlled process-wide instance is truly needed, like config/logging. | It becomes hidden global mutable state. |
| Prototype | Cloning a prepared object is cheaper or clearer than rebuilding it. | Copying is shallow, unclear, or unnecessary. |
| Adapter | An external interface does not match your internal port. | The external API already fits cleanly. |
| Facade | A simple API should hide a complex subsystem. | It becomes a dumping ground for unrelated behavior. |
| Decorator | You need logging, cache, metrics, or authorization around behavior. | A direct implementation is clearer. |
| Proxy | Access needs lazy loading, permission checks, caching, or remote control. | It hides important costs or side effects. |
| Composite | Individual items and groups should be handled uniformly. | The structure is not actually tree-like. |
| Strategy | Algorithms are interchangeable and selected by context. | There is one simple conditional. |
| Observer/Event | Multiple independent reactions follow one business event. | A direct call is simpler and sufficient. |
| Command | Actions need to be queued, retried, logged, undone, or passed around. | A function call expresses the action clearly. |
| State | Behavior changes significantly by state. | State only changes displayed labels. |
| Template Method | A workflow has stable steps with controlled variation. | Composition would be clearer. |
| Chain of Responsibility | A request passes through ordered handlers, like middleware. | The order is hidden or hard to reason about. |

## Code Examples

### Dependency inversion

```js
class OrderService {
  constructor(paymentGateway) {
    this.paymentGateway = paymentGateway;
  }

  pay(order) {
    return this.paymentGateway.charge(order.total);
  }
}
```

### Functional core

```js
function calculateDiscount(price, percentage) {
  return price * percentage;
}
```

## Checklist

- [ ] Responsibilities are clear.
- [ ] Dependencies are explicit.
- [ ] Interfaces are as small as callers need.
- [ ] Inheritance is not forcing broken contracts.
- [ ] Pure logic is separated from side effects where useful.
- [ ] Patterns solve current complexity, not imagined complexity.
- [ ] The simpler solution was considered first.

## Commands

```bash
# Review whether the design change stayed focused
git diff --stat

# Check for whitespace/conflict-marker issues
git diff --check
```
