# SimulationContext v1

```
apiVersion: context.brotni.com/v1
kind: SimulationContext
```

A simulation is only trustworthy when each candidate is evaluated against a controlled, reproducible, and fairly recycled context.

This specification defines the lifecycle contract for controlled simulation contexts in Brotni.

---

## What is a SimulationContext?

A `SimulationContext` is a structured definition of the environment, state, data, and lifecycle rules that surround a candidate simulation run.

It is **not** a runtime recipe. A recipe describes how a candidate executes. A context describes what the candidate runs against.

## When to Use Each Mode

| Mode | Use When |
|------|----------|
| `clean` | Fairness over speed; state must never be reused; environment is cheap to create; high contamination risk. |
| `snapshot-clone` | Many candidates under identical conditions; expensive preparation; both reproducibility and speed matter. **Recommended default.** |
| `warm-cache` | Cache state affects behavior; warm vs cold performance must be measured deliberately. |
| `stateful-replay` | Long-running state transitions; candidates evaluated across sequential events. **Advanced.** |

## Lifecycle Stages

```
prepare → hydrate → warmup → snapshot → clone → run → collect → reset → recycle → discard
```

| Stage | Description |
|-------|-------------|
| `prepare` | Provision or prepare the base environment. |
| `hydrate` | Load datasets, configuration, state, mocks, queues, or other required inputs. |
| `warmup` | Optionally bring caches, models, services, or data paths into a controlled warmed state. |
| `snapshot` | Optionally capture a reusable baseline context. |
| `clone` | Optionally create an isolated context instance from a baseline or snapshot. |
| `run` | Allow a candidate simulation run to execute against the context. |
| `collect` | Collect context-level outputs, logs, metrics, traces, state changes, or artifacts. |
| `reset` | Restore or clean the context after a candidate run. |
| `recycle` | Reuse a context or snapshot according to defined safety rules. |
| `discard` | Destroy or invalidate the context when it should no longer be used. |

See [docs/lifecycle-stages.md](docs/lifecycle-stages.md) for full stage definitions.

## Fairness and Reproducibility

All context definitions should record:

- Dataset digests (to ensure the same data is used across runs)
- Environment version (to ensure the same runtime)
- Context digest (to detect unintended context drift)
- Seed and randomization configuration
- Reset policy (to prevent state leakage)
- Recycle policy (to control safe reuse)

See [docs/reproducibility.md](docs/reproducibility.md).

## Isolation Expectations

Contexts must isolate candidates from:

- Each other's file system writes
- Each other's database mutations
- External outbound network calls (unless explicitly permitted)
- Shared secret or credential state

See [docs/isolation.md](docs/isolation.md).

## Reset and Recycling Policies

- **Reset**: Every run should define how the context is restored. `restore-snapshot` is the recommended strategy for `snapshot-clone` mode.
- **Recycle**: Snapshots may be reused across multiple runs. Recycling must define invalidation conditions (e.g., schema change, dataset change, environment version change).

See [docs/recycling.md](docs/recycling.md).

## Audit and Traceability

A context definition should be versioned, digested, and linked to simulation runs to enable full auditability. Use `reproducibility.recordContextDigest: true` to ensure the context is fingerprinted at evaluation time.

## Validation

Validate all context YAMLs from the repository root:

```bash
./scripts/validate-contexts.sh
```

## Examples

- [examples/clean/context.yaml](examples/clean/context.yaml)
- [examples/snapshot-clone/context.yaml](examples/snapshot-clone/context.yaml)
- [examples/warm-cache/context.yaml](examples/warm-cache/context.yaml)
- [examples/stateful-replay/context.yaml](examples/stateful-replay/context.yaml)
- [examples/full/context.yaml](examples/full/context.yaml)
