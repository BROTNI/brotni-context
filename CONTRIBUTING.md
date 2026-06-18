# Contributing to brotni-context

Thank you for your interest in contributing to the Brotni Context specification.

## What This Repository Accepts

This is a public specification repository. Contributions should focus on:

- New context lifecycle modes
- Extensions to existing lifecycle stages
- Improved examples and fixtures
- Documentation improvements
- Schema corrections or enhancements
- Validation tooling improvements

This repository does **not** accept contributions that include:
- Proprietary Brotni platform implementation code
- Private control plane logic
- Customer data or production secrets
- Cloud-provider-specific implementation details that would make the spec non-neutral

## How to Contribute

1. **Open an issue first** for any significant new mode or lifecycle extension. Describe the use case, why existing modes do not cover it, and any known trade-offs.

2. **Fork and branch**: Work in a feature branch named descriptively (e.g., `add-queue-hydration-mode`).

3. **Follow the spec structure**: New modes should include:
   - A mode entry in `context/lifecycle/v1/docs/modes.md`
   - An example YAML in `context/lifecycle/v1/examples/<mode-name>/context.yaml`
   - Valid fixtures in `context/lifecycle/v1/tests/fixtures/valid/`
   - At least one invalid fixture in `context/lifecycle/v1/tests/fixtures/invalid/`
   - Schema updates in `context/lifecycle/v1/schema/context-lifecycle.v1.schema.json`

4. **Validate**: Run `./scripts/validate-contexts.sh` and ensure all valid fixtures pass and all invalid fixtures fail.

5. **Submit a pull request**: Reference the related issue. Include a clear description of the new mode, its intended use cases, and any fairness or reproducibility considerations.

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).

## Versioning

New lifecycle extensions that are backwards-compatible may be added to `context/lifecycle/v1`. Breaking changes require a new version directory (e.g., `context/lifecycle/v2`).

See [docs/context-versioning.md](docs/context-versioning.md) for full versioning guidance.

## License

All contributions are licensed under Apache License 2.0. By submitting a contribution, you agree to license your contribution under these terms.
