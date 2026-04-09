# Harness Artifacts

## Planner brief template

Use this when the user prompt is short and the harness needs a richer spec before building.

```md
# Planner Brief

## Goal
- What is the product or feature?
- What problem should it solve for the user?

## User and workflow
- Who is the primary user?
- What are the top 3 to 5 workflows that must feel complete?

## Scope
- Must-have capabilities
- Nice-to-have capabilities
- Non-goals for this run

## Quality bars
- Core interactions that must be truly functional
- UX, reliability, and performance expectations
- Any explicit latency or correctness thresholds

## Technical direction
- Preferred stack or infrastructure constraints
- Strong boundaries to preserve
- Areas where the builder should decide details itself

## Agentic opportunities
- Where should the product expose tools or automation to its own user-facing agent?
```

## Sprint contract template

Use this only when the model needs chunking to stay coherent.

```md
# Sprint Contract

## Sprint name
- Short label for this chunk

## Scope
- What this sprint will implement
- What it explicitly will not implement

## Deliverables
- Files, services, routes, views, or features expected to exist after the sprint

## Runtime behaviors to verify
- Behavior 1
- Behavior 2
- Behavior 3

## Pass criteria
- Clear, testable statements
- Prefer user-visible outcomes over implementation trivia

## Evidence the evaluator should inspect
- UI flows
- API endpoints
- database state
- logs or traces

## Known risks
- Likely failure modes or edge cases to probe
```

## Evaluator rubric template

Use explicit criteria with thresholds instead of vague "looks good" instructions.

```md
# Evaluator Rubric

## Product depth
- Does the implementation cover the promised workflows?
- Are major features real, not display-only?

## Functional correctness
- Do core paths complete successfully through the UI and APIs?
- Are errors surfaced clearly?

## Design and usability
- Is the interface coherent, navigable, and proportioned well?
- Are key workflows discoverable?

## Code and operational quality
- Do tests, lint, and startup checks pass?
- Are logs, metrics, and traces usable for debugging?

## Thresholds
- Any single criterion below the bar fails the round
- Feedback must name the failing behavior, where it was observed, and what evidence supports it
```

## Doc-gardening checklist

Run this periodically to keep repository knowledge trustworthy.

- remove or fix docs that no longer match code behavior
- verify indexes and cross-links still point to real files
- move ad-hoc tribal knowledge into versioned docs
- refresh quality scores and technical debt trackers
- convert recurring review comments into durable rules or templates

## Subagent controller packet template

Use this when the harness already has a plan and a controller is dispatching one fresh subagent per task.

```md
# Implementer Packet

## Task
- Paste the full task text exactly as written in the implementation plan

## Why this task exists
- Short explanation of how it fits the broader feature or sprint

## Relevant context
- Files, modules, or docs the implementer should read first
- Constraints, invariants, or non-goals

## Expected output
- Concrete code, tests, docs, or commands that should exist when done

## Verification
- Commands the implementer must run
- Required evidence to report back

## Review gate reminder
- Spec compliance review happens before code quality review
- If either reviewer finds issues, fix them and rerun that review
```

## Two-stage review loop

Use this when following the `$subagent-driven-development` pattern.

```md
# Review Loop

1. Implementer completes task, runs tests, and self-reviews
2. Spec reviewer checks only whether the implementation matches the written plan
3. Implementer fixes any spec gaps or removes unrequested extras
4. Code quality reviewer checks maintainability, correctness, and fit with local patterns
5. Implementer fixes quality issues
6. Repeat each review until it passes cleanly
```

## When to prefer controller-led subagents

- the plan is already written
- tasks are independent or mostly independent
- each task can be scoped with a tight packet
- long-lived agents tend to drift or accumulate noisy context

## When not to prefer controller-led subagents

- the plan is missing or unstable
- tasks are tightly coupled and need constant cross-task tradeoffs
- the work is mostly architecture and discovery rather than implementation

## Golden principles examples

These are good candidates for mechanical enforcement:

- validate data at boundaries instead of probing guessed shapes
- prefer shared utilities over scattered one-off helpers
- keep architecture layers directional and explicit
- require structured logging in production paths
- keep modules small enough for an agent to hold in context
