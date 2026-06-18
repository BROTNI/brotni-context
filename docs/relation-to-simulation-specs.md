# Relation to Simulation Specs

## The Three Layers

```
Simulation Spec = what should be evaluated
Recipe          = how a candidate runs
Context         = where and under what state the candidate runs
```

These three layers are deliberately separate so they can evolve independently.

## What a Simulation Spec Defines

A **simulation spec** defines:

- Evaluation goals and KPIs
- Constraints and acceptance criteria
- Dataset and traffic sources to use
- Scoring intent and comparison methodology
- Which candidates to evaluate

## What a Context Defines

A **context** defines:

- How the environment is prepared (prepare stage)
- What data and state is loaded (hydrate stage)
- How the environment is warmed (warmup stage)
- How state is managed across runs (reset and recycle)
- What isolation rules apply
- How reproducibility is ensured

## What a Recipe Defines

A **recipe** defines:

- How a candidate is built
- How a candidate starts and runs
- What outputs a candidate produces

## Why They Are Separate

Keeping these layers separate allows:

- The same context to be used across multiple simulation specs
- The same spec to be run against multiple context configurations
- Recipes to be evaluated in contexts they were not originally designed for
- Each layer to be versioned and audited independently
