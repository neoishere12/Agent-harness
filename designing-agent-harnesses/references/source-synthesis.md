# Source Synthesis

## Sources

- OpenAI, "Harness engineering: leveraging Codex in an agent-first world" (February 11, 2026)
  - <https://openai.com/index/harness-engineering/>
- Anthropic, "Harness design for long-running application development" (March 24, 2026)
  - <https://www.anthropic.com/engineering/harness-design-long-running-apps>

## OpenAI takeaways

### Optimize for human time, not raw code output

The central shift is that humans stop spending most of their time writing code and instead spend it designing the environment that makes agent execution reliable. The scarcest resource becomes human attention, so the harness should absorb repeated review, QA, and cleanup work whenever possible.

### Make the repository a real knowledge system

Keep `AGENTS.md` short and stable. Use it as an entry point, not as the whole manual.

Move durable knowledge into versioned docs such as:

- design docs
- product specs
- active and completed execution plans
- generated technical references
- reliability and security guides
- quality scorecards and tech debt trackers

This lets agents discover context progressively instead of being flooded up front.

### Increase agent legibility of the running system

Agents become much more useful when they can inspect the application directly:

- boot one app instance per worktree
- inspect DOM snapshots and screenshots
- reproduce UI behavior themselves
- query logs, metrics, and traces

This turns prompts like "keep startup under 800ms" into tractable tasks because the harness exposes the signals needed to verify the goal.

### Enforce boundaries mechanically

Use custom lint rules, structural tests, schema validation, and explicit architecture layers to keep a fully agent-written codebase coherent. Good harnesses enforce invariants centrally and allow local implementation freedom inside those boundaries.

### Treat cleanup as continuous garbage collection

Agent-generated code tends to replicate patterns, including weak ones. Encode golden principles into docs and tooling, then run recurring cleanup work so technical debt is paid down continuously instead of in painful bursts.

## Anthropic takeaways

### Start with observed failures, then add structure

Harness parts should solve real failure modes, not imagined ones. Baseline the simplest workable system first, then add load-bearing components one at a time.

### Use distinct roles only when they add lift

The article converges on three useful roles:

- `Planner` for expanding short prompts into richer product specs
- `Generator` for implementation
- `Evaluator` for runtime inspection and grading

The planner prevents under-scoping. The evaluator catches the gap between a polished demo and a genuinely usable product.

### Use contracts to bridge intent and testing

When the build is broken into sprints, the generator and evaluator should agree on what "done" means before implementation starts. A contract translates high-level product intent into testable behaviors without locking in every implementation detail too early.

### Evaluators are boundary-dependent

An evaluator is not permanently required. It earns its keep when the task sits just beyond what the current model can do reliably solo. As models improve, the same evaluator can become unnecessary overhead.

### Revisit the harness after every model jump

The harness should get simpler when models can absorb more of the task directly. Remove stale scaffolding first, then look for new combinations that unlock higher-value work.

## Combined operating principles

### 1. Start simple, then earn complexity

Use the fewest moving parts that solve the task. Complexity is justified only by a repeated, observed failure mode.

### 2. Give agents a map, not a monolith

Small, stable entry points plus structured docs beat giant instruction blobs.

### 3. Make truth inspectable

Agents do better when they can inspect the live UI, logs, metrics, traces, and artifacts directly.

### 4. Convert taste into criteria

Whether the task is UI quality or feature completeness, define concrete criteria and thresholds so an evaluator can judge outputs consistently.

### 5. Encode judgment into systems

Review comments, cleanup insights, and recurring defects should turn into docs, tooling, lints, or templates so the next run starts from a better baseline.

### 6. Re-benchmark aggressively

Every new model release is a reason to remove harness weight and verify what still matters.
