---
name: react-vite-project-structure
description: >
  Structure small, medium, and large React + Vite apps with clear app bootstrapping,
  pages, widgets, features, entities, shared code, state ownership, API boundaries,
  environment safety, testing layout, and Vite/TypeScript conventions.
  Trigger: when creating, refactoring, or reviewing React + Vite project structure,
  folder layout, Feature-Sliced Design layers, React Router setup, state placement,
  TanStack Query usage, API clients, environment variables, Storybook, testing, or
  frontend architecture boundaries.
license: MIT
metadata:
  author: adanft
  version: "1.0"
---

# React + Vite Project Structure

Use this skill to keep a React + Vite app easy to navigate as it grows. The goal
is not to create empty folders; the goal is to make code easy to find, change,
test, and reason about.

This skill covers **small, medium, and large single React + Vite apps**.

## Golden Rule

```txt
app      = global bootstrapping: providers, router, store, global styles
pages    = screens/routes
widgets  = large reusable UI blocks
features = user actions and capabilities
entities = business concepts
shared   = reusable code with no feature-specific business logic
```

As the app grows, less code should live in generic `components/`, `hooks/`, and
`utils/`, and more code should be grouped by feature, entity, and responsibility.

## Project Size Decision

| Size | Structure | Use when |
|---|---|---|
| Small | `src/components`, `src/pages`, `src/hooks`, `src/lib` | Landing, MVP, portfolio, small panel, few screens. |
| Medium | `src/app`, `src/features`, `src/entities`, `src/shared` | Auth, users, billing, dashboard, settings, products, orders. |
| Large | Feature-Sliced / domain-based: `app`, `pages`, `widgets`, `features`, `entities`, `shared` | Many screens, reusable blocks, business concepts, growing team. |

Start with the smallest structure that keeps clarity. Add folders only when there
is real code and real complexity to put there.

For Feature-Sliced style layouts, do not force every layer. Add `widgets/`,
`features/`, and `entities/` only when they make ownership easier to understand.

## Vite Basics to Respect

| Item | Rule |
|---|---|
| `index.html` | Project root entry point. In Vite, it is not hidden in `public/`. |
| `public/` | Static public assets served as-is: favicon, robots, public images. |
| `src/main.tsx` | React mount only: create root, wrap providers, render app. Keep it tiny. |
| `src/App.tsx` or `src/app/App.tsx` | App composition. May contain router/layout for small apps. |
| `import.meta.env` | Vite environment access. Only `VITE_*` custom variables are exposed to client code. |
| TypeScript | Vite transpiles TS; run `tsc --noEmit`, `tsc -b`, or the project typecheck script separately. |

Frontend env is public configuration. Never put real secrets in `VITE_*`.

## Small Project Shape

Use this for simple apps with few screens and light business rules.

```txt
react-vite-app/
  public/
    favicon.svg
    robots.txt

  src/
    main.tsx
    App.tsx
    assets/
      images/
      icons/
    components/
      ui/
        button.tsx
        input.tsx
        modal.tsx
      layout/
        header.tsx
        footer.tsx
        sidebar.tsx
    pages/
      home-page.tsx
      login-page.tsx
      dashboard-page.tsx
      not-found-page.tsx
    hooks/
      use-debounce.ts
      use-media-query.ts
    lib/
      cn.ts
      format-date.ts
      format-money.ts
      validators.ts
    api/
      http-client.ts
    styles/
      globals.css
      theme.css
    types/
      common.ts

  tests/
    setup.ts

  index.html
  vite.config.ts
  tsconfig.json
  package.json
  eslint.config.js
```

| Folder | Put here |
|---|---|
| `src/main.tsx` | `ReactDOM.createRoot`, `StrictMode`, app providers, app render. |
| `src/App.tsx` | Main composition, router, or base layout for small apps. |
| `src/assets/` | Images, SVGs, icons imported from code. |
| `src/components/ui/` | Generic visual components: Button, Input, Modal, Card. |
| `src/components/layout/` | Header, Footer, Sidebar. |
| `src/pages/` | Complete screens: Home, Login, Dashboard, NotFound. |
| `src/hooks/` | Generic reusable hooks only. |
| `src/lib/` | Pure reusable utilities: dates, money, strings, validators. |
| `src/api/` | Basic HTTP client or fetch/axios wrapper. |
| `src/styles/` | Global CSS, theme, tokens. |
| `src/types/` | Minimal shared global types. |

This is enough when there are few screens, few business rules, one or few
developers, no serious design system, and no many product modules.

## Medium Project Shape

Use this when product areas are clear: auth, users, billing, dashboard, settings,
reports, products, orders, etc.

```txt
src/
  main.tsx

  app/
    App.tsx
    providers/
      app-providers.tsx
      router-provider.tsx
      query-provider.tsx
      theme-provider.tsx
    router/
      routes.tsx
      protected-route.tsx
    store/
      store.ts
    styles/
      globals.css

  pages/
    home/home-page.tsx
    login/login-page.tsx
    dashboard/dashboard-page.tsx
    settings/settings-page.tsx
    not-found/not-found-page.tsx

  features/
    auth/
      components/login-form.tsx
      hooks/use-login.ts
      api/auth-api.ts
      model/auth-store.ts
      schemas/login-schema.ts
      types/auth-types.ts
      index.ts
    users/
      components/user-form.tsx
      hooks/use-users.ts
      api/users-api.ts
      model/users-store.ts
      schemas/user-schema.ts
      types/users-types.ts
      index.ts

  entities/
    user/
      model/user.ts
      api/user-queries.ts
      ui/user-avatar.tsx
      ui/user-badge.tsx
      index.ts

  shared/
    ui/
    api/
      http-client.ts
      query-client.ts
      api-error.ts
    config/
      env.ts
      routes.ts
      feature-flags.ts
    lib/
      dates/format-date.ts
      money/format-money.ts
      strings/slugify.ts
    styles/tokens.css
    types/common.ts
```

Medium-project rule:

```txt
app/ = global app setup
pages/ = screens
features/ = user capabilities
entities/ = business concepts
shared/ = reusable foundation
```

Avoid letting everything end in generic folders like `components/`, `hooks/`,
`services/`, `utils/`, and `types/`. Those work at first, then hide ownership.

## Large Project Shape

Use this for serious apps where Feature-Sliced / domain-based structure protects
against circular dependencies and ownership confusion.

```txt
src/
  main.tsx

  app/
    App.tsx
    providers/
    router/
    store/
    styles/
    config/

  pages/
    home/
      ui/home-page.tsx
      index.ts
    dashboard/
      ui/dashboard-page.tsx
      model/use-dashboard-data.ts
      index.ts
    project-details/
      ui/project-details-page.tsx
      model/use-project-details.ts
      index.ts

  widgets/
    app-shell/
      ui/app-shell.tsx
      ui/app-sidebar.tsx
      ui/app-topbar.tsx
      model/use-app-shell.ts
      index.ts
    dashboard-stats/
      ui/dashboard-stats.tsx
      model/use-dashboard-stats.ts
      index.ts
    project-table/
      ui/project-table.tsx
      model/use-project-table.ts
      index.ts

  features/
    auth/
      login/
        ui/login-form.tsx
        model/use-login-form.ts
        api/login-api.ts
        schemas/login-schema.ts
        index.ts
      logout/
        ui/logout-button.tsx
        model/use-logout.ts
        api/logout-api.ts
        index.ts
    project/
      create-project/
        ui/create-project-form.tsx
        model/use-create-project.ts
        api/create-project-api.ts
        schemas/create-project-schema.ts
        index.ts

  entities/
    user/
      model/user.ts
      model/user-role.ts
      api/user-api.ts
      api/user-queries.ts
      ui/user-avatar.tsx
      ui/user-badge.tsx
      lib/get-user-display-name.ts
      index.ts
    project/
      model/project.ts
      model/project-status.ts
      api/project-queries.ts
      ui/project-card.tsx
      ui/project-status-badge.tsx
      lib/can-edit-project.ts
      index.ts

  shared/
    ui/button/button.tsx
    ui/input/input.tsx
    ui/dialog/dialog.tsx
    api/http-client.ts
    api/query-client.ts
    api/api-error.ts
    config/env.ts
    config/routes.ts
    config/feature-flags.ts
    lib/dates/format-date.ts
    lib/money/format-money.ts
    assets/
    styles/tokens.css
    types/common.ts

  tests/
    unit/
    integration/
    e2e/
    fixtures/

  .storybook/
```

## Layer Ownership Rules

| Layer | Owns | Must avoid |
|---|---|---|
| `app/` | Providers, router, global store, global styles, app config, global boundaries. | Feature UI, business-specific API calls, billing/user logic. |
| `pages/` | Screens/routes that compose widgets, features, entities, shared UI. | Reusable business logic that belongs lower. |
| `widgets/` | Large UI blocks: shell, sidebar, dashboard stats, tables, menus. | Importing pages. |
| `features/` | User actions: login, checkout, create project, invite member. | Importing other features directly. |
| `entities/` | Business concepts: user, project, invoice, product, order. | Knowing about features/pages/widgets. |
| `shared/` | UI kit, base API client, config, pure libs, assets, common types. | Business-specific code like billing helpers or user cards. |

## Import Direction

For large apps, follow this direction:

```txt
app
 ↓
pages
 ↓
widgets
 ↓
features
 ↓
entities
 ↓
shared
```

Allowed examples:

- `pages -> widgets/features/entities/shared`
- `widgets -> features/entities/shared`
- `features -> entities/shared`
- `entities -> shared`

Forbidden examples:

- `shared -> features/entities`
- `entities -> features`
- `features -> widgets/pages`
- `widgets -> pages`
- one feature importing another feature directly

If two features need the same thing, move that thing to `entities/`, `shared/`,
or compose both features from a widget/page above them.

## State Placement

Each piece of state needs one clear source of truth. Avoid redundant, duplicated,
contradictory, or deeply nested state.

| State type | Prefer |
|---|---|
| Input/modal local state | Inside the component. |
| Form state | `features/*/model`. |
| Global UI state | `app/store` or `shared` if truly generic. |
| Authenticated user state | `entities/user` or `features/auth`, depending on ownership. |
| Server state | TanStack Query / RTK Query / data layer. |
| Page filters | `pages/*/model` or URL query params. |
| Shared business state | Entity model, query cache, or global store only when justified. |

Do not use `useEffect` to derive state that can be calculated during render.
Effects are for synchronization with external systems.

## Server State vs Client State

Client state is UI state: modal open, active tab, current input, theme, sidebar.

Server state is remote data: users, products, invoices, projects, permissions,
subscriptions.

Use a server-state tool such as TanStack Query when caching, deduplication,
background updates, invalidation, pagination, mutations, or optimistic updates
matter.

Placement:

```txt
shared/api/query-client.ts
entities/user/api/user-queries.ts
features/auth/login/api/login-api.ts
features/project/create-project/api/create-project-api.ts
```

Rule: the base HTTP/query client lives in `shared/api`; business endpoints live
in `entities/` or `features/`.

## Environment Variables

Use one env module, usually `shared/config/env.ts`:

```ts
export const env = {
  apiUrl: import.meta.env.VITE_API_URL,
  appEnv: import.meta.env.MODE,
};
```

Rules:

- `VITE_*` variables are exposed to client code.
- Frontend env is public configuration, not secret storage.
- Backend secrets must never live in React/Vite env variables.
- Add `vite-env.d.ts` typing for custom env variables when useful.

## React Router

For normal Vite apps, use React Router as a library with `BrowserRouter` or a
router provider inside `app/router`.

```txt
src/app/router/routes.tsx
src/app/router/protected-route.tsx
```

If using React Router framework mode with the Vite plugin, expect a different
entry/routing shape with route modules, loaders, actions, automatic code
splitting, optional pre-rendering, and optional server rendering. Do not mix both
mental models casually.

## Testing Layout

Use Vitest for unit/integration tests in Vite apps unless the project has a clear
reason not to. Use Playwright or Cypress for E2E tests.

```txt
tests/
  setup.ts
  unit/
  integration/
  e2e/
  fixtures/
```

Tests can also live next to the code they verify:

```txt
features/auth/login/ui/login-form.test.tsx
features/auth/login/model/use-login-form.test.ts
shared/ui/button/button.test.tsx
```

| Test type | Prefer |
|---|---|
| Small component test | Next to component. |
| Hook test | Next to hook. |
| Feature test | Inside the feature. |
| Integration test | `tests/integration`. |
| E2E test | `tests/e2e`. |
| Fixtures | `tests/fixtures`. |

## Storybook and UI Isolation

For large apps or a growing UI kit, add Storybook:

```txt
.storybook/
  main.ts
  preview.ts

src/shared/ui/button/
  button.tsx
  button.stories.tsx
  button.test.tsx
  index.ts
```

Use Storybook for reusable UI and visual states, not for hiding business logic in
shared components.

## TypeScript and Scripts

Vite transpiles TypeScript but does not replace full type checking. Run
`tsc --noEmit`, `tsc -b`, or the project's equivalent typecheck script in CI and
before production builds.

Recommended scripts:

```json
{
  "scripts": {
    "dev": "vite",
    "build": "tsc --noEmit && vite build",
    "build:refs": "tsc -b && vite build",
    "preview": "vite preview",
    "test": "vitest",
    "typecheck": "tsc --noEmit",
    "lint": "eslint ."
  }
}
```

## Naming Conventions

| Thing | Convention | Example |
|---|---|---|
| React component symbol | `PascalCase` | `LoginForm` |
| Component file | `kebab-case.tsx` | `login-form.tsx` |
| Hook | `use-*.ts` | `use-login-form.ts` |
| Store | `*.store.ts` | `auth.store.ts` |
| Schema | `*.schema.ts` | `login.schema.ts` |
| Types | `*.types.ts` | `auth.types.ts` |
| API file | `*-api.ts` | `auth-api.ts` |
| Query file | `*-queries.ts` | `user-queries.ts` |
| Test | `*.test.tsx` / `*.test.ts` | `login-form.test.tsx` |
| Story | `*.stories.tsx` | `button.stories.tsx` |
| Public API | `index.ts` | `features/auth/index.ts` |

Pick one convention per repo and enforce it consistently.

## Common Mistakes

| Mistake | Better choice |
|---|---|
| Putting everything in `components/`. | Move feature-specific UI to `features/` or `widgets/`. |
| Putting all hooks in `hooks/`. | Keep feature hooks inside the feature; shared hooks only if generic. |
| Creating a huge `utils.ts`. | Split by purpose under `shared/lib/*`. |
| Putting API calls in components. | Use feature/entity API modules. |
| Storing everything globally. | Keep state as local as possible. |
| Using Redux/Zustand for server state. | Prefer query/cache tools for remote data. |
| Duplicating derived state. | Derive during render when possible. |
| Using `useEffect` for everything. | Use Effects for external synchronization only. |
| Putting secrets in `VITE_*`. | Treat frontend env as public. |
| Skipping type checking. | Run `tsc --noEmit`, `tsc -b`, or the project typecheck script separately from Vite transform. |
| Creating a huge `shared/`. | Keep shared generic and dependency-light. |

## Balanced Starting Point

For an app expected to grow, start from the large shape but create folders only
when real code exists. The practical default is:

```txt
src/{app,pages,widgets,features,entities,shared}
tests/{unit,integration,e2e,fixtures}
docs/{architecture.md,folder-structure.md,decisions/}
.storybook/ when reusable UI needs isolated review
```

## Checklist

- [ ] Structure matches project size.
- [ ] `main.tsx` is tiny and only mounts React.
- [ ] `app/` owns global setup, not feature logic.
- [ ] Pages compose; reusable logic lives lower.
- [ ] Features represent user actions.
- [ ] Entities represent business concepts.
- [ ] Shared does not import business-specific code.
- [ ] Import direction follows `app -> pages -> widgets -> features -> entities -> shared`.
- [ ] Server state is not treated as ordinary global client state.
- [ ] `VITE_*` variables contain no secrets.
- [ ] Type checking runs separately from Vite transform.
- [ ] Tests live near code or in the right top-level test folder.

## Commands

```bash
# Check TypeScript separately from Vite transform when this script exists
npm run typecheck

# Or call TypeScript directly when appropriate
tsc --noEmit

# Run Vite/Vitest projects using package scripts when available
npm run lint
npm run test

# Review project structure changes
git diff --stat
```
