# Context Modes

A context mode defines the high-level strategy for how a simulation context is prepared, shared, and reset across candidate runs.

## `clean`

Each run starts from a newly prepared context.

**Lifecycle**: prepare → hydrate → run → collect → discard (repeat per candidate)

**Use when**:
- Fairness is more important than speed
- State must never be reused between candidates
- The environment is cheap to create
- Test contamination risk is high

**Trade-offs**: Slower than snapshot-clone; ensures maximum isolation.

## `snapshot-clone` *(Recommended default)*

A baseline context is prepared and hydrated once, snapshotted, then cloned for multiple candidate runs.

**Lifecycle**: prepare → hydrate → warmup → snapshot → (clone → run → collect → reset) × N → recycle/discard

**Use when**:
- Many candidates must be compared under identical conditions
- Context preparation is expensive
- Both reproducibility and speed matter

**Trade-offs**: Requires snapshot support in the runtime. If the snapshot becomes stale, all candidate comparisons may be invalid. Use `recycle.invalidateOn` to manage this.

This is the **recommended default** for most multi-candidate simulation campaigns.

## `warm-cache`

The context includes a controlled warmup phase before candidate evaluation.

**Lifecycle**: prepare → hydrate → warmup → run → collect → reset

**Use when**:
- Cache state affects behavior or performance
- Warm vs cold performance must be measured deliberately
- Fairness requires the same warmup policy for all candidates

**Trade-offs**: Warmup adds latency. The warmup strategy must be carefully specified to ensure all candidates see equivalent warm state.

## `stateful-replay` *(Advanced)*

The context evolves across a replay or scenario timeline. The context state changes as replay events are applied.

**Lifecycle**: prepare → hydrate → (replay-step → run → collect) × N → reset → discard

**Use when**:
- Long-running state transitions matter
- Candidates must be evaluated across sequential events
- Historical replay or operational timeline simulation is required

**Trade-offs**: This mode can be easier to contaminate or misinterpret. Use with care. Ensure that state isolation between candidates is explicitly defined. Mark this mode as advanced in your simulation campaign documentation.

## Future Modes

This specification is designed to accommodate future modes. Candidates for future addition include:

- `database-restore`
- `queue-hydration`
- `traffic-replay-context`
- `feature-flag-context`
- `mocked-dependencies-context`

To propose a new mode, open an issue and follow the contribution guide in [CONTRIBUTING.md](../../../../CONTRIBUTING.md).
