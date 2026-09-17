<!--
Sync Impact Report
- Version change: 1.0.0 → 1.1.0 (materially expanded guidance)
- Modified principles: II. Simplicity & YAGNI — added self-explanatory-code / minimal-comments rule
- Added sections: none
- Removed sections: none
- Templates requiring updates: .specify/templates/spec-template.md (⚠ pending manual review),
  .specify/templates/constitution-template.md (✅ no change needed, source template)
- Follow-up TODOs: TODO(IOS_DEPLOYMENT_TARGET) — minimum iOS version not yet decided
-->

# LILOv2 Constitution

## Core Principles

### I. Spec-Driven Development (NON-NEGOTIABLE)
Every feature MUST pass through the Spec Kit pipeline before code is written: a spec
(`spec.md` — requirements, no implementation detail) MUST be approved, then a plan
(`plan.md` — technical approach), then tasks (`tasks.md` — ordered, executable steps).
Implementation MUST NOT begin from an idea alone. Ambiguities in a spec MUST be resolved
(`/speckit-clarify`) before planning starts, not discovered mid-implementation.
Rationale: this project explicitly adopts spec-driven development so that intent is
captured and reviewable before code exists, reducing rework and drift between what was
asked for and what was built. Trivial fixes/chores that don't change product behavior are
exempt.

### II. Simplicity & YAGNI
Implement only what the current spec requires. MUST NOT introduce abstractions, layers, or
configuration for hypothetical future needs. Prefer the smallest change that satisfies the
spec's acceptance criteria; three similar call sites are better than a premature shared
abstraction. Code MUST be self-explanatory through clear naming and structure; comments are
NOT added by default. A comment MAY be added only to capture a non-obvious "why" — a hidden
constraint, a workaround, an invariant that isn't visible from the code itself — never to
restate what the code already says.
Rationale: this is an early-stage SwiftUI app — speculative architecture costs more than it
saves before real requirements exist. Self-explanatory code stays correct as it's refactored;
comments describing "what" silently rot and mislead once the code around them changes.

### III. SwiftUI Architecture Consistency
Views MUST stay declarative and free of business logic beyond simple presentation mapping;
state and side effects live in dedicated observable model types (Swift's `@Observable` /
`@State` data-flow model). A feature's `plan.md` MUST name where its state lives before
implementation starts. Mixing ad-hoc state patterns (e.g., singletons, notification-based
state) within the same feature MUST be justified in `plan.md` or avoided.
Rationale: keeps the codebase navigable as features accumulate and keeps SwiftUI previews
and tests reliable.

### IV. Test-Before-Done
Each feature MUST have tests covering its spec's acceptance criteria (unit tests for logic,
UI tests only where interaction behavior is the point) before the feature is marked done in
`tasks.md`. Strict red-green-refactor TDD is encouraged but not mandatory — tests MUST exist
and pass by completion, not necessarily be written first.
Rationale: balances the rigor of test coverage against solo/small-team velocity at this
project stage; can be tightened to strict TDD via amendment if the team grows.

### V. Versioning & Change Tracking
App version numbers follow semantic versioning and MUST align with TestFlight build
numbers. Any change to a persisted data model or schema MUST document a migration path in
that feature's `plan.md`. Breaking changes to shared internal contracts MUST be called out
explicitly in the relevant spec.
Rationale: this repository is a working/experimental line separate from the build actually
submitted to TestFlight, so version and migration intent must stay traceable and
unambiguous across lines of work.

## Technology & Platform Constraints

- Platform: SwiftUI app built with Xcode (project `v2`, product line `LILOv2`).
- Minimum iOS deployment target: TODO(IOS_DEPLOYMENT_TARGET) — to be set before first
  TestFlight submission; until then, keep API usage compatible with the Xcode project's
  current deployment target setting.
- No new third-party dependency may be added without a stated reason in the introducing
  feature's `plan.md`.

## Development Workflow

- Command order: `/speckit-constitution` → `/speckit-specify` → `/speckit-clarify`
  (as needed) → `/speckit-plan` → `/speckit-tasks` → `/speckit-analyze` (as needed) →
  `/speckit-implement`.
- One feature branch per spec, named `feat/<feature-slug>`, matching the spec's feature
  directory under `specs/`.
- `/speckit-analyze` SHOULD be run before `/speckit-implement` on any feature whose spec or
  plan changed after tasks were generated, to catch drift between artifacts.

## Governance

This constitution supersedes ad-hoc conventions for any conflict between them. Amendments
are made exclusively via `/speckit-constitution`, which MUST update the version per semantic
versioning (MAJOR: incompatible principle removal/redefinition; MINOR: new principle or
materially expanded guidance; PATCH: clarification/wording) and record the change in that
run's Sync Impact Report. Compliance is checked opportunistically via `/speckit-analyze`
during feature development; there is no separate standing review board at this project's
current size.

**Version**: 1.1.0 | **Ratified**: 2026-09-17 | **Last Amended**: 2026-09-17
