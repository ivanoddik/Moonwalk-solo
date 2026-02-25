# Story 3.3: Oxygen depletion causes a clear fail state

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a player,
I want oxygen depletion to trigger a clear fail state,
so that risk consequences are understandable and I can quickly learn and retry.

## Acceptance Criteria

1. When a player's oxygen reaches zero while in `Exploring`, the server must transition that player into a fail-state flow (depleted/run failed) and enforce failure consequences server-authoritatively.
2. The fail-state flow must be deterministic and per-player isolated; one player's depletion must not affect other players' run states.
3. Fail-state signaling must be explicit to the client (state and reason), enabling clear UX feedback that the run failed due to oxygen depletion.
4. Run failure must resolve carried run value according to fail rules (for MVP: carried value is lost on oxygen-fail unless design config says otherwise).
5. The implementation must avoid hidden depth-based oxygen math; depletion cause remains flat-rate drain plus player decisions.
6. Existing safe-zone behavior and post-failure recovery hooks for the next story (quick respawn) must remain compatible.

## Tasks / Subtasks

- [ ] Task 1: Add explicit oxygen-depleted fail-state handling on server (AC: #1, #2, #6)
  - [ ] Subtask 1.1: Extend `src/Server/Services/Oxygen/OxygenService.lua` with an explicit depleted/fail-state transition (not just passive damage ticks).
  - [ ] Subtask 1.2: Ensure transition is idempotent and isolated per `UserId` to prevent duplicate fail handling.
  - [ ] Subtask 1.3: Keep current base/exploring transitions intact and compatible with future respawn story.
- [ ] Task 2: Wire fail-state to run/economy consequence boundary (AC: #1, #4)
  - [ ] Subtask 2.1: Integrate with session/run-state owner (or temporary in-service contract) to mark run as failed when oxygen-depleted.
  - [ ] Subtask 2.2: Ensure carried run value is cleared/lost per fail rule and cannot be delivered after depletion.
- [ ] Task 3: Provide clear client-facing fail reason metadata (AC: #3, #5)
  - [ ] Subtask 3.1: Extend oxygen update or fail event payload to include explicit fail reason (`oxygen_depleted`) and fail-state flag.
  - [ ] Subtask 3.2: Update client oxygen/controller feedback path to distinguish warning urgency from confirmed run failure messaging.
- [ ] Task 4: Add deterministic tests for fail-state behavior (AC: #1, #2, #3, #4, #5)
  - [ ] Subtask 4.1: Add unit coverage proving oxygen-zero triggers exactly one fail transition per run.
  - [ ] Subtask 4.2: Add regression checks proving player isolation and that fail-state blocks reward resolution paths.
  - [ ] Subtask 4.3: Add tests validating no depth multiplier is required for fail trigger logic.

## Dev Notes

- Relevant architecture patterns and constraints:
  - Oxygen and progression outcomes are server-authoritative; client receives state only. [Source: `_bmad-output/project-context.md#Engine-Specific Rules`]
  - Use explicit run lifecycle transitions rather than implicit boolean webs. [Source: `_bmad-output/project-context.md#Engine-Specific Rules`]
  - Keep balancing/fail rules in shared config modules; no service magic numbers for rule toggles. [Source: `_bmad-output/project-context.md#Code Organization Rules`]
  - Oxygen system resides in `src/Server/Services/Oxygen` with client feedback in controllers. [Source: `_bmad-output/game-architecture.md#System Location Mapping`]
- Previous story intelligence (3.1 + 3.2):
  - `OxygenService` already enforces flat configurable drain and safe-zone transitions.
  - Service now fails fast if `baseDrainRatePerSecond` is invalid/non-positive.
  - Existing tests include deterministic oxygen math and flat-rate guardrail checks; extend these with fail-state assertions.
- Source tree components to touch:
  - `src/Server/Services/Oxygen/OxygenService.lua`
  - `src/Server/Services/Oxygen/OxygenService.spec.lua`
  - `src/Client/Controllers/OxygenController.lua` (or fail-feedback controller path in use)
  - `src/Shared/Constants/EventNames.lua` (if new fail-state event key is introduced)
  - `src/Shared/Config/Oxygen.lua` (if fail-rule toggles are parameterized)
- Testing standards summary:
  - Prefer deterministic unit tests around state transitions and side effects.
  - Verify isolation across multiple players and ensure depleted runs cannot accidentally resolve delivery rewards.

### Project Structure Notes

- Keep fail-state authority in server services; clients should only render state/reason.
- Avoid introducing new top-level folders; extend existing Oxygen domain modules.

### References

- `_bmad-output/epics.md#Epic 3: Oxygen Risk System`
- `_bmad-output/gdd.md#Win/Loss Conditions`
- `_bmad-output/game-architecture.md#System Location Mapping`
- `_bmad-output/project-context.md#Critical Implementation Rules`
- `_bmad-output/implementation-artifacts/3-1-oxygen-drains-during-expeditions.md`
- `_bmad-output/implementation-artifacts/3-2-deeper-routes-increase-pressure-through-commitment.md`

## Dev Agent Record

### Agent Model Used

gpt-5.3-codex

### Debug Log References

### Completion Notes List

- Story context prepared for explicit oxygen-depletion fail-state implementation with server-authoritative transitions.
- Story sequencing aligns with prior oxygen drain and pressure-commitment work while preserving flat drain behavior.
- Ultimate context engine analysis completed - comprehensive developer guide created.

### File List

- _bmad-output/implementation-artifacts/3-3-oxygen-depletion-causes-fail-state.md
