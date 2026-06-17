# Isolation

Simulation contexts must isolate candidates from each other and from external systems to ensure fair and reproducible evaluation.

## Network Isolation

| Value | Description |
|-------|-------------|
| `sandboxed` | Outbound network is blocked or proxied. No external calls unless explicitly allowed. |
| `host` | Candidate shares the host network. Not recommended for most simulation scenarios. |
| `none` | No network isolation. Use only in trusted, fully controlled environments. |

Recommended: `sandboxed` for all production simulation campaigns.

## Filesystem Isolation

| Value | Description |
|-------|-------------|
| `copy-on-write` | Writes are isolated to a per-candidate overlay. |
| `read-only` | Shared filesystem is read-only; writes are forbidden. |
| `ephemeral` | Candidate gets a fresh ephemeral filesystem per run. |
| `shared` | Filesystem is shared across candidates. Use only for intentional shared state tests. |

## Database Isolation

| Value | Description |
|-------|-------------|
| `restore-from-snapshot` | Database state is restored from a snapshot before each run. |
| `per-candidate-instance` | Each candidate gets a separate database instance. |
| `shared` | Database is shared across candidates. Only safe when no writes occur. |

## External Dependency Isolation

| Value | Description |
|-------|-------------|
| `mocked` | All external dependencies are replaced with controlled mocks. Recommended for reproducibility. |
| `real` | Real external dependencies are used. Adds non-determinism; use only when necessary. |
| `blocked` | All external dependency calls are blocked and will fail. Use to detect unexpected external calls. |

## Isolation and Fairness

All candidates in a simulation campaign must be evaluated under the same isolation policy. Changing isolation between candidates invalidates comparisons.
