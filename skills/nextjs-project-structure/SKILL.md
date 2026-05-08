---
name: nextjs-project-structure
description: >
  Structure small, medium, and large Next.js App Router projects with clear route
  boundaries, feature/domain modules, server-only separation, proxy,
  instrumentation, naming conventions, and testing layout.
  Trigger: when creating, refactoring, or reviewing Next.js project structure,
  App Router routes, page/layout organization, route groups, private folders,
  Server Actions, Server Functions, Route Handlers, proxy, instrumentation,
  features, modules, shared UI, or server-only code.
license: MIT
metadata:
  author: adanft
  version: "1.0"
---

# Next.js Project Structure

Use this skill to keep a Next.js App Router project navigable as it grows. The
goal is not to add folders for decoration; the goal is to keep routing, product
logic, reusable UI, and server-only code separated.

This skill covers **small, medium, and large single Next.js App Router apps**.

## Golden Rule

```txt
src/app = routing, layouts, pages, loading, errors, route handlers
features/modules = real product logic
components/ui or shared/ui = reusable UI
server = code that must never go to the browser
```

As the project grows, less business logic should live in `app/`.

## Project Size Decision

| Size | Structure | Use when |
|---|---|---|
| Small | `src/app + components + lib + server` | Landing pages, MVPs, blogs, simple dashboards. |
| Medium | `src/app + features` | Clear product areas like auth, billing, users, settings, orders. |
| Large | `src/app` as routes + `modules` by domain | Real business rules, permissions, workflows, integrations, long-term maintenance. |

Start with the smallest structure that protects clarity. Move to `features/`
when business areas become visible. Move to `modules/` when domain rules and
boundaries matter.

## App Router Rules

Next.js uses folders inside `app/` as route segments. A segment becomes public
when it contains `page.tsx` or `route.ts`. Other colocated files do not
automatically become routes.

| Convention | Rule |
|---|---|
| `page.tsx` | Public page UI for a route segment. Keep it thin. |
| `layout.tsx` | Shared layout for a segment and children. Avoid business logic. |
| `loading.tsx` | Segment loading UI. |
| `error.tsx` | Segment error boundary; Client Component. |
| `not-found.tsx` | Segment 404 UI. |
| `global-error.tsx` | Global error boundary; include `html` and `body`. |
| `route.ts` | Route Handler / endpoint. Validate input/auth and call application logic. |
| `template.tsx` | Remounting layout-like component. Use only when needed. |
| `default.tsx` | Fallback for parallel routes. |
| `(group)` | Route group; organizes without changing the URL. |
| `_folder` | Private folder for local route implementation details. |

Use route groups like `(public)`, `(marketing)`, `(auth)`, `(dashboard)`,
`(app)`, and `(admin)` to separate layouts and sections.

Use private folders like `_components` or `_lib` only for code local to one route
segment. If code is reused elsewhere, move it out of `app/`.

## Root vs `src/` Placement

| Item | Placement |
|---|---|
| `public/` | Project root. Public static assets only. |
| `src/app` / `src/pages` | Use when the project follows the `src` convention. |
| `next.config.ts`, `tsconfig.json`, `package.json`, `eslint.config.mjs` | Project root. |
| `.env*` | Project root; never commit secrets. |
| `proxy.ts` | Root, or directly in `src/` when using `src`; same level as `app`/`pages`. |
| `instrumentation.ts` | Root, or directly in `src/` when using `src`; never inside `app`/`pages`. |

In Next.js 16+, prefer `proxy.ts` over the legacy/deprecated `middleware.ts`
filename.

## Small Project Shape

```txt
my-next-app/
  public/
  src/
    app/
      layout.tsx
      page.tsx
      globals.css
      not-found.tsx
      error.tsx
      api/health/route.ts
    components/
      ui/
      layout/
    lib/
      utils.ts
      constants.ts
      formatters.ts
      validators.ts
    server/
      db/
      auth/
    styles/
    types/
    proxy.ts
    instrumentation.ts
  tests/
    unit/
    e2e/
```

| Folder | Put here |
|---|---|
| `src/app/` | Routes, layouts, pages, loading, errors, Route Handlers. |
| `src/components/ui/` | Generic UI: buttons, inputs, modals, cards. |
| `src/components/layout/` | Header, footer, sidebar, shell components. |
| `src/lib/` | Pure utilities, constants, formatters, validators. |
| `src/server/` | DB, auth, sessions, private integrations. |
| `src/styles/` | Global styles or CSS tokens. |
| `src/types/` | Shared global types. |

Small projects do not need domain layers by default. If `components/` or `lib/`
becomes hard to scan, move to the medium shape.

## Medium Project Shape

```txt
src/
  app/
    layout.tsx
    globals.css
    not-found.tsx
    global-error.tsx
    (marketing)/
      page.tsx
      pricing/page.tsx
    (auth)/
      login/page.tsx
      register/page.tsx
    (dashboard)/
      dashboard/page.tsx
      settings/page.tsx
      billing/page.tsx
    api/
      health/route.ts
      webhooks/stripe/route.ts

  features/
    auth/
      components/
      actions/login.action.ts
      schemas/login.schema.ts
      services/auth.service.ts
      types/auth.types.ts
    billing/
      components/
      actions/create-checkout-session.action.ts
      schemas/billing.schema.ts
      services/billing.service.ts
      types/billing.types.ts

  components/
    ui/
    layout/
    feedback/
  server/
    db/
    auth/
    cache/
    external/
  lib/
  config/
    env.ts
    site.ts
    routes.ts
  hooks/
  styles/
  types/
  proxy.ts
  instrumentation.ts
```

Medium-project rule:

```txt
app/ = routes
features/ = business features
server/ = server-only infrastructure
components/ = shared UI
```

| Folder | Put here |
|---|---|
| `src/app/(marketing)` | Landing, pricing, blog, public pages. |
| `src/app/(auth)` | Login, registration, account recovery. |
| `src/app/(dashboard)` | Private user app routes with dashboard layout. |
| `src/app/api` | Webhooks, health checks, external endpoints. |
| `src/features/*` | Feature UI, actions, schemas, services, local types. |
| `src/server/db` | DB connection, schema, migration helpers. |
| `src/server/auth` | Session, permissions, authorization. |
| `src/server/external` | Server-side API clients with secrets. |
| `src/config/env.ts` | Environment validation. |
| `src/config/routes.ts` | Named route constants. |

Do not let `app/` become the place where every component, action, query, schema,
and service lives.

## Large Project Shape

```txt
src/
  app/
    layout.tsx
    globals.css
    not-found.tsx
    global-error.tsx
    (public)/
    (auth)/
    (app)/
    (admin)/
    api/

  modules/
    identity/
      domain/
        entities/user.entity.ts
        value-objects/email.vo.ts
        policies/can-login.policy.ts
        errors/identity.errors.ts
      application/
        use-cases/login-user.use-case.ts
        ports/user-repository.port.ts
        dto/login.dto.ts
      infrastructure/
        repositories/prisma-user.repository.ts
        services/bcrypt-password-hasher.ts
        mappers/user.mapper.ts
      presentation/
        components/login-form.tsx
        actions/login.action.ts
        schemas/login.schema.ts
        hooks/use-login-form.ts
      tests/login-user.use-case.test.ts

    billing/
      domain/
      application/
      infrastructure/
      presentation/
      tests/

    projects/
      domain/
      application/
      infrastructure/
      presentation/
      tests/

  shared/
    ui/
    components/
    hooks/
    lib/
    types/
    constants/
    errors/
  server/
    db/
    auth/
    cache/
    security/
    telemetry/
    external/
  config/
    env.ts
    routes.ts
    site.ts
    feature-flags.ts
  styles/
  i18n/
  types/
  proxy.ts
  instrumentation.ts
```

Large-project rule:

```txt
app -> presentation only
presentation -> application
application -> domain + ports
infrastructure -> implements ports
domain -> no Next.js, React, DB, providers, cookies, headers, or env
```

Use this layering only when domains have real rules, workflows, permissions, or
integration complexity. For simple CRUD, prefer the medium `features/` shape and
avoid Clean Architecture ceremony.

## Folder Ownership Rules

| Folder | Owns | Must avoid |
|---|---|---|
| `app/` | Routing, layouts, metadata, special files, thin composition. | Heavy business logic, DB clients, provider SDKs. |
| `features/` | Medium-size business features. | Importing from `app/`. |
| `modules/*/domain/` | Entities, value objects, policies, domain errors/events. | React, Next.js, DB clients, cookies, headers, env. |
| `modules/*/application/` | Use cases, DTOs, ports/interfaces. | Concrete repositories/providers. |
| `modules/*/infrastructure/` | DB repositories, provider adapters, mappers, HTTP/storage clients. | Business rules that belong in domain/application. |
| `modules/*/presentation/` | Module UI, actions, schemas, hooks, forms, queries. | Becoming a second `app/` junk drawer. |
| `shared/` | Domain-agnostic reusable UI, helpers, hooks, types, constants. | Importing concrete modules. |
| `server/` | Server-only DB/auth/cache/security/telemetry/external APIs. | Imports from Client Components. |
| `config/` | `env.ts`, `routes.ts`, `site.ts`, `feature-flags.ts`. | Scattered magic strings and unchecked env access. |

Good page:

```tsx
import { ProjectDetailsPage } from "@/modules/projects/presentation/components/project-details-page";

export default function Page() {
  return <ProjectDetailsPage />;
}
```

Bad page:

```tsx
export default async function Page() {
  // auth, permissions, queries, business logic, formatting,
  // huge UI, mutation handlers, error mapping...
}
```

## Server Boundaries

| Boundary | Rule |
|---|---|
| Server Components | Default for server-side data access and non-interactive UI. |
| Client Components | Use only for state, events, hooks, and browser APIs. |
| Server Actions / Server Functions | Validate auth, authorization, input, and permissions inside the function. |
| Route Handlers | Treat as HTTP APIs. Validate request data and return safe DTOs. |
| `src/server` | Database, auth, env, secrets, provider SDKs, observability. |
| `server-only` / `*.server.ts` | Use `server-only` for enforceable protection; use `*.server.ts` as a naming convention unless tooling enforces it. |

Never rely on hidden buttons, disabled UI, or client-only checks for security.

Bad Client Component:

```tsx
"use client";

import { db } from "@/server/db";
```

Better:

```tsx
"use client";

import { updateUserAction } from "@/modules/identity/presentation/actions/update-user.action";
```

The action must still enforce server-side auth/authz and input validation.

## `proxy.ts` and `instrumentation.ts`

Use `proxy.ts` for early network/routing boundary work:

- redirects
- rewrites
- simple access checks
- header changes
- locale detection

Do not use `proxy.ts` for heavy database queries, complex permissions, payment
processing, or full session/authorization logic.

If an edge runtime boundary is required, verify current Next.js support before
renaming legacy `middleware.ts`; some setups may still need runtime-specific
handling.

Use `instrumentation.ts` for server startup observability:

- OpenTelemetry
- Sentry
- logging setup
- tracing setup
- monitoring setup

## Naming Conventions

| Thing | Convention | Example |
|---|---|---|
| React component symbol | `PascalCase` | `ProjectCard` |
| Component file | `kebab-case.tsx` | `project-card.tsx` |
| Client-only component | `*.client.tsx` | `project-form.client.tsx` |
| Server-only helper | `*.server.ts` | `require-user.server.ts` |
| Server Action | `*.action.ts` | `create-project.action.ts` |
| Use case | `*.use-case.ts` | `create-project.use-case.ts` |
| Value Object | `*.vo.ts` | `email.vo.ts` |
| Entity | `*.entity.ts` | `project.entity.ts` |
| Repository implementation | `*.repository.ts` | `prisma-project.repository.ts` |
| Port/interface | `*.port.ts` | `project-repository.port.ts` |
| Schema | `*.schema.ts` | `project.schema.ts` |
| Error definitions | `*.errors.ts` | `project.errors.ts` |
| Test | `*.test.ts` or `*.spec.ts` | `project.entity.test.ts` |
| Route segments | `kebab-case` folders | `forgot-password/` |
| Route groups | Semantic parentheses | `(auth)`, `(public)`, `(app)`, `(admin)` |

## Testing Layout

Next.js projects commonly use Playwright, Cypress, Vitest, or Jest. For async
Server Components, unit testing can be awkward depending on tooling, so protect
critical flows with integration and E2E tests.

```txt
modules/*/tests/       Unit tests for module behavior
tests/integration/     Integration tests
tests/e2e/             Full flows with Playwright/Cypress
```

Test business rules in `domain/` and `application/` whenever possible. Test
Server Actions and Route Handlers as boundaries.

## Common Mistakes

| Mistake | Better choice |
|---|---|
| Putting everything in `app/`. | Keep `app/` thin; move logic to features/modules. |
| Creating a huge `lib/`. | Split into features, shared utilities, server, or config. |
| Creating a huge `components/`. | Keep reusable UI shared; feature-specific UI in feature/module. |
| Importing DB from Client Components. | Use Server Components, Server Actions, or server boundaries. |
| Using `proxy.ts` for heavy logic. | Put heavy logic in server/application code. |
| Applying Clean Architecture to every CRUD screen. | Use modules only when complexity justifies them. |
| Not validating Server Actions. | Validate auth/authz/input inside every sensitive action. |
| Sharing too much in `shared/`. | Keep shared domain-agnostic and stable. |
| Not using route groups. | Use `(public)`, `(auth)`, `(app)`, `(admin)`, etc. |
| No naming conventions. | Enforce suffixes and route/component naming. |

## Checklist

- [ ] Structure matches project size.
- [ ] `app/` mostly contains routes, layouts, special files, metadata, and thin adapters.
- [ ] Product logic lives in `features/` or `modules/` when complexity requires it.
- [ ] `shared/` is reusable and domain-agnostic.
- [ ] `server/` is not imported by Client Components.
- [ ] Server Actions and Route Handlers validate authentication, authorization, and input.
- [ ] `proxy.ts` is thin and placed correctly for root vs `src/` projects.
- [ ] `instrumentation.ts` is at root or direct `src/`, never inside `app/` or `pages/`.
- [ ] Domain code does not import React, Next.js, DB clients, cookies, headers, or provider SDKs.
- [ ] Naming conventions are consistent and enforceable.
- [ ] Tests cover domain/application behavior and critical Next.js boundaries.

## Commands

```bash
# Review the shape of tracked Next.js files
git ls-files 'app/**' 'src/app/**' 'src/features/**' 'src/modules/**' 'src/server/**'

# Check whether a structure refactor is too large for one review
git diff --stat

# Check markdown whitespace before finishing skill edits
git diff --check -- 'skills/nextjs-project-structure/SKILL.md'
```
