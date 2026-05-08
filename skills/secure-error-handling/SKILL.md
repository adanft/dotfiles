---
name: secure-error-handling
description: >
  Design secure input handling, authentication, authorization, secret handling,
  safe logging, and clear errors that fail fast without leaking sensitive data.
  Trigger: when handling errors, validating external data, reviewing security,
  working with auth/authz, secrets, logs, user-facing errors, or unsafe inputs.
license: MIT
metadata:
  author: adanft
  version: "1.0"
---

# Secure Error Handling

Use this skill when failures and untrusted data matter. Error handling and
security are design concerns, not cleanup tasks.

## When to Use

- Validating user input, files, headers, cookies, environment variables, or external APIs.
- Designing error messages and exception flow.
- Reviewing authentication or authorization.
- Handling secrets, tokens, credentials, or sensitive logs.
- Protecting against common injection and web attacks.
- Adding retries, fallbacks, or user-facing error responses.

## Critical Patterns

| Pattern | Rule |
|---------|------|
| Never trust external data | Validate and sanitize inputs at the boundary. |
| Fail fast | Reject invalid state early with clear errors. |
| Safe user errors | Tell users what they can do, not internal implementation details. |
| Useful internal context | Log safe identifiers, operation names, and causes. |
| No secret leakage | Never expose tokens, passwords, keys, session data, or sensitive PII. |
| Auth before action | Authentication proves identity; authorization proves permission. |
| Backend enforcement | Security must not depend only on the frontend. |
| Consistent error shape | APIs should return predictable error structures. |
| Dependency hygiene | Known vulnerable dependencies are security bugs, not chores. |

## Security Checklist

| Area | Check |
|------|-------|
| Inputs | Validate type, format, size, required fields, and trusted boundaries. |
| Authentication | Sessions/tokens are verified securely and expire appropriately. |
| Authorization | Server-side permission checks protect every sensitive action. |
| Secrets | Secrets are not committed, logged, printed, or returned to clients. |
| SQL injection | Use parameterized queries or safe query builders. |
| XSS | Escape or sanitize user-controlled content at rendering boundaries. |
| CSRF | Protect cookie/session-based state-changing requests. |
| Rate limiting | Protect costly, sensitive, or abuse-prone endpoints. |
| Logs | Include context without sensitive data. |
| Dependencies | Scan or review vulnerable packages when tooling exists. |

## Error Handling Rules

| Bad | Better |
|-----|--------|
| Empty `catch` | Handle, log safely, or rethrow with context. |
| `throw new Error("Error")` | Use a specific message with safe context. |
| Exposing stack traces to users | Return a safe user message and log internal details. |
| Retrying everything blindly | Retry only transient failures with limits and backoff. |
| Mixing user and internal errors | Separate client-safe errors from internal diagnostic errors. |

## Code Examples

```js
try {
  await payOrder(order);
} catch (error) {
  logger.error("Failed to pay order", {
    orderId: order.id,
    error,
  });

  throw new Error("Payment could not be completed");
}
```

```json
{
  "error": {
    "code": "INVALID_EMAIL",
    "message": "Email format is invalid"
  }
}
```

## Checklist

- [ ] External data is validated at the boundary.
- [ ] Sensitive operations enforce backend authorization.
- [ ] Errors are clear, actionable, and safe.
- [ ] Logs contain useful context without secrets.
- [ ] Attack classes relevant to the surface were considered.
- [ ] Retries/timeouts do not hide or amplify failures.

## Commands

```bash
# Review changed files for accidental secret/config exposure
git diff --stat

# Check whitespace and conflict markers before finishing
git diff --check
```
