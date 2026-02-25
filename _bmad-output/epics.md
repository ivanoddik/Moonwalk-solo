# Moonwalk for brainrots - Development Epics

## Epic Overview

| # | Epic Name | Scope | Dependencies | Est. Stories | Status |
| --- | --- | --- | --- | --- | --- |
| 1 | Expedition Movement & Navigation | Movement, camera, traversal readability, return-path clarity | None | 5-7 | Complete (Engineering) |
| 2 | Capture & Delivery Loop | Capture interactions, carry state, delivery flow, payout trigger | 1 | 5-7 | Not Started |
| 3 | Oxygen Risk System | Oxygen drain (flat configurable rate), travel-commitment risk, fail/recovery loop | 1, 2 | 4-6 | Not Started |
| 4 | Base Income Core | Delivery payout rules, passive base income, reward readability | 2, 3 | 4-6 | Not Started |
| 5 | Upgrade Economy | Upgrade catalog, pricing curves, stat scaling, anti-stall flow | 4 | 5-8 | Not Started |
| 6 | Rebirth Economy & Meta Reset | Rebirth gates, reset behavior, permanent multipliers, slot growth | 5 | 5-7 | Not Started |
| 7A | Monetization Infrastructure | Robux store shell, entitlement persistence, purchase restore/rejoin reliability | 4, 5, 6 | 4-6 | Not Started |
| 7B | Monetization Offers & Tuning | Offer integration and balancing for Collect All, 2x Revenue, 2x Oxygen | 7A, 8A | 5-8 | Not Started |
| 8A | Content Scaling & Progression Depth | Zone depth scaling, rarity/mutation pacing, retention depth tuning | 3, 5, 6 | 5-8 | Not Started |
| 8B | Platform Hardening & Live Systems | Low-end mobile perf, 4-8 player stability, cloud saves, leaderboards, event hooks | 7B | 6-10 | Not Started |

---

## Epic 1: Expedition Movement & Navigation

### Goal

Deliver responsive traversal and readable route flow that supports short, repeatable runs.

### Scope

**Includes:**
- Player movement controller (mobile-first with cross-input parity)
- Camera behavior for route readability
- Return-path visibility and base orientation cues
- Traversal feel tuning for snappy response

**Excludes:**
- Capture logic and payload handling
- Economy, rebirth, and monetization systems

### Dependencies

None

### Deliverable

Playable traversal loop prototype across core area.

### Stories

- As a player, I can move smoothly with touch/KBM/gamepad so traversal feels immediate.
- As a player, I can read where the base is so return decisions are clear.
- As a player, camera motion helps me navigate risk zones without disorientation.
- As a player, movement responsiveness remains stable on low-end mobile.
- As a player, I receive clear movement feedback so controls feel consistent.

---

## Epic 2: Capture & Delivery Loop

### Goal

Enable an end-to-end capture and return cycle that defines the main loop.

### Scope

**Includes:**
- Brainrot interaction/capture behavior
- Carry state and run payload handling
- Base delivery interaction
- Delivery payout trigger event

**Excludes:**
- Oxygen failure/recovery system
- Progression balance and rebirth logic

### Dependencies

Epic 1

### Deliverable

Complete capture -> return -> deliver cycle functioning in runtime.

### Stories

- As a player, I can capture a Brainrot using context action so collection is straightforward.
- As a player, I can carry captured Brainrots through the run.
- As a player, I can deliver captured Brainrots at base to resolve a run.
- As a player, I receive immediate payout feedback on delivery.
- As a designer, capture and delivery states are robust across reconnect/retry cases.

---

## Epic 3: Oxygen Risk System

### Goal

Create meaningful risk/reward tension through oxygen constraints.

### Scope

**Includes:**
- Oxygen drain behavior tied to run state/distance
- Risk scaling as player moves deeper
- Oxygen depletion fail state
- Failure recovery and quick restart flow

**Excludes:**
- Full economy and progression balancing

### Dependencies

Epic 1, Epic 2

### Deliverable

Stable risk loop with clear failure and immediate retry.

### Stories

- As a player, oxygen drains during expeditions so risk is always present.
- As a player, deeper routes increase oxygen pressure through longer travel commitment while oxygen drain rate stays flat.
- As a player, oxygen depletion causes a clear fail state.
- As a player, I respawn quickly at base so retry cadence stays fast.
- As a player, oxygen urgency feedback is clear but not overwhelming.

---

## Epic 4: Base Income Core

### Goal

Establish the baseline economy flow from captured value to usable income.

### Scope

**Includes:**
- Delivery payout rules
- Passive base income from placed Brainrots
- Income readability and core economy feedback

**Excludes:**
- Upgrade economy and rebirth systems

### Dependencies

Epic 2, Epic 3

### Deliverable

Reliable earn loop with visible short-session rewards.

### Stories

- As a player, payout reflects captured rarity/mutation value.
- As a player, placed Brainrots generate passive income over time.
- As a player, I can read current income state clearly.
- As a designer, base income remains stable under repeated run cycles.

---

## Epic 5: Upgrade Economy

### Goal

Deliver consistent progression through upgrades with no dead runs.

### Scope

**Includes:**
- Upgrade catalog and progression map
- Pricing curves for oxygen/stat/capacity scaling
- Spend flow and anti-stall progression safeguards

**Excludes:**
- Rebirth reset and permanent multipliers

### Dependencies

Epic 4

### Deliverable

Strong short-session upgrade progression loop.

### Stories

- As a player, I can buy upgrades that clearly improve run capability.
- As a player, costs scale predictably and feel fair.
- As a player, each completed run contributes meaningful upgrade progress.
- As a system, anti-stall logic prevents repeated dead progression states.
- As a player, progression feels meaningful within the first minute.

---

## Epic 6: Rebirth Economy & Meta Reset

### Goal

Add long-term retention through rebirth-based meta progression.

### Scope

**Includes:**
- Rebirth requirement tracking (capture + oxygen thresholds)
- Reset behavior for current money/oxygen
- Permanent multipliers (movement speed, income)
- Base slot growth per rebirth

**Excludes:**
- Monetization effects and offers

### Dependencies

Epic 5

### Deliverable

Complete rebirth loop that accelerates future progression cycles.

### Stories

- As a player, I can see rebirth requirement progress clearly.
- As a player, rebirth resets run-state resources as designed.
- As a player, rebirth grants permanent boosts that speed future progression.
- As a player, base capacity increases with each rebirth milestone.
- As a system, rebirth transitions preserve persistence integrity.

---

## Epic 8A: Content Scaling & Progression Depth

### Goal

Scale content depth enough to validate retention and long-run progression quality.

### Scope

**Includes:**
- Distance zone depth expansion
- Rarity/mutation pacing and distribution tuning
- Unlock pacing tied to oxygen/rebirth milestones
- Retention-focused content cadence tuning

**Excludes:**
- Monetization platform infra
- Final technical hardening

### Dependencies

Epic 3, Epic 5, Epic 6

### Deliverable

Content depth sufficient for progression and retention testing.

### Stories

- As a player, deeper zones feel meaningfully more rewarding.
- As a player, rarity/mutation outcomes scale with risk in a readable way.
- As a player, unlock pacing keeps progress constant without farming stalls.
- As design, content depth supports repeated-session engagement testing.

---

## Epic 7A: Monetization Infrastructure

### Goal

Implement robust monetization infrastructure before offer balancing.

### Scope

**Includes:**
- Robux store shell and purchase UX framework
- Product entitlement persistence
- Purchase receipt handling and validation
- Restore/rejoin reliability for owned products

**Excludes:**
- Final monetization offer balancing and economy tuning

### Dependencies

Epic 4, Epic 5, Epic 6

### Deliverable

Reliable monetization infrastructure with persistent ownership handling.

### Stories

- As a player, I can open and browse the Robux store.
- As a player, purchases are granted and persisted correctly.
- As a player, owned products restore on reconnect/rejoin.
- As a system, entitlement checks are resilient to transient failures.

---

## Epic 7B: Monetization Offers & Tuning

### Goal

Integrate and balance monetization offers without breaking the core loop.

### Scope

**Includes:**
- Offer integration for Collect All, 2x Revenue, 2x Oxygen
- Economy impact validation and tuning
- Value messaging and clarity in purchase surfaces
- Fairness guardrails for free-player viability

**Excludes:**
- New core mechanics unrelated to offers

### Dependencies

Epic 7A, Epic 8A

### Deliverable

Monetization offers live and tuned to preserve progression integrity.

### Stories

- As a player, I can buy and use Collect All as a convenience boost.
- As a player, I can activate 2x Revenue with clear effect visibility.
- As a player, I can activate 2x Oxygen with predictable run impact.
- As design, monetization never hard-blocks free progression.
- As design, offer tuning preserves risk/reward tension and pacing.

---

## Epic 8B: Platform Hardening & Live Systems

### Goal

Finalize launch-grade technical quality and live systems reliability.

### Scope

**Includes:**
- Low-end mobile performance hardening
- Multiplayer stability for 4-8 player servers
- Cloud saves and leaderboard reliability pass
- Event hook stabilization and production readiness
- Crash/rejoin quality gate validation

**Excludes:**
- Major redesign of core progression systems

### Dependencies

Epic 7B

### Deliverable

Production-ready build quality baseline for launch.

### Stories

- As a player on low-end mobile, gameplay remains stable at target performance.
- As a player in multiplayer sessions, state remains consistent and reliable.
- As a player, cloud saves and leaderboard state remain durable.
- As production, crash rate and rejoin behavior meet launch gate requirements.

---

## Go/No-Go Gates

1. **Post-Epic 6 Gate:** Rebirth loop proves constant progression (no stuck states)
2. **Post-Epic 8A Gate:** Content depth supports retention testing
3. **Post-Epic 7B Gate:** Monetization does not break core risk/reward loop
4. **Pre-Launch Gate (8B):** Performance, crash, and rejoin quality thresholds met
