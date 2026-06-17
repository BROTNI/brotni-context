# Recycling

Context recycling allows a prepared and snapshotted context to be reused across multiple candidate runs without re-preparing from scratch. This saves time while preserving reproducibility, subject to defined safety rules.

## When Recycling is Safe

Recycling is safe when:
- The baseline snapshot was prepared from pinned dataset digests and environment version
- The snapshot has not been invalidated by any trigger
- The recycle counter has not exceeded `maxRunsPerSnapshot`

## Invalidation Triggers

A recycled context must be invalidated and re-prepared when any of the following occur:

| Trigger | Description |
|---------|-------------|
| `schema-change` | The context schema version changed |
| `dataset-change` | One or more dataset digests changed |
| `environment-version-change` | The runtime environment version changed |
| `security-policy-change` | The security policy changed |
| `manual` | A maintainer explicitly invalidated the snapshot |
| `time-based` | The snapshot has exceeded its maximum age |

## Recycle vs Reset

- **Reset** happens after each candidate run (within a campaign). It restores the context to the baseline snapshot state.
- **Recycle** determines whether the snapshot itself can be reused for a new campaign or a new set of candidates.

Both policies must be defined explicitly. Omitting either introduces ambiguity about context safety.

## Example Recycle Policy

```yaml
recycle:
  enabled: true
  maxRunsPerSnapshot: 20
  invalidateOn:
    - schema-change
    - dataset-change
    - environment-version-change
    - security-policy-change
```
