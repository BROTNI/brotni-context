# brotni-context

**Brotni Context defines how simulation environments and state are prepared, reused, reset, and recycled so that candidates can be compared under fair and reproducible conditions.**

A context specification is not a runtime recipe. A recipe describes how a candidate runs. A context describes the environment, state, data, and lifecycle rules around that run.

---

## What is Brotni Context?

Brotni Context is a public specification repository that defines how simulation contexts are prepared, hydrated, warmed up, snapshotted, cloned, used during runs, collected from, reset, recycled, and discarded.

In Brotni, a **simulation context** is the controlled environment and state against which one or more candidates are evaluated. A context may include:

- Runtime environment state
- Datasets
- Traffic replay inputs
- Database state
- Message queues
- Caches
- Feature flags
- Configuration snapshots
- Dependency mocks
- Service mesh state
- Generated test data
- Warmup state
- Isolation rules
- Reset and recycling policies

## The Three-Layer Model

```
Simulation Spec = what should be evaluated
Recipe          = how a candidate runs
Context         = where and under what state the candidate runs
```

These three layers are deliberately separate:

- A **Simulation Spec** defines evaluation goals, constraints, KPIs, datasets, and scoring intent.
- A **Recipe** describes how a candidate is built and executed.
- A **Context** describes the environment, state, data, and lifecycle rules that surround the run.

See [docs/relation-to-recipes.md](docs/relation-to-recipes.md) and [docs/relation-to-simulation-specs.md](docs/relation-to-simulation-specs.md).

## Why Context Lifecycle Matters

Simulation results are only trustworthy when each candidate is evaluated against a controlled, reproducible, and fairly recycled context.

Without explicit lifecycle management:
- Context state leaks between runs, contaminating results.
- Expensive environment setup is repeated unnecessarily.
- Warmup state differs between candidates.
- Dataset freshness is not guaranteed.
- Recycling decisions are ad hoc and unaudited.

## Why Snapshotting is Only One Strategy

Snapshotting is a useful technique, but it is not the only way to manage context lifecycle. The supported strategies include:

| Mode | Description |
|------|-------------|
| `clean` | Each run starts from a freshly prepared context. |
| `snapshot-clone` | A baseline context is snapshotted once and cloned for each candidate. |
| `warm-cache` | The context includes a controlled warmup phase before evaluation. |
| `stateful-replay` | The context evolves across a replay or scenario timeline. |

Future strategies such as `database-restore`, `queue-hydration`, `traffic-replay-context`, `feature-flag-context`, and `mocked-dependencies-context` are also within scope.

See [docs/concepts.md](docs/concepts.md) for definitions of all terms.

## Why This Repository is Named `brotni-context`

The repository is named `brotni-context`, not `brotni-context-snapshot.v1` or `brotni-context-snapshot\`, because snapshotting is only one possible context lifecycle strategy.

Versioning lives inside:
- `apiVersion` fields (e.g., `context.brotni.com/v1`)
- Schema filenames (e.g., `context-lifecycle.v1.schema.json`)
- Directory versions (e.g., `context/lifecycle/v1/`)
- Git tags and releases

See [docs/context-versioning.md](docs/context-versioning.md).

## Lifecycle Stages

Every simulation context passes through a defined lifecycle:

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

## Specifications

### `context/lifecycle/v1`

The first context specification defines the full lifecycle contract for controlled simulation contexts.

- **API Version**: `context.brotni.com/v1`
- **Kind**: `SimulationContext`
- **Directory**: [context/lifecycle/v1/](context/lifecycle/v1/)
- **Schema**: [context/lifecycle/v1/schema/context-lifecycle.v1.schema.json](context/lifecycle/v1/schema/context-lifecycle.v1.schema.json)

## Validating Examples

To validate all YAML context examples and fixtures:

```bash
./scripts/validate-contexts.sh
```

Prerequisites: Python 3 with `jsonschema` and `pyyaml`, or `ajv-cli`.

See [scripts/validate-contexts.sh](scripts/validate-contexts.sh).

## Documentation

| Document | Description |
|----------|-------------|
| [docs/concepts.md](docs/concepts.md) | Definitions for all core terms |
| [docs/context-versioning.md](docs/context-versioning.md) | How versioning works in this repo |
| [docs/relation-to-recipes.md](docs/relation-to-recipes.md) | How context relates to runtime recipes |
| [docs/relation-to-simulation-specs.md](docs/relation-to-simulation-specs.md) | How context relates to simulation specs |
| [docs/reproducibility-model.md](docs/reproducibility-model.md) | How reproducibility is guaranteed |
| [docs/security-model.md](docs/security-model.md) | Security and secret handling |
| [docs/glossary.md](docs/glossary.md) | Quick reference glossary |

## Contributing Future Context Modes

To contribute a new context mode or lifecycle extension:

1. Read [CONTRIBUTING.md](CONTRIBUTING.md).
2. Review existing modes in [context/lifecycle/v1/docs/modes.md](context/lifecycle/v1/docs/modes.md).
3. Add a new mode definition, examples, valid/invalid fixtures, and documentation.
4. Update the JSON Schema to include the new mode value.
5. Ensure `./scripts/validate-contexts.sh` passes.
6. Open a pull request with a clear description of the new mode and its use cases.

## License

Apache License 2.0. See [LICENSE](LICENSE).
