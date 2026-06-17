# Lifecycle Stages

Every simulation context passes through a defined set of lifecycle stages. Not all stages are required for every mode.

## Stage Definitions

### `prepare`

Provision or prepare the base environment. This may include:
- Allocating compute resources
- Initializing the runtime (e.g., starting a container, VM, or process group)
- Applying base configuration

This stage must complete before any other stage can begin.

### `hydrate`

Load datasets, configuration, state, mocks, queues, or other required inputs into the environment. This may include:
- Importing datasets from dataset references
- Restoring database snapshots
- Seeding queues with replay data
- Applying configuration snapshots
- Registering mocked dependencies

### `warmup`

Optionally bring caches, models, services, or data paths into a controlled warmed state. This stage:
- Is optional
- Must use a defined strategy (e.g., `fixed-duration`, `traffic-replay`)
- Must be equivalent for all candidates if used

Skipping warmup means the candidate runs cold. This may be intentional (for cold-start evaluation) or a mistake. Always set `warmup.enabled` explicitly.

### `snapshot`

Optionally capture a reusable baseline context. The snapshot:
- Is taken after the specified stages (e.g., after `prepare`, `hydrate`, `warmup`)
- Represents a known-good baseline state
- Can be referenced by the `clone` stage

Required when `mode: snapshot-clone`.

### `clone`

Optionally create an isolated context instance from a baseline or snapshot. Each candidate receives its own clone, ensuring that mutations from one run do not affect another.

Clone strategies:
- `copy-on-write`: Fast; only modified pages are duplicated.
- `full-copy`: Slower but simpler; a complete copy is made.
- `overlay`: Uses a layered filesystem or storage overlay.

### `run`

Allow a candidate simulation run to execute against the context. During this stage:
- The candidate has access to the prepared environment and state
- Outbound network may be restricted per the `isolation` policy
- Context-level metrics and traces should be collected

### `collect`

Collect context-level outputs, logs, metrics, traces, state changes, or artifacts after the run. This may include:
- Performance metrics
- Log dumps
- State diffs
- Artifact exports

### `reset`

Restore or clean the context after a candidate run. Reset strategies:
- `restore-snapshot`: Restore from the baseline snapshot (recommended for `snapshot-clone`)
- `drop-and-reprepare`: Tear down and rebuild from scratch
- `truncate-state`: Clear mutable state but retain the base environment
- `none`: No reset (use only when contamination is acceptable)

### `recycle`

Reuse a context or snapshot for subsequent runs, according to defined safety rules. Recycling is valid only if none of the `invalidateOn` conditions have been met.

Invalidation triggers include:
- `schema-change`
- `dataset-change`
- `environment-version-change`
- `security-policy-change`

### `discard`

Destroy or invalidate the context when it should no longer be used. This stage:
- Releases resources
- May optionally retain context metadata for audit (`retainForAudit: true`)
- Should be triggered after campaign completion or snapshot expiry
