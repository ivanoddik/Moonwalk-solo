# Story 3.5: Oxygen urgency feedback is clear

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a player,
I want clear, non-overwhelming visual and audio feedback when my oxygen is running out,
so that I can accurately gauge my risk and time my return to base safely.

## Acceptance Criteria

1. **Visual Warning:** When oxygen drops below the `lowOxygenWarningThreshold` (e.g., <= 20%), the oxygen UI must provide a clear visual warning (e.g., pulsing text or UI element) that is highly visible but does not obscure the gameplay view.
2. **Audio Warning:** A distinct, non-intrusive audio cue should play/loop when entering the low oxygen state to alert the player without adding excessive cognitive load.
3. **State Recovery:** If oxygen is replenished above the threshold (e.g., returning to base or respawning), all low-oxygen visual and audio warnings must immediately stop.
4. **Idempotency:** UI tweens and Sound objects must not memory leak or stack upon multiple threshold crossings. Clean up previous tweens/sounds before starting new ones.

## Tasks / Subtasks

- [x] Task 1: Implement Visual Oxygen Warnings (AC: #1, #3, #4)
  - [x] Subtask 1.1: Update `OxygenController` to detect when oxygen is `<= payload.threshold` (or `OxygenConfig.lowOxygenWarningThreshold`).
  - [x] Subtask 1.2: Implement an infinite pulsing Tween on the UI element (e.g., text transparency or color) when the warning is active.
  - [x] Subtask 1.3: Cancel the Tween and restore default UI properties when oxygen recovers above the threshold, or when the run fails.
- [x] Task 2: Implement Audio Oxygen Warnings (AC: #2, #3, #4)
  - [x] Subtask 2.1: Create a lightweight warning `Sound` (e.g., a low-pitch beep) managed by `OxygenController` or an Audio service wrapper.
  - [x] Subtask 2.2: Play the warning sound (looped or interval-based) when in the low-oxygen state.
  - [x] Subtask 2.3: Stop the sound immediately when the warning state is exited.
- [x] Task 3: Author unit/integration tests
  - [x] Subtask 3.1: Write tests for `OxygenController` or abstract the UI/audio effects to ensure state transitions correctly trigger and suppress the warnings.

## Dev Notes

**🚨 ARCHITECTURE & PREVIOUS STORY COMPLIANCE (CRITICAL) 🚨**
- **Client-Side Presentation:** Oxygen calculations are server-authoritative. The server sends the current oxygen and the max/threshold to the client. The *client* orchestrates the visual and audio feedback based on this state. Modifying `OxygenController.lua` is exactly the right place. [Source: `project-context.md#Code Organization Rules`]
- **Performance Restrictions:** Use Roblox's `TweenService` for the visual pulse rather than `RunService` manual math if possible, as it is cheaper. Ensure tweens are properly cancelled. [Source: `project-context.md#Performance Rules`]
- **Configuration:** Do not hardcode the warning sound ID, tween duration, or colors within the runtime logic. Read these from `src/Shared/Config/Oxygen.lua`. [Source: `project-context.md#Engine-Specific Rules`]

**🚫 ANTI-PATTERNS TO AVOID 🚫**
- **DO NOT** obscure the player's view with massive red screen overlays that block navigation. The GDD explicitely states "clear but not overwhelming".
- **DO NOT** make the audio warning a high-pitched, loud, or annoying sound. The GDD demands "readable and non-intrusive" tension.
- **DO NOT** leak tweens. Always hold a reference to the active pulsing tween and call `:Cancel()` before creating a new one or returning to the normal state.

### Project Structure Notes

- Client UI Logic: `src/Client/Controllers/OxygenController.lua`
- Configuration: `src/Shared/Config/Oxygen.lua`

### References

- `_bmad-output/epics.md#Epic 3: Oxygen Risk System`
- `_bmad-output/project-context.md#Performance Rules`
- `_bmad-output/gdd.md#Audio and Music`

## Dev Agent Record

### Agent Model Used

Antigravity 

### Debug Log References
- Confirmed logic transitions safely suppress the warning properties when returning to `Base` or upon failure (`Depleted`). 
- Verified Tween animations are properly canceled to avoid memory leaks.
- Refactored `OxygenController:_ensureGui()` during AI Code Review to attempt grabbing existing GUI elements from `StarterGui`/`PlayerGui` before running `Instance.new(xxx)` to save instantiation performance overhead and better comply with Roblox structure conventions.

### Completion Notes List
- Updated `OxygenConfig.lua` to store visual colors, tween durations, and explicit sound IDs.
- Created robust Unit Tests for `OxygenController` verifying that Audio/Visual warnings accurately mimic the payload states.
- Handwired UI warning tween properties natively referencing the configuration properties inside `OxygenController`.

### File List
- `src/Shared/Config/Oxygen.lua`
- `src/Client/Controllers/OxygenController.lua`
- `src/Client/Controllers/OxygenController.spec.lua`

## Change Log
- 2026-02-25: Status changed from `ready-for-dev` to `review`. Development completed by Dev Agent.
- 2026-02-25: Status changed from `review` to `done`. Code Review completed with 1 Medium/2 Low severities automatically patched in `OxygenController.lua`.

