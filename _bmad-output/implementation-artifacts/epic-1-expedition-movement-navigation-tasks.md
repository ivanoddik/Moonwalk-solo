# Epic 1 - Expedition Movement & Navigation Task Breakdown

## Scope Anchor

Source epic: `Expedition Movement & Navigation` from `_bmad-output/epics.md`

Goal: Deliver responsive traversal and readable route flow for short, repeatable runs.

## Task Sequence (Implementation-Ready)

### E1-T1: Input Layer (touch-first, cross-input parity)
- Implement `InputRouter` in `src/Client/Input`.
- Map actions: move, sprint (if enabled), interact intent, camera look.
- Add device abstraction for touch/KBM/gamepad without branching game logic.
- **Acceptance checks**
  - Same movement intent API regardless of device.
  - No direct input reads outside input layer.

### E1-T2: Character Movement Controller
- Implement `MovementController` in `src/Client/Controllers`.
- Add acceleration/deceleration tuning variables in `src/Shared/Config`.
- Expose deterministic movement state (`Idle`, `Moving`, `Stopped`).
- **Acceptance checks**
  - Feels responsive on mobile.
  - Config values tune behavior without code edits.

### E1-T3: Camera Readability Controller
- Implement `CameraController` in `src/Client/Controllers`.
- Add follow rules optimized for route readability and low disorientation.
- Add constrained camera behavior for tight zones.
- **Acceptance checks**
  - Forward route remains visible during traversal.
  - Camera motion avoids abrupt jumps/oscillation.

### E1-T4: Base Orientation & Return Cues
- Implement base-direction HUD indicator in `src/Client/Components`.
- Add world-space guidance cues for return-path legibility.
- Emit route context events using shared event naming (`Domain/Action`).
- **Acceptance checks**
  - Player can consistently identify base direction from expedition paths.
  - Cues remain readable on low-end mobile.

### E1-T5: Traversal Feedback (lightweight)
- Add movement feedback hooks (SFX/VFX placeholders) with low performance cost.
- Keep effects intensity configurable and mobile-safe.
- **Acceptance checks**
  - Movement state changes produce clear but lightweight feedback.
  - No measurable FPS drops from feedback layer in target scenes.

### E1-T6: Network Alignment & Validation
- Ensure client movement remains locally responsive while server remains authoritative for gameplay-affecting outcomes.
- Validate no economy/progression writes occur from movement stack.
- **Acceptance checks**
  - Movement loop has no authority boundary violations.
  - Service contracts remain clean for later epics.

### E1-T7: Mobile Stability & Tuning Pass
- Run low-end mobile test pass (focus: input lag, camera smoothness, route readability).
- Tune config values for 30 FPS floor and session readability.
- **Acceptance checks**
  - Meets baseline mobile responsiveness targets.
  - No blocker-level control/camera defects.

## Definition of Done (Epic 1)

- Player can traverse core area smoothly on touch and KBM/gamepad.
- Camera supports navigation clarity and low disorientation.
- Base return direction is always understandable.
- Movement loop is stable on low-end mobile targets.
- Implementation follows project-context rules (authority, config centralization, naming).

## Suggested Story-to-Task Mapping

- Story: smooth movement -> `E1-T1`, `E1-T2`
- Story: clear base direction -> `E1-T4`
- Story: camera supports navigation -> `E1-T3`
- Story: low-end mobile stability -> `E1-T7`
- Story: consistent movement feedback -> `E1-T5`
