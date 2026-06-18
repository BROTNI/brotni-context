# Security Model

This document describes the security model for Brotni context definitions.

## Secret Handling

Secrets must **never** be embedded directly in `SimulationContext` YAML files. This includes API keys, database passwords, certificates, and tokens.

Use `secretPolicy` to declare how secrets are handled:

| Policy | Description |
|--------|-------------|
| `external-reference-only` | Secrets are referenced by name or URI; the runtime injects them at evaluation time. **Recommended.** |
| `vault-injected` | A secrets manager (e.g., HashiCorp Vault, AWS Secrets Manager) injects secrets at runtime. |
| `none` | No secrets required. Use only when the context is fully public and stateless. |

## Outbound Network Controls

Set `security.allowOutboundNetwork: false` for all production simulation contexts. This:

- Prevents candidates from making non-deterministic external calls
- Prevents data exfiltration from simulation environments
- Reduces security exposure in multi-tenant environments

Only allow outbound network when explicitly required and audited.

## Dependency Mocking

Use `isolation.externalDependencies: mocked` to replace all external dependencies with controlled mocks. This:

- Prevents sensitive data from being sent to external services
- Ensures reproducible dependency behavior
- Reduces security surface area

Use `isolation.externalDependencies: blocked` to detect and fail on any unexpected external calls.

## Environment Isolation

Contexts must ensure:

- Candidates cannot read each other's state (use `clone.perCandidate: true`)
- Candidates cannot modify shared infrastructure (use `isolation.filesystem: copy-on-write` or `ephemeral`)
- Candidates cannot escalate privileges beyond the runtime environment definition

## Dataset Sensitivity

Use `security.dataClassification` to label dataset sensitivity:

| Classification | Description |
|---------------|-------------|
| `public` | No restrictions. |
| `internal` | Internal use only. |
| `confidential` | Restricted access. |
| `restricted` | Highest sensitivity. Do not use with untrusted candidates. |

## Auditability

For regulated workloads, set:

```yaml
reproducibility:
  recordContextDigest: true
  recordDatasetDigests: true

discard:
  retainForAudit: true
```

This ensures a full audit trail: simulation campaign → context definition → dataset digests → candidate result.

## What Context Files Must Not Contain

- Plaintext passwords, tokens, or API keys
- Customer PII or production data
- Private Brotni control plane endpoints
- Cloud provider credentials
- Internal network addresses or private hostnames
