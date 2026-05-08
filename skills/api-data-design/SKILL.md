---
name: api-data-design
description: >
  Design clear APIs and reliable data models with explicit contracts,
  validation, pagination, idempotency, transactions, constraints, migrations,
  indexes, backups, and auditing.
  Trigger: when designing APIs, module interfaces, endpoints, schemas,
  database models, migrations, persistence rules, or data consistency boundaries.
license: MIT
metadata:
  author: adanft
  version: "1.0"
---

# API Data Design

Use this skill when a change crosses a contract or data boundary. Good APIs are
easy to use and hard to break. Good data design prevents corrupted systems.

## When to Use

- Designing REST/RPC/module APIs or service contracts.
- Adding endpoints, request/response shapes, or error formats.
- Designing database schemas, migrations, indexes, constraints, or relationships.
- Reviewing data consistency, transactions, backups, or auditability.
- Handling pagination, filtering, versioning, compatibility, or idempotency.

## API Design Rules

| Area | Rule |
|------|------|
| Names | Use clear resource/action names that reveal intent. |
| Contracts | Define inputs, outputs, errors, auth requirements, assumptions, and invariants. |
| Preconditions | Make required state before the call explicit and validate it early. |
| Postconditions | Make the guaranteed state after success explicit, especially for mutations. |
| Validation | Reject invalid data at the boundary with consistent errors. |
| Invalid states | Prefer types, enums, value objects, constraints, and schemas that make invalid data hard to represent. |
| Authorization | Sensitive APIs must enforce permissions server-side. |
| Pagination | Never return unbounded collections by default. |
| Versioning | Version or evolve contracts when compatibility matters. |
| Compatibility | Avoid breaking clients silently; prefer additive changes. |
| Idempotency | Critical create/payment/job APIs need safe retry semantics. |
| Error shape | Return predictable error codes/messages. |

## Database Design Rules

| Area | Rule |
|------|------|
| Modeling | Model real business concepts, not just convenient screens. |
| Constraints | Let the database protect critical integrity rules. |
| Transactions | Use transactions around multi-step consistency changes. |
| Indexes | Add indexes for real query patterns, not every column. |
| Migrations | Make schema changes reversible or safely forward-only with rollout plans. |
| Relations | Prevent orphaned or inconsistent data with clear ownership. |
| Normalization | Reduce duplication until measured reads justify denormalization. |
| Backups | Critical data needs recovery strategy, not hope. |
| Auditing | Sensitive or business-critical changes should be traceable. |

## Consistent Error Example

```json
{
  "error": {
    "code": "INVALID_EMAIL",
    "message": "Email format is invalid"
  }
}
```

## Data Boundary Checklist

- [ ] Inputs and outputs are explicit.
- [ ] Preconditions, postconditions, invariants, and assumptions are explicit.
- [ ] Invalid data is rejected before it reaches core logic.
- [ ] Invalid states are prevented by types, schemas, constraints, or value objects where practical.
- [ ] Permissions are enforced behind the API, not just in the UI.
- [ ] List endpoints are paginated or bounded.
- [ ] Critical operations are idempotent.
- [ ] Database constraints protect core invariants.
- [ ] Migration/rollback/deployment order is considered.
- [ ] Query performance has indexes only where justified.
- [ ] Backup and audit needs match the business risk.

## What to Avoid

- APIs named around implementation details instead of user/domain intent.
- Returning inconsistent error structures from different endpoints.
- Putting critical integrity rules only in frontend validation.
- Adding indexes blindly without query understanding.
- Migrating production data without a safe rollout plan.

## Commands

```bash
# Review API/schema/data-related changes
git diff --stat

# Check basic diff issues before review
git diff --check
```
