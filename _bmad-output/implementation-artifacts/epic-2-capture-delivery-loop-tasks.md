# Epic 2 - Capture & Display Loop Task Breakdown

## Scope Anchor

Source epic: `Capture & Display Loop` from `_bmad-output/epics.md`

Goal: Deliver complete capture -> carry -> pedestal placement flow with server-authoritative validation.

## Task Sequence (Implementation-Ready)

### E2-T1: Interaction Contracts + Events
- Define shared interaction event names and display feedback payload contracts.
- Add capture/delivery config for interaction range and payload defaults.
- **Acceptance checks**
  - Client sends intent-only payloads.
  - Shared constants are single source of truth.

### E2-T2: Server Carry-State Service
- Add per-player carry state service (set/get/clear).
- Prevent duplicate carries and invalid state transitions.
- **Acceptance checks**
  - One active carried payload max per player.
  - State survives normal run interactions until placed on pedestal/cleared.

### E2-T3: Capture Target Resolver
- Resolve nearest valid capture target within configured range.
- Restrict candidates by tag + attributes (`CaptureTarget`, `BrainrotId`, value multipliers).
- **Acceptance checks**
  - Server decides target; client does not provide target IDs.
  - Out-of-range intents are rejected safely.

### E2-T4: Pedestal Resolver
- Resolve nearest valid empty pedestal within configured range (`Pedestal` tag).
- Validate player is carrying payload before placement.
- **Acceptance checks**
  - Placement only succeeds with active carry state.
  - No duplicate passive generation triggers from same interact event.

### E2-T5: CaptureDisplayService Pipeline
- Implement authoritative `requestInteract(player)` pipeline:
  - if carrying -> try display on pedestal
  - else -> try capture
- Emit structured result object and feedback events.
- **Acceptance checks**
  - Deterministic result contract for capture/display/no-op.
  - Clear rejection reasons for telemetry/debug.

### E2-T6: Interaction Authority Integration
- Route `INTERACT` action from authority service into CaptureDisplayService.
- Keep non-whitelisted actions ignored.
- **Acceptance checks**
  - Action dispatch isolated to server service boundaries.
  - No economy writes in authority layer.

### E2-T7: Client Feedback Controller
- Listen to display/capture feedback remote for temporary UX feedback.
- Add minimal on-screen status text or logs for prototype verification.
- **Acceptance checks**
  - Player receives immediate capture/display confirmation.
  - Missing UI assets does not break gameplay loop.

### E2-T8: Prototype Test Harness Notes
- Define Studio setup tags/attributes for `CaptureTarget` and `Pedestal`.
- Add quick verification checklist.
- **Acceptance checks**
  - Team can spawn a minimal test scene and validate loop end-to-end.

## Definition of Done (Epic 2)

- Player can capture a valid target via interact intent.
- Player carry state is server-owned and deterministic.
- Player can place carried payload at valid empty pedestals.
- Placement emits deterministic server result (ready for future passive generation path).
- Capture/display flow has no client-authored authority leaks.

## Suggested Story-to-Task Mapping

- Story: capture brainrot -> `E2-T2`, `E2-T3`, `E2-T5`
- Story: carry through run -> `E2-T2`, `E2-T5`
- Story: display at base -> `E2-T4`, `E2-T5`
- Story: passive generation feedback -> `E2-T5`, `E2-T7`
- Story: reconnect/retry robustness -> `E2-T2`, `E2-T6`, `E2-T8`
