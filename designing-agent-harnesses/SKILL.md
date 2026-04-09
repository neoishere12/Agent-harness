---
name: designing-agent-harnesses
description: Use when designing, refining, or debugging long-running coding-agent harnesses for software work, especially when agents drift on multi-hour tasks, under-scope from short prompts, miss last-mile behavior, or need better planning, observability, repository context, and mechanical guardrails.
---

# Designing Agent Harnesses

## Overview

Harnesses are not just prompts. They are the environment, artifacts, tools, and feedback loops that let agents stay coherent on long-running engineering work.

Optimize for human attention. Humans should steer, encode invariants, and remove bottlenecks while agents execute inside a legible, testable system.

## When to Use

- building or revising a harness for long-running coding tasks
- deciding whether to add a planner, sprints, evaluator, or context resets
- short prompts produce under-scoped builds
- outputs look polished but core behaviors are stubbed or broken
- runs lose coherence as context grows
- repository docs are stale, monolithic, or hard for agents to navigate
- human QA, review, or cleanup is becoming the bottleneck

Do not use this skill for one-off prompt polish or small tasks that a single agent can already handle reliably.

## Workflow

### 1. Baseline before adding scaffolding

Start with the simplest harness that can succeed on a realistic task. Add only components that fix an observed failure mode.

Preferred order:

1. Single agent with good repository context
2. Add a planner if the build under-scopes or needs better product framing
3. Add an evaluator if the output looks good but misses real behaviors
4. Add sprints or contracts only if the model cannot stay coherent across the full task
5. Add context resets only if compaction is not enough and the model shows context anxiety

Re-test after model upgrades. A harness component is justified only while it is load-bearing.

### 2. Choose the control structure

Use a small number of roles with crisp responsibilities.

- `Planner`: expand a short request into an ambitious product-level spec; avoid freezing brittle implementation details too early
- `Builder` or `Generator`: implement the product, self-check, and produce artifacts the next phase can inspect
- `Evaluator` or `QA`: interact with the running system, grade against explicit criteria, and return actionable defects

Use evaluator thresholds when quality matters. Treat the evaluator as optional overhead unless the task sits beyond what the current model can reliably do solo.

If you need finer decomposition, negotiate explicit sprint contracts before code is written. Each contract should define:

- scope for the chunk
- concrete behaviors to test
- pass/fail criteria
- artifacts the next phase will inspect

For starter templates, read [harness-artifacts.md](references/harness-artifacts.md).

### 2a. Use subagent-driven development for plan execution

When you already have a written implementation plan and most tasks are independent, prefer controller-style execution with fresh subagents per task instead of one long-lived implementer.

This pairs especially well with the superpowers skill `$subagent-driven-development`.

Use the controller to:

- extract the full task text and scene-setting context
- dispatch one fresh implementer subagent for the current task
- answer clarification questions before work proceeds
- require the implementer to self-test and self-review
- run two review gates after implementation: spec compliance first, then code quality
- loop fixes back to the same implementer until both reviews are clean

This pattern helps when long-running work suffers from context pollution, unclear task boundaries, or silent divergence from the written plan.

Do not use this pattern when tasks are tightly coupled, the plan is incomplete, or the work needs live architectural judgment across the whole codebase at once.

For controller packet and review-loop templates, read [harness-artifacts.md](references/harness-artifacts.md).

### 3. Make the repository the system of record

Keep `AGENTS.md` short and map-like. Put durable knowledge in versioned docs that agents can discover progressively.

Recommended categories:

- architecture and layer rules
- product specs and design docs
- active and completed execution plans
- generated reference material such as schemas
- quality scores and tech debt trackers
- engineering norms such as reliability and security

A good repository gives the agent a map, not a 1,000-page manual. Cross-link docs and validate freshness in CI. If you want a sample layout, read [repository-layout.md](references/repository-layout.md).

### 4. Make the application legible

Expose the system so agents can inspect it directly instead of relying on human copy/paste.

Prioritize:

- per-worktree app bootability
- browser or UI inspection via DOM snapshots, screenshots, and navigation
- logs, metrics, and traces that can be queried
- isolated local environments so an agent can test, restart, and compare runs safely

Phrase goals as measurable checks, not vague hopes. Good examples are latency budgets, startup thresholds, and named user journeys with explicit pass criteria.

### 5. Enforce invariants mechanically

Agents move fastest inside rigid boundaries with local freedom.

Encode:

- architectural dependency rules
- schema validation at boundaries
- structured logging requirements
- naming conventions
- file or module size limits
- platform reliability rules
- test and lint gates with remediation-oriented error messages

Prefer custom lint or structural-test messages that teach the agent how to fix the violation.

### 6. Close the loop around human bottlenecks

Treat every repeated human review step as a candidate for better scaffolding.

Examples:

- evaluator criteria for last-mile completeness
- recurring doc-gardening to fix stale docs
- cleanup agents for golden principles
- PR review loops where agents gather comments, revise, and rerun checks
- quality scorecards that show where the harness is still leaking effort

Corrective work should update the system of record, tooling, or invariants, not just patch one failing task.

### 7. Keep the merge philosophy aligned with throughput

High-throughput agent systems make waiting expensive. Favor short-lived changes, fast feedback, and follow-up fixes over long blocking queues.

This only works when boundaries, tests, and cleanup loops are strong. Relaxing merge friction without mechanical safeguards creates drift.

## Quick Decisions

| Signal | Add or change | Why |
| --- | --- | --- |
| Short prompt leads to a thin or under-ambitious build | Add a `Planner` | Expands intent into a richer spec before implementation starts |
| You already have a plan and tasks are mostly independent | Use controller-led subagents plus two-stage review | Fresh context per task reduces drift and catches spec misses before quality polish |
| Agent loses coherence over time | Add sprint contracts, then context resets only if needed | Smaller agreements and fresh context reduce drift |
| App looks good but core interactions fail | Add an `Evaluator` with explicit criteria and runtime access | Last-mile defects need direct inspection and grading |
| Docs are huge, stale, or contradictory | Shrink `AGENTS.md` and move durable knowledge into structured docs | Agents need a map and progressive disclosure, not a monolith |
| Humans spend time reproducing issues manually | Improve UI and observability legibility | Agents can debug directly when they can inspect the live system |
| A newer model handles more on its own | Remove scaffolding and re-benchmark | Harness complexity goes stale as model capability moves |

## Common Mistakes

- encoding every preference in one giant instruction file
- specifying brittle low-level implementation details too early
- using a single long-lived implementer when a controller plus fresh task subagents would stay cleaner
- keeping evaluator steps after they stop adding lift
- measuring token cost but not human attention
- letting cleanup remain a manual chore instead of a recurring background process

## References

- For the combined article takeaways, read [source-synthesis.md](references/source-synthesis.md).
- For practical templates, read [harness-artifacts.md](references/harness-artifacts.md).
- For a repository layout patterned after the articles, read [repository-layout.md](references/repository-layout.md).
