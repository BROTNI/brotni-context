# Concepts

## Simulation Context

A **simulation context** is the controlled environment and state against which one or more candidates are evaluated. It defines what the candidate runs against, not how the candidate runs.

A context may include runtime environment state, datasets, traffic replay inputs, database state, message queues, caches, feature flags, configuration snapshots, dependency mocks, service mesh state, generated test data, warmup state, isolation rules, and reset and recycling policies.

## Context Lifecycle

The **context lifecycle** is the sequence of stages that a simulation context passes through: prepare, hydrate, warmup, snapshot, clone, run, collect, reset, recycle, and discard.

Each stage has a defined purpose and sequencing contract. Not all stages are active for every context mode.

## Candidate

A **candidate** is an implementation being evaluated in a simulation campaign. Multiple candidates may be evaluated against the same simulation context (or equivalent context clones) so that their results can be compared fairly.

## Simulation Campaign

A **simulation campaign** is a structured evaluation effort in which one or more candidates are run against a defined context under the rules of a simulation spec. A campaign may evaluate many candidates and produce comparative results.

## Simulation Spec

A **simulation spec** defines what should be evaluated: the evaluation goals, KPIs, constraints, scoring intent, and the dataset or traffic sources to use. It does not describe how candidates run or how the environment is prepared.

## Runtime Recipe

A **runtime recipe** describes how a candidate is built and executed: its build process, runtime dependencies, startup commands, health checks, and expected output format. A recipe consumes context-provided inputs and produces outputs.

## Dataset Reference

A **dataset reference** is a URI (e.g., `dataset://routing/prod-replay/2026-05`) that points to a versioned dataset. Dataset references should include a digest to ensure reproducibility.

## Context Snapshot

A **context snapshot** is a captured baseline state of a prepared and hydrated context. It can be cloned multiple times to give each candidate an identical starting state.

## Context Clone

A **context clone** is an isolated instance of a context, derived from a snapshot or baseline. Each candidate receives its own clone to prevent state contamination between runs.

## Reset Policy

A **reset policy** defines how the context is restored after each candidate run. Common strategies include `restore-snapshot` (restore from baseline) and `drop-and-reprepare` (full teardown and rebuild).

## Recycle Policy

A **recycle policy** defines whether and how a prepared context or snapshot can be reused across multiple candidates or campaigns. It includes invalidation conditions that trigger re-preparation.

## Discard Policy

A **discard policy** defines when a context and its associated resources are destroyed. It may include an option to retain context metadata for audit purposes.
