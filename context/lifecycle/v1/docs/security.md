# Security

Simulation contexts handle potentially sensitive inputs: datasets, configuration, database snapshots, and credentials. This document describes the security model for Brotni context definitions.

## Secret Handling

Secrets must never be embedded directly in `SimulationContext` YAML files. Use `secretPolicy: external-reference-only` or `secretPolicy: vault-injected`.

- `external-reference-only`: Secrets are referenced by name or URI; the runtime injects them at evaluation time.
- `vault-injected`: A secrets manager (e.g., HashiCorp Vault, AWS Secrets Manager) injects secrets at runtime.
- `none`: No secrets are required. Use only when the context is fully public.

## Outbound Network Controls

Set `security.allowOutboundNetwork: false` for all production simulation contexts unless outbound calls are explicitly required and audited. Unrestricted outbound network access:
- Introduces non-determinism
- May leak simulation data
- Creates security exposure in multi-tenant environments

## Dependency Mocking

Use `isolation.externalDependencies: mocked` to replace all external dependencies with controlled mocks. This:
- Prevents sensitive data from being sent to external services
- Ensures reproducible dependency behavior
- Reduces security surface area

## Environment Isolation

Contexts must ensure:
- Candidates cannot read each other's state
- Candidates cannot modify shared infrastructure
- Candidates cannot escalate privileges beyond the defined runtime environment

## Dataset Sensitivity

Dataset references should include a `dataClassification` label in the security block if the data contains sensitive content. Recommended values: `public`, `internal`, `confidential`, `restricted`.

Do not use datasets classified as `restricted` in contexts that run untrusted candidates.

## Auditability

All production contexts should set:
- `reproducibility.recordContextDigest: true`
- `reproducibility.recordDatasetDigests: true`
- `discard.retainForAudit: true` (for regulated workloads)

This ensures a full audit trail from simulation campaign to context definition to dataset to candidate result.
