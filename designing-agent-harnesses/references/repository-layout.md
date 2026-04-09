# Repository Layout

## Goal

Give the agent a short entry point and a clear place to find durable knowledge. The repository should teach the harness where to look next.

## Suggested layout

```text
AGENTS.md
ARCHITECTURE.md
docs/
├── design-docs/
│   ├── index.md
│   └── ...
├── exec-plans/
│   ├── active/
│   ├── completed/
│   └── tech-debt-tracker.md
├── generated/
│   └── ...
├── product-specs/
│   ├── index.md
│   └── ...
├── references/
│   └── ...
├── DESIGN.md
├── FRONTEND.md
├── PLANS.md
├── PRODUCT_SENSE.md
├── QUALITY_SCORE.md
├── RELIABILITY.md
└── SECURITY.md
```

## What each area is for

- `AGENTS.md`
  - Short working map
  - Points to the deeper docs
  - Avoid putting the full manual here

- `ARCHITECTURE.md`
  - Top-level domain and layering map
  - Dependency rules and architectural intent

- `docs/design-docs/`
  - Design principles, core beliefs, and major decisions

- `docs/exec-plans/active/`
  - Work in flight
  - Progress logs, decisions, and checkpoints

- `docs/exec-plans/completed/`
  - Finished plans that future agents can mine for precedent

- `docs/generated/`
  - Machine-generated references such as schema snapshots or inventories

- `docs/product-specs/`
  - User-facing capability definitions and workflow expectations

- `QUALITY_SCORE.md`
  - Quality by domain or subsystem
  - Where the harness still needs reinforcement

- `RELIABILITY.md` and `SECURITY.md`
  - Non-negotiable operating rules
  - Good targets for mechanical checks

## Maintenance rules

- keep indexes current
- cross-link related docs
- validate structure in CI
- archive completed plans instead of deleting them
- record recurring defects where future agents can find them

## Good `AGENTS.md` behavior

A strong `AGENTS.md` should:

- stay small
- describe the repository map
- name the highest-signal docs
- highlight critical invariants
- avoid repeating content that belongs elsewhere
