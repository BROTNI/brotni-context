# Context Versioning

## Why This Repository is Named `brotni-context`

The repository is named `brotni-context`, not `brotni-context-snapshot.v1` or `brotni-context-snapshot`.

**Snapshotting is only one possible context lifecycle strategy.**

The repository supports the full family of context lifecycle specifications, including:

- `clean`
- `snapshot-clone`
- `warm-cache`
- `stateful-replay`

And future strategies such as:

- `database-restore`
- `queue-hydration`
- `traffic-replay-context`
- `feature-flag-context`
- `mocked-dependencies-context`

Naming the repository after a single strategy would limit its scope and mislead contributors about what belongs here.

## Where Versioning Lives

Version information lives inside the specification, not in the repository name:

| Location | Example |
|----------|---------|
| `apiVersion` field | `context.brotni.com/v1` |
| Schema filename | `context-lifecycle.v1.schema.json` |
| Directory version | `context/lifecycle/v1/` |
| Git tags | `context-lifecycle-v1.0.0` |
| GitHub releases | `v1.0.0` |

## Adding a New Version

When a breaking change to the context lifecycle specification is required:

1. Create a new directory: `context/lifecycle/v2/`
2. Copy and modify the schema, docs, examples, and fixtures.
3. Update `apiVersion` to `context.brotni.com/v2`.
4. Document the migration path from v1 to v2.
5. Tag the release: `context-lifecycle-v2.0.0`.

The v1 directory remains in place for backwards compatibility.

## Backwards Compatibility

Non-breaking additions to an existing version (new optional fields, new valid enum values) may be made within the same version directory. Update the schema minor version and add a changelog entry.
