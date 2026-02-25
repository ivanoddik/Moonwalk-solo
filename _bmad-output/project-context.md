---
project_name: 'Moonwalk for brainrots'
user_name: 'Ivan'
date: '2026-02-24'
sections_completed: ['technology_stack', 'engine_rules', 'performance_rules', 'organization_rules', 'testing_rules', 'platform_rules', 'anti_patterns']
status: 'complete'
rule_count: 60
optimized_for_llm: true
existing_patterns_found: 8
---

# Project Context for AI Agents

_This file contains critical rules and patterns that AI agents must follow when implementing game code in this project. Focus on unobvious details that agents might otherwise miss._

---

## Technology Stack & Versions

- Engine: Roblox Studio (rolling release channel)
- Language: LuaU
- Project synchronization: Rojo (required)
- Package/dependency management: Wally (required)
- Formatting: StyLua (required)
- Linting: Selene (required)
- Optional transform tooling: Darklua (deferred optional)
- AI tooling MCPs: `Roblox/studio-rust-mcp-server`, `upstash/context7`
- Target platform profile: Roblox mobile-first, stable 4-8 player sessions

## Critical Implementation Rules

### Engine-Specific Rules

- Treat all economy/progression state (currency, oxygen outcomes, rebirth, entitlements) as server-authoritative only.
- Never trust client payloads for value calculations; client sends intent, server recomputes and validates.
- Route all economy-affecting actions through service boundaries (`request*` write APIs); no direct profile mutation from feature scripts.
- Keep one canonical payout/order pipeline for all revenue paths (normal collect + offer-modified collect).
- Apply offer effects in canonical order only: base -> rarity/mutation -> rebirth multipliers -> monetization -> clamp/round.
- Keep event naming strict as `Domain/Action` and emit via shared event bus contracts.
- Use explicit state transitions for run lifecycle (exploring, returning, depleted, recovered); avoid implicit boolean state webs.
- Keep balance numbers in shared config modules; avoid hardcoded values inside runtime service logic.
- Rebirth must execute as an atomic server transaction boundary (settle pending, reset fields, apply permanent multipliers, persist checkpoint).
- Debug inspectors and dev cheats must be gated behind environment flags and never active by default in production.

### Performance Rules

- Maintain a minimum 30 FPS target on low-end mobile devices.
- Keep initial playable load at or below ~10 seconds through staged zone-based loading.
- Keep server simulation stable for 4-8 players with deterministic service tick behavior.
- Treat economy, oxygen, rebirth, and monetization resolution as hot paths; avoid unnecessary allocations and per-frame table churn.
- Use pooling/factory patterns for frequently spawned runtime entities (e.g., collectible brainrots/effects).
- Keep expensive telemetry/log payloads out of high-frequency loops; emit compact structured events.
- Prefer event-driven updates over polling-heavy loops on both client and server.
- Gate visual/audio intensity by progression with mobile budget caps to avoid late-zone FPS collapse.
- Profile and tune with Roblox microprofiler/session playtests before content-scale increases.
- Any optimization must preserve server-authoritative correctness and anti-exploit guarantees.

### Code Organization Rules

- Keep top-level repo layout aligned with architecture: `src`, `assets`, `tests`, `docs`, `packages`, plus root tool configs.
- Organize gameplay code by domain/service boundaries, not by ad-hoc feature folders.
- Use `src/Server/Services/*` for authoritative gameplay systems (Economy, Oxygen, Rebirth, Persistence, Monetization, Telemetry, Session).
- Use `src/Shared/*` for cross-runtime contracts only (Config, Types, Constants, Events, Utils); avoid shared modules that perform server writes.
- Use `src/Client/Controllers` for orchestration and `src/Client/Components` for presentational UI only.
- Keep event names and definitions centralized (`Domain/Action`) to avoid drift.
- Place balancing values in `src/Shared/Config/*`; do not embed tuning numbers in services/controllers.
- Follow naming conventions: module/class `PascalCase`, methods/variables `camelCase`, constants `UPPER_SNAKE_CASE`.
- Keep write APIs explicit as `request*` and read APIs as `get*Snapshot` for consistent agent-generated interfaces.
- Add new modules under existing domain roots before creating new top-level categories.

### Testing Rules

- Mirror architecture domains in tests (`tests/unit`, `tests/integration`, `tests/harness`) to keep ownership clear.
- Unit tests validate deterministic service logic (economy calculations, oxygen drain math, rebirth requirement checks, offer resolver ordering).
- Integration tests validate cross-service flows (capture -> deliver -> payout -> save checkpoint, purchase -> entitlement -> effect application).
- Always test server-authoritative rejection paths (invalid client requests, stale entitlement assumptions, illegal profile writes).
- Add regression tests for canonical payout ordering and rebirth atomic reset boundaries.
- Validate reconnect/session-lock scenarios for persistence consistency before release.
- Keep performance checks in harness runs for low-end mobile budgets and 4-8 player server load behavior.
- Any bug fix in economy/progression/monetization should include at least one targeted regression test.
- Prefer small deterministic fixtures over broad brittle end-to-end scripts.
- Test names should encode domain and expected outcome for fast triage (example: `Economy_CollectAll_AppliesResolverOrder`).

### Platform & Build Rules

- Primary runtime target is Roblox mobile-first; all gameplay features must be validated against low-end mobile constraints first.
- Support stable multiplayer sessions at 4-8 players without changing authoritative server logic by platform.
- Keep input handling touch-first with parity paths for keyboard/gamepad through shared input abstractions.
- Keep client UX responsive, but never move economy/progression authority to the client for "performance shortcuts."
- Use Rojo as source synchronization baseline and keep project structure compatible with external source-of-truth workflow.
- Use Wally for dependency management; avoid ad-hoc vendored packages without explicit architecture approval.
- Enforce local quality order before integration: `stylua .` then `selene src`.
- Keep development/debug flags environment-gated; production builds must default to debug tooling off.
- Preserve deterministic service contracts across build/deploy changes (especially economy, rebirth, monetization, persistence).
- Any platform-specific optimization must not alter payout logic, entitlement rules, or save semantics.

### Critical Don't-Miss Rules

- Never accept client-authored economy/progression values; client may request actions only.
- Never write profile data outside approved persistence/service boundaries.
- Never duplicate payout math across feature scripts; all payout/offer effects must use the canonical resolver pipeline.
- Never apply monetization multipliers out of order (base -> rarity/mutation -> rebirth -> monetization -> clamp/round).
- Never bypass rebirth transaction boundaries; rebirth must reconcile pending values, reset, apply permanents, then persist checkpoint atomically.
- Never ship debug inspectors or cheat toggles enabled by default in production.
- Never hardcode balance numbers in service logic; use shared config modules for tunable values.
- Never create hidden side-effect writes in read/snapshot APIs.
- Always handle missing profile/session-lock failures explicitly (no silent fallthrough).
- Always preserve fairness goals: monetization should accelerate progression without breaking the core risk-reward loop.

---

## Usage Guidelines

**For AI Agents:**

- Read this file before implementing any game code.
- Follow all rules exactly as documented.
- When in doubt, prefer the more restrictive option.
- Update this file if new project-specific patterns emerge.

**For Humans:**

- Keep this file lean and focused on agent implementation needs.
- Update whenever architecture, tooling, or platform constraints change.
- Review quarterly to remove stale rules and keep context efficient.

Last Updated: 2026-02-24
