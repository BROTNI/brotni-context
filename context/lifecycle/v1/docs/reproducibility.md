# Reproducibility

Simulation results are only meaningful if they are reproducible. A context definition should record enough information to reconstruct or audit what environment and state each candidate ran against.

## Required Recording Fields

### Dataset Digests

All dataset references should include a `digest` field (e.g., `sha256:...`). This ensures that the exact same data is used in every run.

### Environment Version

The `environment.version` field pins the runtime environment to a specific version. Environment drift (e.g., a base image update) can silently change candidate behavior.

### Context Digest

Set `reproducibility.recordContextDigest: true` to fingerprint the entire context definition at evaluation time. This allows auditing whether the context changed between runs.

### Seed

Set `reproducibility.seed` to a fixed integer when the simulation involves any randomized components. This ensures deterministic behavior.

## Reproducibility Checklist

- [ ] All dataset `ref` values are pinned and include `digest` fields.
- [ ] `environment.version` is explicitly set.
- [ ] `reproducibility.recordContextDigest: true`
- [ ] `reproducibility.recordDatasetDigests: true`
- [ ] `reproducibility.recordEnvironment: true`
- [ ] `reset` policy is defined to prevent state leakage.
- [ ] `recycle.invalidateOn` includes `dataset-change` and `environment-version-change`.
- [ ] `security.allowOutboundNetwork: false` (or explicitly justified)

## Non-Reproducible Patterns to Avoid

- Using `dataset://...` references without digests (data may change silently)
- Using `mode: stateful-replay` without explicit state isolation
- Setting `isolation.externalDependencies: real` (non-deterministic external calls)
- Omitting `reset.strategy` (state leaks between runs)
- Setting `recycle.invalidateOn` to an empty list (context may be reused after it becomes stale)
