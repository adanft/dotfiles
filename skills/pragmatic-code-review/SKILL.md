---
name: pragmatic-code-review
description: >
  Review code pragmatically with concrete findings, risk-based feedback, and
  recommendations that improve quality without unnecessary redesign.
  Trigger: when reviewing code, reviewing a pull request, auditing an implementation,
  or giving feedback on maintainability, correctness, testing, security, or design.
license: MIT
metadata:
  author: adanft
  version: "1.0"
---

# Pragmatic Code Review

Use this skill to review code like a senior engineer: concrete, risk-based,
evidence-driven, and allergic to both sloppy code and unnecessary architecture.

## When to Use

- Reviewing a code snippet.
- Reviewing a pull request.
- Checking an implementation for maintainability, correctness, or testability.
- Giving feedback on design, naming, error handling, or security.
- Deciding whether a change needs refactoring before merge.

## Critical Patterns

| Pattern | Rule |
|---------|------|
| Verify before judging | Read the code and evidence before agreeing or criticizing. |
| Review behavior first | Correctness, data loss, security, and broken contracts outrank style. |
| Be concrete | Point to specific code, explain the risk, and propose the smallest useful fix. |
| Separate severity | Do not block a PR for a preference. Do block for bugs, security, or broken design boundaries. |
| Avoid rewrite energy | Recommend targeted changes unless the current design is actively harmful. |
| Respect proportionality | Do not suggest Clean Architecture, DDD, Strategy, or factories unless the problem needs them. |
| Preserve intent | Improve the code while respecting the feature's current scope. |

## Severity Guide

| Severity | Use for |
|----------|---------|
| Critical | Data loss, security issue, broken core behavior, dangerous migration. |
| High | Likely bug, broken API contract, missing authorization, unhandled failure path. |
| Medium | Maintainability problem, unclear responsibility, weak error handling, missing important test. |
| Low | Naming, local readability, small duplication, style issue not covered by tooling. |
| Nit | Optional preference; never block on this alone. |

## Review Workflow

1. Identify what the code is trying to do.
2. Check correctness and edge cases.
3. Check security and error handling around external input or side effects.
4. Check responsibility boundaries and coupling.
5. Check whether tests cover important behavior.
6. Suggest the smallest fix that addresses the real risk.
7. Explicitly call out what should not be overengineered.

## Risk Cues

Use these cues to avoid shallow reviews that only discuss naming or style.

| Area | Look for |
|------|----------|
| Security | Missing authz, unsafe input, secrets in code/logs, injection, XSS/CSRF, dependency vulnerabilities. |
| Errors | Empty catch, generic messages, leaked internals, swallowed failures, inconsistent API errors. |
| Performance | N+1 queries, missing pagination, wrong indexes, cache misuse, unbounded memory work. |
| Data | Missing transactions, weak constraints, unsafe migrations, orphaned records, no rollback path. |
| Concurrency | Race conditions, duplicate side effects, retry storms, bad timeouts, non-idempotent jobs/events. |
| API | Broken contracts, compatibility breaks, unclear versioning, inconsistent validation/errors. |
| Observability | Logs without useful context, missing metrics/tracing/alerts for critical flows. |
| Team workflow | Giant mixed PRs, formatting mixed with logic, unclear commits, accidental secrets. |

## Mental Tests

Before accepting code as clean, ask:

- What happens with empty, null, missing, or malformed input?
- What happens when an external service, file, database, or network call fails?
- What happens with many records or large payloads?
- What happens if this function, request, job, or event runs twice?
- Can the next reader understand, change, and test this tomorrow without hidden context?

## Response Format

Use this structure unless the user asks for a different one:

```md
## Verdict
<Pass / Needs changes / Blocked> — <one-sentence reason>

## Findings
- <Severity>: <Concrete issue>
  - Why it matters: <risk>
  - Suggested fix: <smallest useful improvement>

## Do not overengineer
- <What should stay simple and why>
```

## Ready-to-use Review Prompt

```txt
Review this code for clarity, simplicity, visual order, responsibility boundaries,
duplication, clean conditions, clear errors, file structure, useful comments,
testability, and safe modification.

Do not change behavior unless you find a bug. Prioritize correctness and security
first, then maintainability. Prefer the smallest useful improvement and avoid
overengineering.
```

## Golden Rules

- Clear names beat explanatory comments.
- A function should do one main thing.
- Simple and explicit beats clever and magical.
- Abstract after real duplication, not before.
- Errors are part of the design.
- Write for the person who must fix this later.

## Review Examples

```md
- High: `createOrder` saves the order before validating stock.
  - Why it matters: a failed stock check can leave an invalid order persisted.
  - Suggested fix: validate stock before persistence, or wrap the operation in a transaction.
```

```md
- Nit: `data` would be clearer as `paidInvoices`.
  - Why it matters: the current name hides the business meaning.
  - Suggested fix: rename locally; no structural change needed.
```

## Checklist

- [ ] The review distinguishes bugs from preferences.
- [ ] Every finding explains impact, not just taste.
- [ ] Suggested fixes are proportional.
- [ ] Important missing tests are called out.
- [ ] Security and authorization are checked when relevant.
- [ ] Performance feedback is based on evidence or clear risk, not guessing.

## Commands

```bash
# Inspect local change size before reviewing
git diff --stat

# Detect whitespace errors in the reviewed diff
git diff --check
```
