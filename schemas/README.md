# Schemas

This directory is a top-level pointer to the JSON Schema definitions in this repository.

## Available Schemas

| Schema | Version | Path |
|--------|---------|------|
| `SimulationContext` | v1 | [context/lifecycle/v1/schema/context-lifecycle.v1.schema.json](../context/lifecycle/v1/schema/context-lifecycle.v1.schema.json) |

## Validation

To validate a context YAML file against the `SimulationContext` v1 schema:

```bash
./scripts/validate-contexts.sh
```

## Schema Versioning

Schemas are versioned via:
- Filename suffix (e.g., `.v1.schema.json`)
- Directory version (e.g., `context/lifecycle/v1/`)
- `apiVersion` field in context YAML files

See [docs/context-versioning.md](../docs/context-versioning.md).
