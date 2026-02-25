---
title: 'Game Architecture'
project: 'Moonwalk for brainrots'
date: '2026-02-24'
author: 'Ivan'
version: '1.0'
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8, 9]
status: 'complete'
engine: 'Roblox Studio'
platform: 'Roblox (mobile-first)'

# Source Documents
gdd: '/_bmad-output/gdd.md'
epics: '/_bmad-output/epics.md'
brief: '/_bmad-output/game-brief.md'
---

# Game Architecture

## Executive Summary

**Moonwalk for brainrots** architecture is designed for **Roblox Studio** targeting **Roblox (mobile-first)**.

**Key Architectural Decisions:**

- Server-authoritative economy, rebirth, and progression flows to protect integrity and prevent exploit-driven state drift.
- DataStore persistence with ProfileService-style session locking to keep profiles safe across reconnects and concurrent session edges.
- Service-oriented domain boundaries with shared event and config contracts to keep implementation consistent across AI agents and a small team.

**Project Structure:** Hybrid domain-driven organization with **10 core systems**.

**Implementation Patterns:** **8 patterns** defined to enforce consistency and predictable behavior.

**Ready for:** Epic implementation phase

## Document Status

This architecture document is complete and finalized through the GDS Architecture Workflow.

**Steps Completed:** 9 of 9 (Complete)

---

## Project Context

### Game Overview

**Moonwalk for brainrots** - A Roblox simulation-driven collection tycoon with short expedition loops, oxygen-based risk pressure, delivery-driven economy, and rebirth meta progression.

### Technical Scope

**Platform:** Roblox (mobile-first)  
**Genre:** Simulation / incremental-tycoon hybrid  
**Project Level:** Medium-High complexity (systems coupling + live tuning requirements)

### Core Systems

| System | Complexity | Source |
| --- | --- | --- |
| Movement and interaction runtime | Medium | GDD Core Gameplay / Mechanics |
| Oxygen risk and fail/recovery | Medium | GDD Core Gameplay / Progression |
| Capture-delivery-economy loop | High | GDD Mechanics / Progression |
| Base passive income and collection service | High | GDD Progression / Epics 4, 7B |
| Upgrade plus rebirth meta progression | High | GDD Progression / Simulation-specific |
| Persistence and leaderboards | Medium-High | GDD Technical Specs |
| Monetization store and entitlement restore | High | GDD Epics 7A/7B |
| Content scaling (zones/rarity/mutation) | Medium-High | GDD Level Design / Epics 8A |

### Technical Requirements

- 30 FPS minimum on low-end mobile
- <=10 second playable load target
- Stable 4-8 player sessions
- Cloud save reliability and leaderboard integrity
- Monetization integration without breaking progression fairness
- Fast iteration support for live balancing and retention tuning

### Complexity Drivers

- Strong coupling between risk loop, economy, base collection, and rebirth pacing
- Need for deterministic entitlement behavior across purchases/rejoin
- Requirement for anti-stall progression guarantees
- Heavy dependence on telemetry-driven tuning in a trend-sensitive market

### Technical Risks

- Economy instability (runaway inflation or stagnation)
- Monetization distorting progression or pillar intent
- Persistence/rejoin inconsistencies under live load
- Mobile performance regressions from content and VFX growth

## Engine & Framework

### Selected Engine

**Roblox Studio** (rolling release channel verified against current Creator Hub release notes)

**Rationale:** Roblox Studio is the native runtime for the target platform and provides rendering, physics, audio, input abstraction, networking primitives, and publish workflows aligned with a mobile-first multiplayer product.

### Project Initialization

Starting from scratch with a Rojo-structured external sync workflow:

```bash
mkdir moonwalk-for-brainrots
cd moonwalk-for-brainrots
rojo init
wally init
```

### Engine-Provided Architecture

| Component | Solution | Notes |
| --- | --- | --- |
| Rendering | Roblox engine renderer | Prioritize low-end mobile stability over visual complexity |
| Physics | Roblox physics engine | Keep economy-critical state server authoritative |
| Audio | Roblox audio stack | Dynamic layering and feedback implemented in game code |
| Input | Roblox input abstraction | Touch-first with KBM/gamepad parity |
| Scene/World Management | Place/Workspace + services model | Requires strict module/service boundaries for consistency |
| Build/Publish | Roblox Studio publish pipeline | Source-of-truth codebase synchronized via Rojo |

### External Sync and Dev Tooling

Baseline stack:
- Rojo (required)
- Wally (required)
- StyLua (required)
- Selene (required)

Optional later:
- Darklua (deferred optimization/transforms)

Quality workflow policy:
- Run order: `format -> lint` (StyLua, then Selene)
- Enforce through pre-commit and/or CI gates
- Keep shared config in repo root (`stylua.toml`, `selene.toml`) and document command order in CONTRIBUTING guidance

### AI Tooling (MCP)

Included in architecture setup:
- **Roblox Studio MCP:** `Roblox/studio-rust-mcp-server`
- **Documentation MCP:** `upstash/context7`

### Remaining Architectural Decisions

The following decisions remain for Step 4:
- Server-authoritative runtime boundaries (economy, oxygen, rebirth, purchases)
- Base passive-income and collection service design + anti-exploit model
- Persistence model (save cadence, reconcile/restore behavior)
- Monetization entitlement and effect application model
- Service/module boundaries and implementation patterns for multi-agent consistency
- Telemetry schema for progression and monetization tuning

## Architectural Decisions

### Decision Summary

| Category | Decision | Version | Rationale |
| --- | --- | --- | --- |
| State Management | Service-oriented state modules | Roblox Studio (rolling release) | Best balance of scalability and maintainability for 3-person team and AI-agent consistency |
| Data Persistence | DataStore + ProfileService-style session locking | Roblox DataStore APIs (current) | Reliable profile integrity for rebirth/economy/entitlements |
| Networking | Server-authoritative economy/progression | Roblox client-server model | Strong anti-exploit posture and deterministic progression outcomes |
| Asset Management | Scene/zone-based staged loading | Roblox streaming + custom loading boundaries | Better startup and memory behavior on low-end mobile |
| UI Architecture | Layered UI controllers + presentational components | LuaU modular UI pattern | Clear separation of concerns and easier multi-agent collaboration |
| Audio Architecture | Event-driven audio router with mix states | Roblox audio services + routing layer | Consistent feedback and tunable calm-to-tension progression |

### State Management

**Approach:** Service-oriented state modules

All game-critical state is owned by domain services with explicit read/write contracts and no direct external mutation.

### Data Persistence

**Save System:** DataStore + ProfileService-style session locking

Player progression and economy state are persisted through profile-based session locking to prevent race conditions and reduce corruption risk on reconnect or multi-session edge cases.

### Asset Management

**Loading Strategy:** Scene/zone-based staged loading

Load core base and near-zone assets first, then progressively load deeper content according to progression depth and performance budget.

### UI and Audio Boundaries

- UI uses layered controllers with presentational components for predictable data flow.
- Audio uses an event-driven router with mix states for consistent feedback and risk escalation cues.

### Architecture Decision Records

- Economy, rebirth, and monetization flows are server-authoritative.
- Base passive-income collection uses deterministic server-side payout calculations.
- Monetization effects (Collect All, 2x Revenue, 2x Oxygen) must route through shared economy pipelines.
- Tooling baseline: Rojo + Wally + StyLua + Selene (Darklua optional later).
- MCP setup included: Roblox Studio MCP + Context7.

### Architecture Red Lines

- Never accept client-authored economy values.
- Never allow direct script-level writes to profile state outside approved services.
- Never maintain duplicate payout logic paths for different offers.

## Cross-cutting Concerns

These patterns apply to all systems and must be followed by every implementation.

### Error Handling

**Strategy:** Global handler + Result-style returns

- Expected failures return structured result objects: `{ ok = false, errorCode = "...", context = {...} }`
- Successful operations return `{ ok = true, data = ... }`
- Unexpected exceptions are caught by a global error handler and routed to logging plus safe recovery.
- Economy, rebirth, and purchase flows must never silently fail.

Example:

```lua
local result = EconomyService:CollectIncome(player, scope)
if not result.ok then
    Log.Warn("Economy/CollectFailed", {
        playerId = player.UserId,
        errorCode = result.errorCode,
        scope = scope,
    })
    return
end
```

### Logging

**Format:** structured key-value logs (JSON-like fields)  
**Destination:** Studio output + server log pipeline (with production filtering)

**Log Levels:** ERROR, WARN, INFO, DEBUG

Required fields (minimum):
- playerId
- system
- action
- result
- timestamp

Example:

```lua
Log.Info("Rebirth/Completed", {
    playerId = player.UserId,
    system = "RebirthService",
    action = "CompleteRebirth",
    result = "ok",
    rebirthCount = profile.rebirthCount,
    timestamp = os.time(),
})
```

### Configuration

**Approach:** layered config modules + runtime player settings + environment flags

- Static modules for constants and balancing values
- Player preferences stored in profile state
- Environment flags for debug/dev-only behavior
- No hardcoded magic numbers inside service logic

Configuration structure:
- Config/Gameplay.lua
- Config/Economy.lua
- Config/Monetization.lua
- Config/Environment.lua

### Event System

**Pattern:** central event bus with typed event names

**Naming convention:** `<Domain>/<Action>`
- Economy/Collect
- Rebirth/Completed
- Oxygen/Depleted
- Monetization/PurchaseApplied

Execution model:
- Sync processing for gameplay-critical events
- Async dispatch for telemetry/analytics/non-critical observers

Example:

```lua
EventBus:Emit("Economy/Collect", {
    playerId = player.UserId,
    amount = payout,
    source = "BasePassiveIncome",
})
```

### Debug Tools

Available tools (dev-only):
- Economy snapshot inspector
- Oxygen state inspector
- Rebirth readiness panel
- Entitlement/purchase state inspector

Activation:
- Disabled by default in production
- Enabled only via environment debug flags and authorized developer checks

## Project Structure

### Organization Pattern

**Pattern:** Hybrid Domain-Driven

**Rationale:** Top-level folders separate concerns (source, assets, packages, config, docs), while in-source organization by game domain keeps architecture aligned with systems and epics.

### Directory Structure

```text
moonwalk-for-brainrots/
├── default.project.json
├── rojo.json
├── wally.toml
├── selene.toml
├── stylua.toml
├── .gitignore
├── README.md
├── docs/
│   ├── architecture/
│   ├── design/
│   └── operations/
├── tests/
│   ├── unit/
│   ├── integration/
│   └── harness/
├── assets/
│   ├── art/
│   │   ├── ui/
│   │   ├── world/
│   │   ├── effects/
│   │   └── icons/
│   ├── audio/
│   │   ├── music/
│   │   └── sfx/
│   └── data/
│       ├── balancing/
│       └── definitions/
├── packages/
│   └── _Index/
└── src/
    ├── Shared/
    │   ├── Config/
    │   ├── Types/
    │   ├── Constants/
    │   ├── Events/
    │   └── Utils/
    ├── Server/
    │   ├── Bootstrap/
    │   ├── Services/
    │   │   ├── Economy/
    │   │   ├── Oxygen/
    │   │   ├── Rebirth/
    │   │   ├── Progression/
    │   │   ├── Persistence/
    │   │   ├── Monetization/
    │   │   ├── Telemetry/
    │   │   └── Session/
    │   └── Systems/
    └── Client/
        ├── Bootstrap/
        ├── Controllers/
        ├── Components/
        └── Input/
```

### System Location Mapping

| System | Location | Responsibility |
| --- | --- | --- |
| Movement and input routing | `src/Client/Input`, `src/Client/Controllers` | Player input mapping, context actions, local responsiveness |
| Capture and delivery runtime | `src/Server/Services/Economy`, `src/Server/Services/Session` | Server-authoritative capture validation, delivery resolution |
| Oxygen risk system | `src/Server/Services/Oxygen`, UI in `src/Client/Controllers` | Drain, fail-state triggers, warning/state projection |
| Base passive income and collection | `src/Server/Services/Economy` | Accrual, deterministic collect pipeline, payout authority |
| Upgrade economy | `src/Server/Services/Economy` + shared config | Costs, scaling, anti-stall progression guarantees |
| Rebirth system | `src/Server/Services/Rebirth` | Requirement checks, reset semantics, multiplier grants |
| Persistence/profile | `src/Server/Services/Persistence` | Profile session lock, save checkpoints, rejoin restore |
| Monetization and entitlements | `src/Server/Services/Monetization` | Purchase validation, product effects, restore logic |
| Telemetry | `src/Server/Services/Telemetry` | KPI events, anomaly tracking, balancing signals |
| Event bus and cross-cutting infra | `src/Server/Systems`, shared events in `src/Shared/Events` | Typed events, decoupled communication, consistency |

### Naming Conventions

#### Files
- ModuleScripts/files: `PascalCase` (example: `EconomyService.lua`)

#### Code Elements
| Element | Convention | Example |
| --- | --- | --- |
| Classes/Modules | `PascalCase` | `EconomyService` |
| Functions/Methods | `camelCase` | `collectIncome` |
| Variables | `camelCase` | `currentOxygen` |
| Constants | `UPPER_SNAKE_CASE` | `MAX_OXYGEN_LEVEL` |

#### Game Assets
- Event names: `Domain/Action` (example: `Economy/Collect`)

### Architectural Boundaries

- Client never mutates authoritative economy/rebirth/persistence state.
- Server services own state and expose explicit action contracts.
- All economy-affecting paths (including offers) route through shared service pipelines.
- Shared configs hold balancing values; no magic numbers in service logic.
- UI controllers orchestrate state-to-view mapping; components remain presentational.

## Implementation Patterns

These patterns ensure consistent implementation across all AI agents.

### Novel Patterns

#### Passive Income + Collect + Rebirth Consistency Pattern

**Purpose:** Guarantee deterministic economy behavior when passive accrual, manual collection, rebirth resets, and reconnects interact.

**Components:**
- IncomeAccrualService (server-authoritative accrual)
- CollectionService (single payout pipeline)
- RebirthService (atomic reset boundary)
- ProfileServiceAdapter (session-locked persistence)
- TelemetryService (economy anomaly tracing)

**Data Flow:**
1. Passive accrual ticks server-side per eligible slot.
2. Player collection request enters CollectionService.
3. Server computes payout snapshot deterministically.
4. State commit occurs (profile + runtime sync).
5. Telemetry event emitted.
6. Rebirth executes only through atomic transaction boundary:
   - settle/reconcile pending values
   - apply reset fields
   - apply permanent multipliers
   - persist checkpoint

**State Management Rule:** No client-authored economy deltas.

Example:

```lua
local function collectIncome(player, scope)
    local profile = Profiles:get(player)
    if not profile then return { ok = false, errorCode = "PROFILE_MISSING" } end

    local snapshot = EconomySnapshotter:build(profile, scope)
    local payout = EconomyCalculator:compute(snapshot)

    profile.data.currency = profile.data.currency + payout.total
    profile.data.lastCollectAt = os.time()

    Telemetry:emit("Economy/Collect", {
        playerId = player.UserId,
        amount = payout.total,
        scope = scope,
    })

    return { ok = true, data = payout }
end
```

#### Monetization Offer Effect Harmonization Pattern

**Purpose:** Ensure monetization offers (Collect All, 2x Revenue, 2x Oxygen) are applied through one canonical rules engine without forked logic.

**Components:**
- PurchaseService (receipt + ownership verification)
- EntitlementService (active offer state)
- OfferEffectResolver (canonical multiplier/effect ordering)
- CollectionService / OxygenService hooks (shared application points)
- TelemetryService (offer impact tracking)

**Canonical Ordering Rule:** base value -> rarity/mutation -> rebirth multipliers -> monetization effects -> final clamp/rounding

Example:

```lua
local function resolveRevenue(baseValue, context)
    local value = baseValue
    value *= context.rarityMultiplier
    value *= context.mutationMultiplier
    value *= context.rebirthMultiplier

    if Entitlements:has(context.player, "2xRevenue") then
        value *= 2
    end

    return math.floor(value)
end
```

### Communication Patterns

**Pattern:** Event Bus + Service Contracts

Example:

```lua
EventBus:Emit("Rebirth/Completed", {
    playerId = player.UserId,
    rebirthCount = newCount,
})
```

### Entity Patterns

**Creation:** Factory + Pooling (for frequently spawned runtime entities)

Example:

```lua
local brainrot = BrainrotFactory:create(definitionId)
BrainrotPool:checkout(brainrot)
```

### State Patterns

**Pattern:** Explicit State Machines for run/session lifecycle

Example:

```lua
RunStateMachine:transition(player, "Exploring", "Returning")
```

### Data Patterns

**Access:** Central DataManager interfaces + Profile Adapter

Example:

```lua
local snapshot = DataManager:getPlayerEconomySnapshot(player)
local result = EconomyService:requestCollect(player, "All")
```

### Consistency Rules

| Pattern | Convention | Enforcement |
| --- | --- | --- |
| Economy writes | Server-only, pipeline-based | Service boundary checks + review |
| Offer effects | Resolver-only application | Ban direct multiplier math in feature scripts |
| Event names | Domain/Action | Shared EventNames module |
| Service APIs | request* for writes, get*Snapshot for reads | Interface contract standards |
| Rebirth transitions | Atomic transaction boundary | Rebirth service owns reset + persist checkpoint |

## Architecture Validation

### Validation Summary

| Check | Result | Notes |
| --- | --- | --- |
| Decision Compatibility | PASS | Engine/tooling, authority model, persistence, and cross-cutting rules align |
| GDD Coverage | PASS | Core systems and constraints are mapped to architecture modules |
| Pattern Completeness | PASS | Standard plus novel patterns defined with concrete examples |
| Epic Mapping | PASS | Epics map to service domains and staged delivery sequence |
| Document Completeness | PASS | Required sections present and coherent |

### Coverage Report

**Systems Covered:** 10/10  
**Patterns Defined:** 8  
**Decisions Made:** 6 critical + architecture red lines

### Issues Resolved

- Added Base passive income and collection as a dedicated architecture system
- Finalized tooling baseline with StyLua and Selene
- Locked architecture red-line constraints for authority and payout consistency

### Validation Date

2026-02-24

## Development Environment

### Prerequisites

- Roblox Studio installed and authenticated
- Rojo CLI installed and available in PATH
- Wally CLI installed and available in PATH
- StyLua installed for formatting
- Selene installed for linting

### AI Tooling (MCP Servers)

The following MCP servers were selected during architecture to enhance AI-assisted development:

| MCP Server | Purpose | Install Type |
| ---------- | ------- | ------------ |
| Roblox/studio-rust-mcp-server | Live Roblox Studio inspection and interaction | MCP server |
| upstash/context7 | Up-to-date engine and framework documentation lookup | MCP server |

**Setup:**
- Install and register both MCP servers in your Cursor MCP configuration.
- Verify each server is reachable from the IDE before implementation.

These give your AI assistant direct access to Roblox Studio for scene inspection, asset queries, and context-aware code generation.

### Setup Commands

```bash
mkdir moonwalk-for-brainrots
cd moonwalk-for-brainrots
rojo init
wally init
stylua .
selene src
```

### First Steps

1. Initialize the project folder and Rojo/Wally baseline.
2. Add the agreed repository structure (`src`, `assets`, `tests`, `docs`, and config files).
3. Configure MCP servers (if selected) per the AI Tooling instructions above.
4. Implement bootstrap service shells for Economy, Oxygen, Rebirth, Persistence, Monetization, and Telemetry.
