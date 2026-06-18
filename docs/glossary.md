# Glossary

**apiVersion**
The version identifier for a context specification. Currently `context.brotni.com/v1`.

**candidate**
An implementation being evaluated in a simulation campaign.

**clone**
An isolated context instance derived from a snapshot or baseline. Each candidate receives its own clone.

**context**
The controlled environment and state against which a candidate is evaluated. See [concepts.md](concepts.md).

**context lifecycle**
The sequence of stages a simulation context passes through: prepare → hydrate → warmup → snapshot → clone → run → collect → reset → recycle → discard.

**context mode**
The high-level strategy for how a context is prepared and reused: `clean`, `snapshot-clone`, `warm-cache`, or `stateful-replay`.

**dataset reference**
A URI pointing to a versioned dataset (e.g., `dataset://routing/prod-replay/2026-05`).

**discard policy**
Rules for when a context and its resources are destroyed.

**hydrate**
The stage in which datasets, configuration, state, and mocks are loaded into the environment.

**isolation**
Rules controlling what a candidate can access or modify during a run.

**recipe**
A description of how a candidate is built and executed. Separate from context.

**recycle policy**
Rules for when a snapshot or prepared context may be reused across runs.

**reset policy**
Rules for how the context is restored after each candidate run.

**simulation campaign**
A structured evaluation effort in which candidates are compared under defined conditions.

**simulation spec**
A definition of what should be evaluated: KPIs, constraints, scoring intent, and datasets.

**snapshot**
A captured baseline state of a prepared and hydrated context.

**warmup**
An optional stage in which caches, models, or data paths are brought to a controlled warm state before candidate evaluation.
