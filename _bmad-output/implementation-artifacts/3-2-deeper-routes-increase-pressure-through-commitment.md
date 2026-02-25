# Story 3.2: Deeper routes increase oxygen pressure through travel commitment

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a player,
I want deeper routes to feel riskier without hidden oxygen math changes,
so that risk-reward decisions stay fair and predictable while oxygen depletion remains consistent.

## Acceptance Criteria

1. Oxygen drain while in `Exploring` state must use one configurable flat rate, independent of route depth or distance from base.
2. The flat depletion rate must live in shared config (`src/Shared/Config/Oxygen.lua`) with no hardcoded drain constants in `OxygenService`.
3. No distance-band, zone-tier, or depth multiplier logic may alter oxygen depletion rate for this story.
4. Deeper routes must still produce higher effective oxygen pressure through longer travel/return commitment, not through faster per-second drain.
5. The implementation must preserve per-player isolation and server authority for all oxygen calculations.

## Tasks / Subtasks

- [x] Task 1: Keep oxygen depletion as configurable flat rate (AC: #1, #2, #3)
  - [x] Subtask 1.1: Confirm `src/Shared/Config/Oxygen.lua` exposes the single source of truth drain value (`baseDrainRatePerSecond`).
  - [x] Subtask 1.2: Ensure `src/Server/Services/Oxygen/OxygenService.lua` uses only the configured flat rate during `Exploring`.
  - [x] Subtask 1.3: Remove or reject any depth-based drain modifier logic if introduced.
- [x] Task 2: Preserve readable risk via route commitment, not hidden rate scaling (AC: #4, #5)
  - [x] Subtask 2.1: Keep existing safe-zone/base transitions and oxygen refill behavior from Story 3.1.
  - [x] Subtask 2.2: Ensure updates continue exposing current oxygen and state so players can judge push-vs-return timing.
- [x] Task 3: Add deterministic tests that enforce flat-rate behavior (AC: #1, #3, #5)
  - [x] Subtask 3.1: Extend `src/Server/Services/Oxygen/OxygenService.spec.lua` to verify equal oxygen drain over equal `dt` at different distances from base while in `Exploring`.
  - [x] Subtask 3.2: Add regression checks ensuring per-player isolation and no client-authored oxygen math paths are introduced.

## Dev Notes

- Relevant architecture patterns and constraints:
  - Economy/progression state is server-authoritative; oxygen calculations remain server-only. [Source: `_bmad-output/project-context.md#Engine-Specific Rules`]
  - Keep balancing/tuning values in shared config, not service magic numbers. [Source: `_bmad-output/project-context.md#Code Organization Rules`]
  - Oxygen risk system belongs to `src/Server/Services/Oxygen` with UI in client controllers. [Source: `_bmad-output/game-architecture.md#System Location Mapping`]
  - Distance risk can rise through travel commitment and decision pressure; do not introduce hidden per-depth depletion multipliers in this story. [Source: `_bmad-output/gdd.md#Difficulty Curve`]
- Source tree components to touch:
  - `src/Shared/Config/Oxygen.lua`
  - `src/Server/Services/Oxygen/OxygenService.lua`
  - `src/Server/Services/Oxygen/OxygenService.spec.lua`
- Testing standards summary:
  - Prioritize deterministic unit coverage for flat-rate drain math.
  - Include regression proving drain does not vary with player depth/distance.

### Project Structure Notes

- Keep oxygen pressure logic in `src/Server/Services/Oxygen` and tunables in `src/Shared/Config`.
- No new top-level folders are needed for this story.

### References

- `_bmad-output/epics.md#Epic 3: Oxygen Risk System`
- `_bmad-output/gdd.md#Difficulty Curve`
- `_bmad-output/game-architecture.md#System Location Mapping`
- `_bmad-output/project-context.md#Critical Implementation Rules`
- `_bmad-output/implementation-artifacts/3-1-oxygen-drains-during-expeditions.md`

## Dev Agent Record

### Agent Model Used

gpt-5.3-codex

### Debug Log References

- Roblox Studio run-code assertion: oxygen drain equality across near/deep distances (`98 == 98`) passed.
- IDE diagnostics: no linter errors in modified oxygen service/spec files.

### Completion Notes List

- Story context revised to enforce configurable flat oxygen depletion independent of depth zones.
- Follow-up to Story 3.1 keeps existing safe-zone and server-authoritative behavior with no hidden depth multipliers.
- Ultimate context engine analysis completed - comprehensive developer guide created.
- Implemented `OxygenService:_getFlatExploringDrainRatePerSecond()` and switched exploring drain math to this validated flat configurable value.
- Added deterministic spec coverage proving equal drain regardless of depth/distance and per-player isolation behavior.
- Executed flat-rate assertion in Roblox Studio and confirmed expected output.
- Code review fixes applied: oxygen math assertions now target real `OxygenService` module logic.
- Code review fixes applied: invalid/non-positive `baseDrainRatePerSecond` now fails fast during service construction to avoid silent zero-drain behavior.

### File List

- _bmad-output/implementation-artifacts/3-2-deeper-routes-increase-pressure-through-commitment.md
- moonwalk-for-brainrots/src/Server/Services/Oxygen/OxygenService.lua
- moonwalk-for-brainrots/src/Server/Services/Oxygen/OxygenService.spec.lua
- _bmad-output/implementation-artifacts/sprint-status.yaml

## Change Log

- 2026-02-25: Implemented Story 3.2 with flat configurable oxygen drain guardrail and deterministic flat-rate regression checks; moved story to review.
- 2026-02-25: Addressed code review findings by hardening drain-rate config validation and coupling specs to real `OxygenService` implementation; moved story to done.

## Senior Developer Review (AI)

### Reviewer

- Ivan (AI-assisted) on 2026-02-25

### Findings Addressed

- Replaced standalone spec helper assertions with direct checks against `OxygenService.computeNextOxygen` so tests validate real implementation logic.
- Added fail-fast validation for `baseDrainRatePerSecond` in `OxygenService.new` to prevent silent zero-drain runs on invalid config.
- Retained flat-rate guardrail (`_getFlatExploringDrainRatePerSecond`) while ensuring deterministic oxygen math remains centralized in service logic.

### Review Outcome

- Approved after fixes.
