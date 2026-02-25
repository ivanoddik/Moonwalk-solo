# Moonwalk for brainrots - Context Handoff (New Chat Upload)

## Current Project State

- BMAD design/architecture workflows are complete and documented:
  - `_bmad-output/game-brief.md`
  - `_bmad-output/gdd.md`
  - `_bmad-output/epics.md`
  - `_bmad-output/game-architecture.md`
  - `_bmad-output/project-context.md`
- Project scaffold exists at:
  - `moonwalk-for-brainrots/`
- Repo is **not** a git repository.

## Workflow Status Snapshot

- Epic 1 status in `epics.md`: **Complete (Engineering)**
- Epic 1 closure file:
  - `_bmad-output/implementation-artifacts/epic-1-closure-signoff.md`
  - Manual verification checklist marked complete.
- Epic 2 kickoff file:
  - `_bmad-output/implementation-artifacts/epic-2-capture-delivery-loop-tasks.md`

## Implemented Code (Scaffold + Core Systems)

### Root + Tooling

- `moonwalk-for-brainrots/default.project.json`
- `moonwalk-for-brainrots/rojo.json`
- `moonwalk-for-brainrots/wally.toml`
- `moonwalk-for-brainrots/stylua.toml`
- `moonwalk-for-brainrots/selene.toml`

### Epic 1 (Movement/Navigation)

- Input + movement:
  - `src/Client/Input/InputRouter.lua`
  - `src/Client/Controllers/MovementController.lua`
  - `src/Shared/Config/Movement.lua`
- Camera + base orientation:
  - `src/Client/Controllers/CameraController.lua`
  - `src/Client/Controllers/BaseOrientationController.lua`
  - `src/Shared/Config/Navigation.lua`
- Feedback:
  - `src/Client/Controllers/MovementFeedbackController.lua`
  - `src/Shared/Config/Feedback.lua`
- Environment/perf profile controls:
  - `src/Shared/Config/Environment.lua`
  - `src/Shared/Config/Performance.lua`
  - `src/Shared/Config/DeviceProfiles.lua`
  - `src/Client/Controllers/PerformanceMonitorController.lua`
- Client bootstrap wiring:
  - `src/Client/Bootstrap/ClientMain.client.lua`

### Epic 2 (Capture/Delivery Kickoff Scaffold)

- Shared contracts/config:
  - `src/Shared/Constants/ActionContracts.lua`
  - `src/Shared/Constants/EventNames.lua`
  - `src/Shared/Config/CaptureDelivery.lua`
- Server authority + carry + capture/delivery:
  - `src/Server/Services/Session/InteractionAuthorityService.lua`
  - `src/Server/Services/Session/CarryStateService.lua`
  - `src/Server/Services/Economy/CaptureDeliveryService.lua`
  - `src/Server/Bootstrap/ServerMain.server.lua`
- Client feedback pipeline:
  - `src/Client/Controllers/InteractionIntentController.lua`
  - `src/Client/Controllers/CaptureDeliveryFeedbackController.lua`

## Roblox Studio MCP State (Important)

- MCP connection worked and environment was created in Workspace:
  - `MoonwalkEnvironment` (base + expedition + capture/delivery setup)
- Gameplay wiring confirmed in Studio:
  - `CaptureTarget` tags: 9
  - `DeliveryPoint` tags: 1
  - `BaseAnchor`: present
- A visual asset-store import pass was attempted and then rolled back per user request.
  - Imported visual models were removed.
  - Current state keeps functional environment setup without that asset pack pass.

## Known Runtime Expectations

- Interaction currently sends **intent-only** from client.
- Server resolves capture/delivery targets via tags and range checks.
- Capture target attributes used:
  - `BrainrotId`
  - `BaseValue`
  - `RarityMultiplier`
  - `MutationMultiplier`

## Recommended Immediate Next Steps (In New Chat)

1. Validate current `MoonwalkEnvironment` in Studio play mode:
   - Press `E` near a `CaptureTarget` then near `DeliveryPoint`.
2. Implement Epic 2 next slice:
   - Add authoritative payout application path (server-side economy integration).
   - Add carry visual state (held indicator/model attach).
   - Add delivery and capture fail feedback reasons on UI.
3. Add integration tests/harness notes for Epic 2 flow.
4. Only after gameplay is stable, reattempt visual pass with curated assets (non-blocking only).

## Prompt To Start New Chat

Use this as your first message in the new chat:

\"Resume from `_bmad-output/implementation-artifacts/context-window-handoff.md`. Continue Epic 2 implementation from current scaffold, starting with authoritative payout integration and carry state presentation.\"
