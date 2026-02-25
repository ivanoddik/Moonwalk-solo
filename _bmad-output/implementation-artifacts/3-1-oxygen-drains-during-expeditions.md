# Story 3.1: Oxygen drains during expeditions

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a player,
I want oxygen to drain during expeditions,
so that risk is always present and I must manage my time outside the base.

## Acceptance Criteria

1. The server must authoritatively track and drain a player's oxygen level while they are outside the base safe zone.
2. Oxygen drain should be a configurable rate (e.g., amount per second).
3. The client must receive regular or event-driven updates of the current oxygen level to display on the HUD.
4. Players inside the base safe zone should not lose oxygen (and may optionally regenerate it, though recovery might be handled in a later story).
5. Oxygen state must be isolated per player and managed by a dedicated `OxygenService`.

## Tasks / Subtasks

- [x] Task 1: Create Server-Side Oxygen Service (AC: #1, #2, #5)
  - [x] Subtask 1.1: Create `src/Server/Services/Oxygen/OxygenService.lua`.
  - [x] Subtask 1.2: Implement a tracking loop or tick system that deducts oxygen for players currently in an "Exploring" state.
  - [x] Subtask 1.3: Add oxygen configuration to `src/Shared/Config/Gameplay.lua` or a dedicated `Oxygen.lua` config (e.g., max oxygen, drain rate).
- [x] Task 2: Define Safe Zone / State Transition (AC: #1, #4)
  - [x] Subtask 2.1: Integrate with or establish a `RunStateMachine` or simple state tracker to know if a player is at the base vs exploring.
  - [x] Subtask 2.2: Ensure oxygen only drains when the player is in the exploring state.
- [x] Task 3: Client Synchronization (AC: #3)
  - [x] Subtask 3.1: Create a remote event `OxygenUpdateRemote` in `src/Shared/Constants/EventNames.lua`.
  - [x] Subtask 3.2: Have `OxygenService` fire the remote to update the client when oxygen changes.
  - [x] Subtask 3.3: Create a basic `OxygenController.lua` on the client to listen for updates and print/display the current level.

## Dev Notes

- **Relevant architecture patterns and constraints:** 
  - "Treat all economy/progression state (currency, oxygen outcomes, rebirth, entitlements) as server-authoritative only." (Project Context)
  - "Keep balance numbers in shared config modules; avoid hardcoded values inside runtime service logic." (Project Context)
  - "Prefer event-driven updates over polling-heavy loops on both client and server." (Project Context) - For oxygen, a server tick is fine, but only send updates to the client periodically or when significant changes occur to avoid network spam.
- **Source tree components to touch:**
  - `src/Server/Services/Oxygen/OxygenService.lua`
  - `src/Shared/Config/Oxygen.lua`
  - `src/Shared/Constants/EventNames.lua`
  - `src/Client/Controllers/OxygenController.lua`
  - `src/Server/Bootstrap/ServerMain.server.lua`
- **Testing standards summary:**
  - Unit tests should validate deterministic oxygen drain math.
- **Implementation note:** `OxygenService` constructor now expects `new(config, eventNames, updateRemote, baseAnchor)` so safe-zone references from `ServerMain` are correctly wired.

### Project Structure Notes

- Alignment with unified project structure: `OxygenService` goes in `src/Server/Services/Oxygen/`.
- No conflicts detected.

### References

- Epic breakdown: `_bmad-output/epics.md#Epic 3: Oxygen Risk System`
- Architecture rules: `_bmad-output/project-context.md#Engine-Specific Rules`

## Dev Agent Record

### Agent Model Used

gemini-3.1-pro-preview

### Debug Log References

### Completion Notes List

- Created `OxygenService` on the server to track and drain oxygen.
- Added `OxygenConfig` with `defaultMaxOxygen`, `baseDrainRatePerSecond`, `safeZoneRadius`, and tunables for update/damage/safe-zone boundary behavior.
- Added `OxygenUpdateRemote` to `EventNames` and `ServerMain`.
- Safe zone logic was updated to use `BasePad` as the reference region and check plane bounds on X/Z to determine "Base" vs "Exploring".
- Fixed constructor wiring so `OxygenService` correctly stores the safe-zone reference passed from `ServerMain` (`baseAnchor` argument), restoring proper state transitions.
- Oxygen only drains when "Exploring"; when oxygen reaches zero, players take 10% max-HP damage per second until death/respawn.
- Created `OxygenController` on the client to listen for updates and display a HUD label, including current run state for debugging.
- Wired `OxygenController` into `ClientMain.client.lua`.

Ultimate context engine analysis completed - comprehensive developer guide created for Epic 3 Story 1.

### File List
- src/Server/Services/Oxygen/OxygenService.lua (constructor updated to `new(config, eventNames, updateRemote, baseAnchor)`)
- src/Server/Services/Oxygen/OxygenService.spec.lua
- src/Shared/Config/Oxygen.lua
- src/Shared/Constants/EventNames.lua
- src/Client/Controllers/OxygenController.lua
- src/Server/Bootstrap/ServerMain.server.lua
- src/Client/Bootstrap/ClientMain.client.lua

## Senior Developer Review (AI)

### Reviewer
- Ivan (AI-assisted) on 2026-02-25

### Findings Addressed
- Fixed safe-zone reference fallback to prefer `BasePad`, then `BaseZone`, then `BaseAnchor`, avoiding tiny fallback-only safe zones.
- Fixed player join initialization ordering so state is set to `"Base"` before first oxygen update is sent.
- Reduced unnecessary network traffic by throttling oxygen updates only while `"Exploring"`; base-state changes are still sent immediately on transitions/refill.
- Hardened config handling by clamping `safeZoneBoundaryBuffer` to non-negative values in service initialization.
- Added a deterministic oxygen drain math test artifact: `OxygenService.spec.lua`.

### Review Outcome
- Changes Requested issues were resolved in-code.
- Story remains `done`.

## Change Log

- 2026-02-25: Applied code-review fixes for safe-zone fallback, join-state initialization, network update behavior, config hardening, and added oxygen drain test artifact.
