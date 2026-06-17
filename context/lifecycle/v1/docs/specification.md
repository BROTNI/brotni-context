# SimulationContext Specification v1

**API Version**: `context.brotni.com/v1`
**Kind**: `SimulationContext`

This document is the normative specification for Brotni simulation context lifecycle v1.

## Scope

This specification defines:

- The structure of a `SimulationContext` YAML definition
- The required and optional lifecycle stages
- The supported context modes
- Isolation, reset, recycling, and discard policies
- Reproducibility and security requirements

## YAML Structure

A `SimulationContext` document must include:

| Field | Required | Description |
|-------|----------|-------------|
| `apiVersion` | Yes | Must be `context.brotni.com/v1` |
| `kind` | Yes | Must be `SimulationContext` |
| `metadata.name` | Yes | Unique name |
| `metadata.description` | No | Human-readable description |
| `mode` | Yes | One of: `clean`, `snapshot-clone`, `warm-cache`, `stateful-replay` |
| `environment` | No | Runtime environment definition |
| `datasets` | No | Dataset references |
| `inputs` | No | Configuration and feature flag references |
| `state` | No | Database, queue, and cache state |
| `warmup` | No | Warmup configuration |
| `snapshot` | No | Snapshot configuration |
| `clone` | No | Clone strategy |
| `isolation` | No | Isolation rules |
| `reset` | No | Reset policy |
| `recycle` | No | Recycle policy |
| `discard` | No | Discard policy |
| `limits` | No | Duration and age limits |
| `reproducibility` | No | Reproducibility recording options |
| `security` | No | Security policy |

## Conformance

A conforming `SimulationContext` must:

1. Pass validation against `context-lifecycle.v1.schema.json`.
2. Specify a valid `mode`.
3. Reference datasets by URI (e.g., `dataset://...`) rather than embedding data inline.
4. Not embed secrets directly; use `secretPolicy: external-reference-only` or `vault-injected`.
5. Define a `reset` policy when `mode` is `snapshot-clone` or `warm-cache`.

## Schema

The authoritative JSON Schema for this specification is at:

```
context/lifecycle/v1/schema/context-lifecycle.v1.schema.json
```

## Validation

```bash
./scripts/validate-contexts.sh
```
