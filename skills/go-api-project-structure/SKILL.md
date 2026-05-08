---
name: go-api-project-structure
description: >
  Structure small, medium, and large Go APIs with idiomatic cmd/internal layout,
  thin main functions and handlers, domain-oriented internal packages, transport
  boundaries, platform infrastructure, contracts, migrations, deployments,
  context propagation, testing layout, and Go naming conventions.
  Trigger: when creating, refactoring, or reviewing Go API/server project
  structure, cmd/internal layout, HTTP handlers, services/use cases, repositories,
  interfaces/ports, net/http routing, framework boundaries, migrations, contracts,
  deployments, or Go backend architecture.
license: MIT
metadata:
  author: adanft
  version: "1.0"
---

# Go API Project Structure

Use this skill to structure Go APIs in a way that feels like Go: simple packages,
explicit dependencies, small entry points, and no Java-style ceremony unless the
domain truly earns it.

This skill covers **small, medium, and large single Go API/server projects**.
Go workspaces and monorepos are intentionally out of scope unless explicitly
requested.

## Golden Rule

```txt
cmd/         = executable entry points: api, worker, migrate, cli
internal/    = private application code
api/         = external contracts: OpenAPI, Protobuf, AsyncAPI
migrations/  = database migrations
deployments/ = Docker, Kubernetes, Terraform, Helm
docs/        = technical docs and decisions
scripts/     = operational scripts
```

More important:

```txt
main.go stays small
handlers stay thin
services/use cases do not know HTTP
domain code does not know DB, routers, frameworks, or transports
infrastructure implements external details
```

Do not start with `src/`. Do not start with `pkg/` unless you are intentionally
publishing packages for other modules to import.

## Project Size Decision

| Size | Structure | Use when |
|---|---|---|
| Small | `cmd/ + internal/config + internal/httpapi + few modules` | MVP, simple CRUD, technical test, small microservice. |
| Medium | `cmd/ + internal/app + internal/platform + modules by feature/domain` | SaaS API with auth, users, billing, roles, notifications. |
| Large | Vertical domain modules inside `internal/` | Serious product with business rules, integrations, multiple binaries, and years of maintenance. |

Start from the smallest structure that protects clarity. Create folders only when
there is real code to put there.

## Go Rules to Respect

| Rule | Why it matters |
|---|---|
| Server logic normally lives in `internal/`. | Server projects are usually deployable binaries, not public libraries. |
| Commands live in `cmd/<name>/main.go`. | Keeps multiple binaries separated: API, worker, migrator, CLI. |
| `main.go` wires and runs. | Avoids mixing startup, routing, SQL, and business rules. |
| Prefer simple packages over artificial layers. | Go favors composition and small packages over ceremony. |
| Interfaces belong near the package that uses them. | Do not create interfaces before there is a real consumer. |
| Pass `context.Context` explicitly as the first parameter. | Propagates cancellation, deadlines, tracing, and request scope. |
| Use `testdata/` for fixtures. | Go tooling treats `testdata` as test data, not a normal package. |
| Format with `gofmt`; manage imports with `goimports`. | Style should not be a debate. |

## Routing and Framework Choice

Go APIs do not require a heavy framework by default. Since Go 1.22,
`net/http.ServeMux` supports method-aware patterns and wildcards:

```go
mux.HandleFunc("GET /users/{id}", handler)
id := r.PathValue("id")
```

For Go versions before 1.22, or when advanced routing ergonomics are needed, use
a router/framework or explicit method/path checks. In Go 1.22+ ServeMux, `GET`
patterns also match `HEAD` according to HTTP semantics.

Use `net/http` when it is enough. Use Chi, Gin, Echo, Fiber, or another router
only when the project needs their middleware, ergonomics, ecosystem, or routing
features.

Even if using a framework, hide it at the HTTP boundary. Services should receive
`context.Context` and typed input, not `*gin.Context`, `echo.Context`, or router
types.

## Small API Structure

Use this for a simple API, MVP, technical test, or small microservice.

```txt
go-api/
  cmd/
    api/
      main.go

  internal/
    config/
      config.go

    httpapi/
      server.go
      routes.go
      middleware.go
      errors.go

    user/
      user.go
      service.go
      repository.go
      errors.go

    database/
      postgres.go

    logger/
      logger.go

  migrations/
    000001_create_users.up.sql
    000001_create_users.down.sql
  testdata/
    users.json
  go.mod
  go.sum
  Makefile
  Dockerfile
  README.md
```

| Folder | Put here |
|---|---|
| `cmd/api/main.go` | Load config, create dependencies, start server. |
| `internal/config/` | Typed environment/config loading and validation. |
| `internal/httpapi/` | HTTP server, routes, middleware, HTTP errors. |
| `internal/user/` | User domain struct, service, repository contract/implementation, errors. |
| `internal/database/` | Database connection lifecycle. |
| `internal/logger/` | Logger setup and shared logging configuration. |
| `migrations/` | SQL migration files. |
| `testdata/` | Fixtures for tests. |

Small request flow:

```txt
HTTP request -> handler -> user service -> repository -> database
```

No `domain/`, `application/`, `infrastructure/`, `adapters/`, and `ports/`
ceremony is needed yet if the project is small.

## Medium API Structure

Use this when the API has real areas such as auth, users, billing, permissions,
notifications, files, or webhooks.

```txt
go-api/
  cmd/
    api/main.go
    worker/main.go
    migrate/main.go

  internal/
    app/
      bootstrap.go
      dependencies.go
      shutdown.go

    config/
      env.go
      config.go

    platform/
      database/postgres.go
      database/transaction.go
      logger/logger.go
      telemetry/tracing.go
      telemetry/metrics.go
      security/password.go
      security/jwt.go
      security/ratelimit.go
      cache/redis.go

    httpapi/
      server.go
      routes.go
      middleware/auth.go
      middleware/request_id.go
      middleware/cors.go
      response/json.go
      response/errors.go
      response/pagination.go

    auth/
      auth.go
      service.go
      ports.go
      errors.go
      httpapi/handler.go
      httpapi/dto.go
      postgres/repository.go

    user/
      user.go
      service.go
      ports.go
      errors.go
      httpapi/handler.go
      httpapi/dto.go
      postgres/repository.go

    billing/
      subscription.go
      invoice.go
      service.go
      ports.go
      errors.go
      httpapi/handler.go
      httpapi/dto.go
      postgres/repository.go
      stripe/gateway.go

  api/openapi/openapi.yaml
  migrations/
  deployments/docker/
  docs/decisions/
  scripts/
  tests/integration/
```

Medium-project rule:

```txt
app/      = application composition and lifecycle
platform/ = shared technical infrastructure
httpapi/  = general HTTP transport concerns
auth/     = auth domain/feature
user/     = user domain/feature
billing/  = billing domain/feature
```

This avoids huge `handlers/`, `services/`, and `repositories/` folders where no
one knows what belongs to which feature.

## Large API Structure

Use this for serious products with multiple modules, several binaries, external
integrations, background workers, and important business rules.

```txt
go-api/
  cmd/
    api/main.go
    worker/main.go
    migrate/main.go
    cli/main.go

  internal/
    app/
      api.go
      worker.go
      dependencies.go
      shutdown.go

    config/
      config.go
      env.go
      feature_flags.go

    platform/
      database/postgres.go
      database/transaction.go
      database/health.go
      cache/redis.go
      logger/logger.go
      telemetry/tracing.go
      telemetry/metrics.go
      security/password.go
      security/jwt.go
      security/ratelimit.go
      security/permissions.go
      clock/clock.go
      id/uuid.go
      queue/queue.go

    transport/
      httpapi/server.go
      httpapi/routes.go
      httpapi/health.go
      httpapi/middleware/auth.go
      httpapi/middleware/cors.go
      httpapi/middleware/request_id.go
      httpapi/middleware/recover.go
      httpapi/response/json.go
      httpapi/response/errors.go
      grpcapi/server.go
      grpcapi/interceptors.go

    identity/
      user.go
      email.go
      password.go
      policy.go
      service.go
      ports.go
      errors.go
      events.go
      httpapi/handler.go
      httpapi/dto.go
      httpapi/mapper.go
      postgres/repository.go
      postgres/mapper.go
      redis/session_store.go

    billing/
      subscription.go
      plan.go
      invoice.go
      money.go
      policy.go
      service.go
      ports.go
      errors.go
      events.go
      httpapi/handler.go
      httpapi/dto.go
      postgres/repository.go
      stripe/payment_gateway.go

    project/
      project.go
      member.go
      role.go
      policy.go
      service.go
      ports.go
      errors.go
      httpapi/handler.go
      postgres/repository.go

    notification/
      notification.go
      template.go
      service.go
      ports.go
      errors.go
      email/sender.go
      queue/consumer.go

  api/
    openapi/public-api.yaml
    proto/identity/identity.proto
    asyncapi/events.yaml
  migrations/
  deployments/docker/
  deployments/kubernetes/
  deployments/terraform/
  docs/architecture.md
  docs/folder-structure.md
  docs/decisions/
  scripts/
  tests/integration/
  tests/e2e/
  tests/contract/
  tools/
```

Large-project rule:

```txt
cmd -> app -> transport -> domain module service -> ports/interfaces
                                           ↑
                         adapters: postgres, redis, stripe, email, queue
```

Use this structure only when modules have real behavior, policies, integrations,
or lifecycle concerns. Do not create all folders for a simple CRUD endpoint.

## Folder Ownership Rules

| Folder | Owns | Must avoid |
|---|---|---|
| `cmd/` | Executable `package main` entry points. | Business logic, SQL, routes, validation rules. |
| `internal/app/` | Dependency wiring, server/worker creation, lifecycle, graceful shutdown. | Business rules and HTTP handler logic. |
| `internal/config/` | Environment parsing, validation, typed config. | Calling `os.Getenv` across the codebase. |
| `internal/platform/` | Shared infrastructure: DB, cache, logger, telemetry, security, queue, clock, IDs. | Product-specific business rules. |
| `internal/transport/httpapi/` | HTTP server, routes, global middleware, response/errors, health. | Use case logic and SQL. |
| `internal/transport/grpcapi/` | gRPC server, interceptors, service registration. | Duplicating business logic. |
| `internal/<module>/` | Domain structs, service/use cases, ports, policies, module errors/events. | Framework-specific code in core service/domain files. |
| `internal/<module>/httpapi/` | Module handlers, DTOs, HTTP mappers. | Business rules that belong in service/domain. |
| `internal/<module>/postgres/` | Postgres repository implementation and DB mappers. | Leaking SQL types into domain when avoidable. |
| `api/` | External contracts: OpenAPI, Protobuf, AsyncAPI, JSON schemas. | Go implementation logic. |
| `migrations/` | Versioned DB schema changes. | Unversioned manual DB changes. |
| `deployments/` | Docker, Kubernetes, Helm, Terraform. | Application code. |
| `docs/` | Architecture docs, ADRs, standards, diagrams. | Stale generated output. |

## Good `main.go` vs Bad `main.go`

Good:

```go
func main() {
    cfg := config.Load()
    application := app.NewAPI(cfg)

    if err := application.Run(); err != nil {
        log.Fatal(err)
    }
}
```

Bad:

```go
func main() {
    // routes, SQL, user logic, payments, validation,
    // JWT, logs, permissions, and shutdown all mixed together
}
```

## Business Module Shape

Prefer vertical modules over technical buckets in medium/large APIs.

```txt
internal/identity/
  user.go
  email.go
  password.go
  policy.go
  service.go
  ports.go
  errors.go
  events.go
  httpapi/
    handler.go
    dto.go
    mapper.go
  postgres/
    repository.go
    mapper.go
  redis/
    session_store.go
```

| File/folder | Purpose |
|---|---|
| `user.go` | Main domain struct/entity. |
| `email.go` | Value object or strong validation. |
| `policy.go` | Module authorization/business rules. |
| `service.go` | Use cases and orchestration. |
| `ports.go` | Interfaces required by the service. |
| `errors.go` | Typed module errors. |
| `events.go` | Domain/application events. |
| `httpapi/` | Handlers, DTOs, HTTP mappers. |
| `postgres/` | Repository implementation. |
| `redis/` | Cache/session implementation. |

## Interfaces and Ports

In Go, do not create interfaces just because a class diagram told you to. Define
interfaces when there is a real consumer, usually in the package that uses them.

Good:

```go
type UserRepository interface {
    FindByEmail(ctx context.Context, email Email) (*User, error)
    Save(ctx context.Context, user *User) error
}
```

`identity.Service` depends on this interface. `identity/postgres.Repository`
implements it.

Bad:

```txt
internal/interfaces/
internal/repositories/
internal/services/
```

Those folders usually become abstract dumping grounds.

## Context Rules

For request-based work, pass `context.Context` as the first parameter:

```go
func (s *Service) RegisterUser(ctx context.Context, input RegisterUserInput) (*User, error) {
    // ...
}
```

Do not store context in structs:

```go
type Service struct {
    ctx context.Context // avoid
}
```

Context should flow from HTTP/RPC/worker entry points into service calls and
external calls so cancellation, deadlines, tracing, and request-scoped values can
propagate.

## Framework Boundary

Bad:

```go
func (s *UserService) Register(c *gin.Context) error {
    // business logic using gin.Context
}
```

Better:

```go
func (s *UserService) Register(ctx context.Context, input RegisterUserInput) (*User, error) {
    // business logic without Gin, Chi, Echo, Fiber, or HTTP types
}
```

Framework/router types belong in:

```txt
internal/transport/httpapi/
internal/<module>/httpapi/
```

They do not belong in:

```txt
internal/<module>/service.go
internal/<module>/<domain>.go
```

## REST, gRPC, Events, and Workers

Large APIs may have several entry points:

```txt
cmd/api       HTTP REST
cmd/grpc      gRPC
cmd/worker    Queue workers
cmd/migrate   DB migrations
cmd/cli       Internal tooling
```

HTTP, gRPC, and workers are different ways to activate use cases. They must not
duplicate business logic.

```txt
POST /users          -> identity.Service.RegisterUser(ctx, input)
gRPC RegisterUser    -> identity.Service.RegisterUser(ctx, input)
Queue UserInvited    -> identity.Service.RegisterUser(ctx, input)
```

## `api/`, `migrations/`, `deployments/`, and `docs/`

| Folder | Purpose |
|---|---|
| `api/openapi/` | REST contracts for frontend/mobile/other services. |
| `api/proto/` | gRPC contracts. |
| `api/asyncapi/` | Event contracts. |
| `migrations/` | Versioned database schema changes. |
| `deployments/` | Docker/Kubernetes/Helm/Terraform deployment assets. |
| `docs/decisions/` | ADRs explaining technical decisions. |
| `scripts/` | Operational scripts such as seed, lint, test, generate. |
| `tools/` | Code generators or internal tooling. |

Contracts and migrations are part of the system. Version them with the code.

## `pkg/`: Usually No

For a backend API, prefer `internal/`. Use `pkg/` only when you intentionally
provide packages that other modules should import as a supported public API.

If a package becomes genuinely reusable across projects, consider extracting it
to its own module instead of dumping it into `pkg/` by habit.

## Naming Conventions

| Thing | Prefer |
|---|---|
| Package names | Short, lowercase, no underscores. |
| Bad package names | `common`, `utils`, `helpers`, `models`, `interfaces`. |
| Better package names | `identity`, `billing`, `money`, `password`, `permission`, `audit`. |
| Entrypoint | `cmd/api/main.go`, `cmd/worker/main.go`. |
| Service/use cases | `service.go`. |
| Required interfaces | `ports.go`. |
| Module errors | `errors.go`. |
| Policies/rules | `policy.go`. |
| Domain events | `events.go`. |
| HTTP handlers | `httpapi/handler.go`. |
| DTOs | `httpapi/dto.go`. |
| Mappers | `mapper.go`. |
| Repository implementation | `postgres/repository.go`, `redis/session_store.go`. |
| Routes/server | `routes.go`, `server.go`. |

Use `gofmt` always. Use `goimports` when available.

## Testing Layout

Most Go tests should live next to the package they test:

```txt
internal/identity/service.go
internal/identity/service_test.go
internal/identity/testdata/users.json
```

Use top-level `tests/` for broader tests:

```txt
tests/integration/
tests/e2e/
tests/contract/
```

| Test type | Prefer |
|---|---|
| Unit tests | Next to the package: `service_test.go`. |
| Handler tests | `httptest` with `http.Handler` or test server. |
| Repository tests | Integration tests with real DB/container or test DB. |
| E2E tests | `tests/e2e/`. |
| Contract tests | `tests/contract/`. |
| Fixtures | `testdata/`. |

Use table-driven tests for business rules. Use `go test -short` to skip expensive
integration tests when appropriate.

Use same-package tests when verifying internals. Use `package xxx_test` when you
want to test only the package's public API from the outside.

## Balanced Starting Point

For an API expected to grow from medium to large, start here and create folders
only as real code appears:

```txt
go-api/
  cmd/{api,worker,migrate}/main.go
  internal/
    app/
    config/
    platform/{database,cache,logger,telemetry,security,queue}/
    transport/httpapi/
    identity/{service.go,ports.go,errors.go,httpapi/,postgres/}
    billing/{service.go,ports.go,errors.go,httpapi/,postgres/,stripe/}
    project/{service.go,ports.go,errors.go,httpapi/,postgres/}
    notification/{service.go,ports.go,email/,queue/}
  api/{openapi,proto}/
  migrations/
  deployments/
  docs/decisions/
  scripts/
  tests/{integration,e2e,contract}/
```

## Common Mistakes

| Mistake | Better choice |
|---|---|
| Putting all logic in `main.go`. | Keep `main.go` as wiring and startup only. |
| Creating a huge `internal/common`. | Name packages by purpose: `money`, `password`, `permission`. |
| Creating interfaces for everything. | Define interfaces only when a consumer needs them. |
| Passing framework context to services. | Pass `context.Context` and typed input. |
| Handler talking directly to SQL. | Handler -> service -> repository interface -> adapter. |
| Using `pkg/` by default. | Prefer `internal/` for server-private code. |
| Copying Java layers blindly. | Use simple Go packages and vertical modules. |
| Not passing `context.Context`. | Propagate cancellation, deadlines, tracing. |
| Inconsistent HTTP errors. | Centralize response/error mapping. |
| No migrations. | Version DB schema changes. |
| No graceful shutdown. | Add lifecycle/shutdown handling in `app/`. |
| No timeouts. | Configure concrete `http.Server` timeouts such as `ReadHeaderTimeout`, `ReadTimeout`, `WriteTimeout`, and `IdleTimeout` when appropriate. |
| No structured logging. | Use a consistent logger such as standard `log/slog`. |

## Checklist

- [ ] No `src/` folder was added just because other ecosystems use it.
- [ ] `cmd/<binary>/main.go` is small.
- [ ] Application wiring lives in `internal/app/` when the project is medium/large.
- [ ] Private server logic lives under `internal/`.
- [ ] Handlers do not contain heavy business logic.
- [ ] Services/use cases do not import HTTP/router/framework types.
- [ ] Domain code does not import DB clients, framework types, or transport code.
- [ ] Interfaces are defined where they are consumed and only when needed.
- [ ] `context.Context` is passed explicitly as the first parameter for request work.
- [ ] HTTP, gRPC, and workers call the same use cases instead of duplicating logic.
- [ ] HTTP servers and clients have timeouts appropriate to the system.
- [ ] Server lifecycle includes graceful shutdown when running in production.
- [ ] External contracts live in `api/`.
- [ ] Migrations are versioned.
- [ ] Package names are lowercase, concise, and meaningful.
- [ ] Tests live next to packages or in the right top-level test folder.

## Commands

```bash
# Format and test Go code
go fmt ./...
go test ./...

# Run static checks when appropriate
go vet ./...

# Catch data races in tests when concurrency is relevant
go test -race ./...

# Run all tests with coverage
go test -cover ./...

# Skip integration tests that honor testing.Short
go test -short ./...

# Review project structure changes
git diff --stat
```
