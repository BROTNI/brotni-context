# Relation to Recipes

## What a Recipe Is

A **runtime recipe** describes how a candidate is built and executed. It covers:

- Build process and dependencies
- Runtime startup commands
- Health check configuration
- Expected input and output formats
- Resource requirements

A recipe is the candidate's perspective: "this is how I run."

## What a Context Is

A **context** describes the environment, state, data, and lifecycle rules that surround a candidate run. It covers:

- Runtime environment provisioning
- Dataset hydration
- Database and queue state
- Warmup procedures
- Isolation rules
- Reset and recycling policies

A context is the evaluation infrastructure's perspective: "this is what the candidate runs against."

## The Relationship

A recipe **consumes** context-provided inputs and **produces** outputs. The context defines what inputs are available and how they are prepared. The recipe defines how the candidate uses those inputs.

```
Context prepares: /brotni/data/events.ndjson
Recipe reads:     /brotni/data/events.ndjson
```

## What Context Must Not Do

A context must not duplicate recipe behavior:

- It must not define how the candidate builds or starts.
- It must not define candidate-specific health checks.
- It must not embed candidate logic or configuration.

If a field belongs to the candidate's execution model, it belongs in the recipe, not the context.
