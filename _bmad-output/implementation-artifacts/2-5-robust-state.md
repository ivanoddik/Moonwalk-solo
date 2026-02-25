# Story 2.5: Robust State

Status: done

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As a designer,
I want capture and delivery states to be robust across reconnect/retry cases,
so that player progression and carry payloads are not lost during network hiccups.

## Acceptance Criteria

1. Player carry state must be fully managed on the server (authority) and isolated from client manipulation.
2. If a player disconnects while carrying a captured Brainrot, that carry state should be either preserved or safely wiped (depending on the design decision: currently wiping is typical to prevent free run safety). For this sprint slice, we must ensure it is safely cleared from memory to avoid leaks.
3. Rapid succession of capture/delivery interactions (spamming "E") must not result in duplicate captures or duplicate payouts.
4. Out-of-bounds or physically impossible interaction requests must be rejected gracefully with appropriate telemetry/feedback codes.
5. All capture/delivery interactions must strictly pass through the `InteractionAuthorityService` pipeline.

## Tasks / Subtasks

- [x] Task 1: Re-verify CarryStateService Cleanup (AC: #2)
  - [x] Subtask 1.1: Ensure PlayerRemoving event is hooked up in CarryStateService to clear memory of carried items for disconnected players.
- [x] Task 2: Interaction Rate Limiting/Debouncing (AC: #3)
  - [x] Subtask 2.1: Add a short cooldown/debounce per player in `InteractionAuthorityService` to prevent "E" spamming from causing race conditions in capture/delivery.
- [x] Task 3: Authority Pipeline Verification (AC: #1, #4, #5)
  - [x] Subtask 3.1: Confirm client cannot send arbitrary `brainrotId` or `payoutPreview` to force a fake capture/delivery. (Already partially done; ensure no regression).
  - [x] Subtask 3.2: Write automated/manual test notes for spamming interactions and verifying economy stability.

## Dev Notes

- **Relevant architecture patterns:** The game is server-authoritative. The client only sends "Intent". The server reads the player's position, checks tags (`CaptureTarget`, `DeliveryPoint`), and executes logic.
- **Source tree components to touch:**
  - `src/Server/Services/Session/CarryStateService.lua`
  - `src/Server/Services/Session/InteractionAuthorityService.lua`
  - `src/Server/Services/Economy/CaptureDeliveryService.lua`
- **Testing standards summary:** Ensure that spamming the remote event locally does not award double currency or double captures.

### Project Structure Notes

- Uses standard Rojo setup with `src/Client`, `src/Server`, and `src/Shared`.
- Strict MVC/Service pattern where Controllers (Client) talk to Services (Server) via Remotes.

### References

- Epic breakdown: `_bmad-output/epics.md#Epic 2: Capture & Delivery Loop`
- Previous tasks: `_bmad-output/implementation-artifacts/epic-2-capture-delivery-loop-tasks.md`

## Dev Agent Record

### Agent Model Used

gemini-3.1-pro-preview

### Debug Log References

### Testing Notes
- **Debouncing:** Spamming the "E" button client-side will not trigger server-side captures rapidly; there is a `DEBOUNCE_TIME` (0.5s) per player.
- **Authority:** Client payload does not send `brainrotId` or `payoutPreview`. Server directly checks distance to `CaptureTarget` and uses internal configs to fetch data.
- **Memory Cleanup:** Upon player disconnect, both `InteractionAuthorityService`'s debounce tracker and `CarryStateService`'s memory of the player's carried payload are cleared safely.

### Completion Notes List

- Implemented `PlayerRemoving` hooks to properly wipe states on exit to prevent memory leaks and lock-ins.
- Implemented a standard `0.5s` cooldown for the `InteractionAuthorityService` on a per-player basis using `os.clock()`.
- Verified authority model: Client sends `INTERACT` intent only. Server decides result deterministically. No client-supplied values influence the payload.
Ultimate context engine analysis completed - comprehensive developer guide created for Epic 2 Story 5 (Robust State).

### File List
- src/Server/Services/Session/CarryStateService.lua
- src/Server/Bootstrap/ServerMain.server.lua
- src/Server/Services/Session/InteractionAuthorityService.lua
