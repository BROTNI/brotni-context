# Reproducibility Model

Simulation results are only trustworthy if they are reproducible. This means that given the same context definition, the same datasets, and the same candidate, a run should produce equivalent results.

## Why Reproducibility is Hard

Several factors introduce non-determinism into simulation runs:

- **Dataset drift**: Datasets referenced without digests may change between runs.
- **Environment drift**: Runtime images or dependencies may be updated silently.
- **Warmup variation**: Warmup procedures that are not deterministic produce different cache states.
- **State leakage**: Insufficient reset policies allow state from one run to affect another.
- **External calls**: Unblocked outbound network calls introduce external non-determinism.
- **Randomization**: Unseeded random number generators produce different sequences each run.
- **Recycling drift**: Snapshots that are not invalidated when their inputs change become stale.

## What Context Definitions Should Record

### Dataset Digests

All dataset references should include a `digest` field (e.g., `sha256:...`). This pins the dataset to an exact version.

### Environment Version

The `environment.version` field pins the runtime to a specific version. Without it, an image update can silently change candidate behavior.

### Context Digest

Set `reproducibility.recordContextDigest: true` to fingerprint the context definition itself. This enables detection of unintended context drift between campaigns.

### Seed

Set `reproducibility.seed` when any component uses randomization. This ensures deterministic behavior across runs.

### Reset Policy

A defined `reset.strategy` prevents state from leaking between candidate runs.

### Recycle Policy

A defined `recycle.invalidateOn` list ensures that stale snapshots are not reused after their inputs change.

### Security Policy

`security.allowOutboundNetwork: false` prevents candidates from making non-deterministic external calls.

### Candidate Isolation

Per-candidate clones (`clone.perCandidate: true`) ensure that no candidate can affect another's context state.

## Reproducibility Checklist

- [ ] All dataset `ref` values include `digest` fields
- [ ] `environment.version` is set
- [ ] `reproducibility.recordContextDigest: true`
- [ ] `reproducibility.recordDatasetDigests: true`
- [ ] `reproducibility.recordEnvironment: true`
- [ ] `reset.strategy` is defined
- [ ] `recycle.invalidateOn` includes `dataset-change` and `environment-version-change`
- [ ] `security.allowOutboundNetwork: false`
- [ ] `clone.perCandidate: true` (for multi-candidate campaigns)
