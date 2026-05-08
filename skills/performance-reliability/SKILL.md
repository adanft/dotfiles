---
name: performance-reliability
description: >
  Evaluate performance, concurrency, async behavior, idempotency, retries,
  timeouts, and reliability risks without premature optimization.
  Trigger: when optimizing code, reviewing latency/memory/query performance,
  handling concurrency, background jobs, retries, queues, locks, timeouts,
  idempotency, or production reliability.
license: MIT
metadata:
  author: adanft
  version: "1.0"
---

# Performance Reliability

Use this skill when speed, resource use, concurrency, or resilience matters.
Correctness and clarity come first; optimization should be measured or justified
by obvious production risk.

## When to Use

- Investigating slow code, high memory use, or expensive queries.
- Reviewing performance-sensitive changes.
- Designing retries, timeouts, background jobs, queues, or async flows.
- Handling concurrent writes, shared state, locks, or transactions.
- Making operations idempotent.
- Preventing retry storms, race conditions, deadlocks, or data corruption.

## Critical Patterns

| Pattern | Rule |
|---------|------|
| Correct first | A fast wrong answer is still a bug. |
| Measure before tuning | Optimize the bottleneck, not the guess. |
| Watch data access | N+1 queries, missing indexes, and over-fetching are common real bottlenecks. |
| Bound work | Use pagination, batching, streaming, limits, and backpressure where needed. |
| Cache carefully | Cache only when invalidation, freshness, and failure behavior are understood. |
| Control retries | Retries need limits, backoff, jitter, and clear transient-failure criteria. |
| Set timeouts | External calls and long work need explicit timeouts. |
| Design idempotency | Repeated requests/events/jobs should not duplicate critical side effects. |
| Protect shared state | Use transactions, locks, or atomic operations intentionally. |
| Resource lifecycle | Every opened, reserved, subscribed, locked, or transactional resource needs a clear close, release, cleanup, or rollback path. |

## Performance Risk Cues

| Risk | Typical fix |
|------|-------------|
| N+1 queries | Batch loading, joins, preloading, or query restructuring. |
| Missing indexes | Add indexes aligned with real query patterns. |
| Over-fetching | Select only needed fields; paginate large collections. |
| Repeated expensive calculation | Memoize/cache with explicit invalidation rules. |
| Processing all data in memory | Stream, batch, or push work to the database/queue. |
| Slow algorithm | Improve complexity only after confirming it matters. |
| Blocking user flow | Move slow work to background jobs when consistency allows. |

## Concurrency and Async Risk Cues

| Risk | Meaning | Guardrail |
|------|---------|-----------|
| Race condition | Multiple actors change state at the same time. | Transactions, locks, compare-and-set, unique constraints. |
| Deadlock | Actors wait on each other forever. | Lock ordering, timeouts, smaller transactions. |
| Starvation | Work never gets resources. | Fair queues, limits, scheduling rules. |
| Data corruption | State becomes inconsistent. | Constraints, transactions, idempotency, validation. |
| Retry storm | Retries amplify an outage. | Backoff, jitter, circuit breakers, retry budgets. |
| Bad timeout | Work hangs or fails too aggressively. | Timeouts based on real service expectations. |
| Global mutable state | Hidden shared state breaks under concurrency. | Encapsulation, immutability, dependency injection. |

## Resource Lifecycle Checklist

- [ ] Database connections, transactions, files, sockets, timers, locks, buffers, subscriptions, and listeners are cleaned up.
- [ ] Rollback/release paths exist when work fails midway.
- [ ] Long-lived resources have ownership and shutdown rules.
- [ ] Cleanup is safe to run more than once when retries or cancellation are possible.

## Idempotency Checklist

- [ ] The operation has a stable idempotency key or natural unique constraint.
- [ ] Retrying does not duplicate payments, emails, orders, or side effects.
- [ ] Partial failure can be retried safely.
- [ ] External provider calls are correlated with internal records.
- [ ] Background jobs/events can be processed more than once safely.

## Commands

```bash
# Review changed files and size before performance/reliability review
git diff --stat

# Check for basic diff issues before finishing
git diff --check
```
