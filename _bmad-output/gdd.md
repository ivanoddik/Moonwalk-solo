---
stepsCompleted:
  - 1
  - 2
  - 3
  - 4
  - 5
  - 6
  - 7
  - 8
  - 9
  - 10
  - 11
  - 12
  - 13
  - 14
inputDocuments:
  - '/_bmad-output/game-brief.md'
documentCounts:
  briefs: 1
  research: 0
  brainstorming: 0
  projectDocs: 0
workflowType: 'gdd'
lastStep: 14
project_name: 'Moonwalk for brainrots'
user_name: 'Ivan'
date: '2026-02-24'
game_type: 'simulation'
game_name: 'Moonwalk for brainrots'
---

# Moonwalk for brainrots - Game Design Document

**Author:** Ivan
**Game Type:** simulation
**Target Platform(s):** Roblox

---

## Executive Summary

### Core Concept

Moonwalk for brainrots is a Roblox simulation-driven collection tycoon where players launch short high-risk expeditions from a moon base to capture Brainrots of increasing rarity and value. Oxygen pressure creates moment-to-moment tension: go farther for better rewards, but risk losing the run if you fail to return in time. Captured Brainrots are delivered to base systems that generate income, which players reinvest into oxygen, transport capacity, progression upgrades, and rebirth growth.

The game is designed for young players (6-16) with an easy-to-learn interface, fast progression cadence, and immediate reward clarity. Session structure supports both short weekday bursts and longer weekend chains, using repeatable loops that continuously escalate through rarity tiers, mutation variants, and rebirth multipliers.

Strategically, the title positions itself as a polish-first evolution of proven Brainrots trend loops: same accessible core fantasy, but with clearer UX, stronger mobile performance, cleaner pacing, and more satisfying risk/reward feedback in a space setting.

### Target Audience

Primary audience is Roblox players aged 6-16 who prefer quick-reward, easy-to-understand progression games and social status expression through visible growth.

### Unique Selling Points (USPs)

- Space risk fantasy with oxygen pressure layered onto a proven Brainrots progression loop
- Polish-first UX/readability tuned for younger audiences (6-16)
- Mobile-first performance and stable 4-8 player session design
- Tighter reward feedback and progression cadence for rapid repeat play

---

## Goals and Context

## Target Platform(s)

### Primary Platform

Roblox

### Platform Considerations

Moonwalk for brainrots is designed as a Roblox-first experience with platform behavior centered on mobile usage while remaining playable across input environments. The product strategy prioritizes low-end mobile performance, short-session responsiveness, and stable multiplayer operation at 4-8 players per server.

Core platform systems include cloud saves, leaderboards, and live events to support progression continuity, social competition, and retention loops.

### Control Scheme

- Touch-first interaction model for mobile players
- Keyboard/mouse support for desktop Roblox users
- Gamepad-compatible interaction for console-like Roblox access
- Simple, low-friction controls aligned with ages 6-16 and fast repeat loops

---

## Target Audience

### Demographics

Primary audience is Roblox players aged 6-16 who prefer quick-reward, easy-to-understand progression games and social status expression through visible growth.

### Gaming Experience

Casual/Hypercasual - players are comfortable with low-friction loops and expect immediate progression feedback rather than deep onboarding complexity.

### Genre Familiarity

Audience is already familiar with simulator, tycoon, and adventure loop conventions on Roblox, reducing tutorial overhead and enabling faster first-session engagement.

### Session Length

Short weekday bursts + longer weekend sessions - gameplay is optimized for fast loops that can be completed quickly but chained repeatedly into longer play blocks.

### Player Motivations

- Flex/status through rare captures and progression visibility
- Fast progression momentum and compounding upgrades
- Social excitement from comparing achievements and showing off rare outcomes

Secondary audience: older Roblox idle/tycoon optimization players and returning users from similar Brainrots-loop experiences.

---

### Project Goals

1. Ship a polished vertical slice
   Deliver a complete and fun capture -> deliver -> upgrade -> rebirth gameplay loop that can stand as a minimum playable product.

2. Hit mobile-first technical quality
   Ensure stable low-end mobile performance and reliable multiplayer operation at the intended 4-8 player server scale.

3. Validate business viability in-trend
   Prove market fit for a Brainrots-loop variant by meeting target engagement, retention, and conversion benchmarks.

4. Create a replayable social progression experience
   Build a game that drives fast repeat sessions, visible player growth, and flex-based social motivation for the 6-16 audience.

### Background and Rationale

Moonwalk for brainrots is being developed during an active trend cycle where Brainrots-style progression loops are already validated by player behavior. The project deliberately uses an execution-first strategy: it is not trying to reinvent the category, but to deliver a cleaner, more polished version in a fresh sci-fi setting with stronger usability and pacing.

The team's motivation is practical and creative: the loop is inherently fun and engaging, has high replay potential, and offers strong viral distribution opportunities through short-form social moments and visible progression flex. Because the concept is highly replicable, success depends on shipping faster, cleaner, and more reliably than competing variants.

---

## Core Gameplay

### Game Pillars

1. Easy to Learn
   Systems are immediately understandable for young players, with low-friction onboarding and clear UI cues.

2. Fast Progression
   Every short run should contribute meaningful growth through frequent rewards and visible upgrades.

3. Rewarding for Risk
   Pushing farther under oxygen pressure yields materially better outcomes, reinforcing skillful risk-taking.

4. Social Flexing
   Rare captures and progression milestones are visible, shareable, and status-driving.

Pillar Prioritization:
1) Easy to Learn
2) Fast Progression
3) Rewarding for Risk
4) Social Flexing

### Core Gameplay Loop

Players repeatedly launch short expeditions from base, travel outward to capture Brainrots, manage oxygen constraints, and decide when to return. On successful return, they convert captures into revenue, invest in upgrades and capacity, and eventually rebirth for persistent multipliers that unlock higher-value future runs.

Loop Diagram:
Prepare at base -> Explore outward -> Capture Brainrots -> Monitor oxygen risk -> Return to base -> Deliver for revenue -> Buy upgrades/rebirth -> Repeat at higher risk/reward

Loop Timing:
~1-3 minutes per run, designed for chainable repeat sessions.

Loop Variation:
Each run varies through distance-based zone progression, rarity tier distribution, mutation outcomes, upgrade-driven power differences, and rebirth-level scaling.

### Win/Loss Conditions

Victory conditions:
- Run-level victory: Return safely with captured Brainrots and secure payout.
- Progression-level victory: Reach milestone unlocks (rarity tiers, upgrade thresholds, rebirth milestones, base growth).
- Session success state: Demonstrable growth in power, earning rate, and collectible value over repeated runs.

Failure conditions:
- Primary fail state: Oxygen depletion before safe return, resulting in run failure and loss of carried run value.
- Soft fail state: Conservative or inefficient runs that return low value and slow progression momentum.

Failure recovery:
On failure, players respawn at base with account-level progression intact, then immediately re-enter the loop with improved planning and/or upgraded stats. Failure is designed as a learning pressure that encourages route optimization rather than hard session termination.

---

## Game Mechanics

### Primary Mechanics

1. Explore Outward from Base
   Players move away from the safe dome/base into distance-based zones with increasing risk and potential value.

2. Capture Brainrots
   Players interact with Brainrot targets in the field to collect them as run payload.

3. Oxygen Management and Return Decision
   Oxygen is the run-pressure system; players continuously decide whether to push farther or return safely.

4. Deliver for Payout
   Returned Brainrots are delivered at base to secure run rewards and convert risk into progression value.

5. Upgrade Investment
   Revenue is spent on oxygen, movement/efficiency, carrying capacity, and progression systems to improve future runs.

6. Rebirth Progression
   Players can reset loop-state for persistent bonuses (stats/base scaling), enabling higher-value long-term growth.

Mechanic Interactions:
- Exploration directly drives capture opportunities and oxygen pressure.
- Oxygen system governs risk ceiling and decision tension for every run.
- Delivery resolves risk and feeds the economy loop.
- Economy upgrades alter exploration efficiency and safe return thresholds.
- Rebirth compounds long-term progression, changing risk/reward expectations at each phase.

Mechanic Progression:
- Early game: short safe runs, low complexity, rapid onboarding.
- Mid game: expanded distance/risk, stronger oxygen and carry optimization decisions.
- Late game/meta: rebirth loops and scaling systems unlock faster accumulation and higher-tier targets.

### Controls and Input

Control Scheme (Roblox):

Mobile (primary):
- Left virtual joystick: movement
- Context action button: interact/capture/deliver/trade
- Core HUD always visible: oxygen, distance, key progression indicators
- No dedicated fixed gameplay menu button

Keyboard/Mouse:
- WASD: movement
- E: interact/capture/deliver/trade (single-context verb)
- Mouse: camera + UI interaction
- No dedicated fixed gameplay menu hotkey

Gamepad:
- Left stick: movement
- Right stick: camera
- Context action button (A equivalent): interact/capture/deliver/trade
- No dedicated fixed gameplay menu button

Input Feel:
- Snappy, low-friction, immediate response
- Single-context interaction model to reduce cognitive load
- Clear feedback on interaction success/failure and oxygen urgency
- No complex combos or high-precision execution requirements

Accessibility Controls:
- Large touch targets and readable UI hierarchy
- Rarity signaling uses color + icon/shape cues (not color alone)
- High-contrast HUD option
- Reduced-motion option for intense VFX moments

---

## Simulation Specific Design

### Core Simulation Systems

Moonwalk for brainrots simulates expedition risk per loop. The simulation depth is intentionally simple and readable: players push outward under oxygen pressure where higher risk creates higher potential reward but also a higher chance of run failure.

What's being simulated:
- Risk exposure as distance increases
- Reward scaling based on rarity/mutation outcomes
- Failure probability through oxygen depletion pressure

System interconnections:
- Distance/risk -> higher rarity/mutation opportunities -> higher payout potential
- Oxygen constraints -> return timing decisions -> success/failure resolution
- Successful payout -> upgrades -> increased expedition capability -> access to higher-risk loops

### Management Mechanics

The player primarily manages movement and oxygen level in real time, with a mostly manual play pattern.

Management systems:
- Core manual decisions: route choice, push-vs-return timing, oxygen awareness
- Strategic spend decisions: which upgrades to prioritize before rebirth
- Automation component: base income generation is passive once captures are secured

### Building and Construction

There is no freeform base building in the current design.

Construction model:
- Base growth is progression-driven, not placement-driven
- Each rebirth grants +1 new Brainrot slot at base
- No demolition/rebuild loop planned in this phase
- Base expansion is systemic and milestone-based rather than creative construction

### Economic and Resource Loops

Economy centers on captured Brainrots as the primary value source.

Economic design:
- Income source: captured Brainrots converted to value
- Value scaling: rarity x mutation combinations increase payout
- Main sink: upgrades required to improve expedition capacity and qualify for rebirth
- Rebirth requirements: specific capture criteria + target max-oxygen threshold
- Growth shape: exponential income and pricing curve (slow early, very steep late)

### Progression and Unlocks

Progression is primarily tied to rebirth and base capacity growth.

Unlock systems:
- Core unlocks over time: base upgrade progression
- Structural expansion: +1 slot per rebirth
- Potential secondary unlock path: new exploration areas gated by rebirth count
- End-state direction: repeated rebirth cycles with escalating loop depth

### Sandbox vs Scenario

Current design is sandbox-style live progression with no scenario/campaign dependency.

- Primary mode: continuous progression loop
- Scenario/challenge modes: not currently defined for MVP
- Future optionality: event-based variations can be layered later without changing core loop identity

---

## Progression and Balance

### Player Progression

Progression in Moonwalk for brainrots is built around a clear oxygen-growth loop: players invest earnings into higher oxygen levels, which enables deeper expeditions, access to stronger Brainrots, and eventual rebirth qualification.

Rebirth is the core meta-progression system. On rebirth, current money and oxygen level are reset, but permanent multipliers are added (notably movement speed and income), making subsequent progression cycles faster and enabling deeper, more efficient runs with the same upgrade paths.

Progress should feel meaningful within the first minute of play and remain forward-moving every run.

Progression guarantee rule (anti-stuck):
Every completed run should advance at least one of:
- oxygen upgrade readiness
- rebirth requirement progress
- stronger-capture capability

### Difficulty Curve

Difficulty increases at a regular, controlled rate across progression.
The goal is sustained challenge without hard spikes: tension rises naturally with distance/risk, but the game remains approachable for the target audience.

Challenge scaling:
- Distance increases risk pressure gradually
- Stronger Brainrots require deeper runs and better oxygen stats
- Rebirth multipliers offset increasing challenge by improving movement and earnings
- Scaling focuses on pacing and tension, not punishing execution barriers

Controlled risk bands:
- Pressure increases through longer route commitment and clearer return windows, not per-zone oxygen drain multipliers
- No sudden multipliers or hidden spikes

### Economy and Resources

Moonwalk for brainrots uses a progression-coupled economy designed to maintain constant momentum and avoid stagnation.

Resources:
- Primary currency: money earned from captured Brainrots
- Value factors: Brainrot rarity and mutation combinations
- Progression gate resources: required capture criteria + oxygen thresholds for rebirth

Economy flow:
Capture Brainrots -> Deliver for money -> Buy oxygen progression/upgrades -> Reach stronger Brainrots -> Qualify for rebirth -> Reset run-state with permanent multipliers -> Repeat faster and deeper

Economy and progression tuning goals:
- Players should not need to repeatedly farm the same area
- Progression should remain consistently forward-moving across sessions
- If a player underperforms a run, the next run should still provide small guaranteed momentum

---

## Level Design Framework

### Level Types

Moonwalk for brainrots uses a hub-based progression structure centered on the base, with outward exploration into distance-based risk zones. The base functions as the return-and-progression anchor, while the playable field extends into increasingly risky, higher-value territory.

Level/area types:
- Core exploration zones: progressively farther distance bands with increasing risk/reward
- Intro/early zone layer: low-pressure area supporting first-session onboarding
- Advanced risk zones: deeper areas with stronger Brainrot value potential
- Future special/event zones (post-MVP): optional limited-time or high-risk variants

Tutorial integration:
Tutorial is embedded directly in the regular game area, not a separate safe zone. First-time guidance walks players through capturing a common Brainrot in a very easy, hard-to-fail setup, then naturally transitions into normal loop play.

Special levels:
No standalone boss levels are required for MVP. Specialized high-risk/event zones are planned as expandable post-MVP content.

### Level Progression

Progression model:
Gated expansion rather than linear stages. Players repeatedly run the same core structure with increasing capability, unlocking access to deeper/higher-value zones through progression milestones.

Unlock system:
- Oxygen progression thresholds
- Rebirth milestones
- Related progression requirements tied to run capability

Replayability:
- Short repeatable runs (1-3 minutes)
- Risk/reward routing decisions
- Rarity/mutation outcome variance
- Compounding rebirth progression that makes old paths faster while opening deeper targets

Level design principles:
- Teach through play, not long instruction blocks
- Meaningful progress should be felt within the first minute
- No dead runs: each run must push progression forward
- Use readable risk bands: farther distance clearly signals greater risk/reward

---

## Art and Audio Direction

### Art Style

Moonwalk for brainrots uses a Roblox-standard stylized 3D visual direction optimized for clarity, speed of production, and performance on low-end mobile devices. The visual language prioritizes readability and immediate comprehension for a younger audience, while preserving a playful meme identity with sci-fi framing.

Visual references:
- Primary baseline: Dive for Brainrots! (readability, loop communication, visual pacing)
- Directional intent: familiar trend visual grammar with cleaner polish and clearer progression signaling

Color palette:
- Vibrant, high-contrast palette
- Strong readability for interactables and progression cues
- Rarity/mutation visibility emphasized through clear color bands and supporting iconography

Camera and perspective:
- Roblox 3D third-person exploration framing
- Camera behavior supports movement readability, interaction clarity, and route planning under oxygen pressure

### Audio and Music

Audio direction supports fast loop pacing and emotional risk/reward transitions without adding cognitive load.

Music style:
- Light ambient/chill layer around base/safe state
- Increasing tension and intensity as players move into deeper risk zones
- Dynamic mood shift reinforces push-vs-return decisions

Sound design:
- Punchy, immediate feedback for capture, delivery, upgrade, and progression events
- Distinctive cues for rarity/mutation outcomes
- Oxygen urgency cues designed to be readable and non-intrusive

Voice/dialogue:
- No voice acting or dialogue pipeline in current scope

Aesthetic goals:
- Easy to Learn: clear visual hierarchy and obvious feedback
- Fast Progression: satisfying, immediate response to player actions
- Rewarding for Risk: escalating audiovisual tension tied to depth/risk
- Social Flexing: high-visibility rare moments and progression showcases

---

## Technical Specifications

### Performance Requirements

Moonwalk for brainrots targets stable performance on low-end mobile hardware as a primary product requirement.

Frame rate target:
- Minimum target: stable 30 FPS on low-end mobile devices
- Scalable target: higher frame rates on stronger devices when available
- Performance consistency is prioritized over high visual complexity

Resolution support:
- Roblox-standard device-adaptive rendering across mobile and desktop form factors
- UI/readability-first scaling to maintain clarity on smaller screens
- Visual readability prioritized over high-resolution effects

Load times:
- Target playable state in <= 10 seconds under typical mobile/network conditions
- Fast re-entry and short-loop continuity prioritized for repeat session flow

### Platform-Specific Details

Roblox-specific requirements:
- Multiplayer target: 4-8 players per server
- Core online systems: cloud saves, leaderboards, live events
- Input expectations: mobile-first control model, keyboard/mouse and gamepad compatibility through Roblox-supported patterns
- Technical priority: maintain stable loop execution under low-end mobile constraints

### Asset Requirements

Asset requirements are constrained by performance and readability goals.

Art assets:
- Stylized, lightweight 3D assets optimized for low-end mobile performance
- Readability-first visual hierarchy for interactables, rarity signaling, and progression cues
- Controlled VFX density to preserve frame stability during active loops

Audio assets:
- Lightweight music and SFX pipeline aligned with fast loop cadence
- Distinct feedback cues for capture, delivery, rarity/mutation moments, and oxygen urgency
- No voice pipeline in current scope

External assets:
- Mostly in-house asset production
- Selective AI-assisted audio support
- Minimal dependency on third-party/marketplace assets where possible

Technical constraints:
- Low-end mobile support is non-negotiable
- Performance and responsiveness take priority over visual fidelity escalation
- Multiplayer/system features must remain maintainable for a small 3-person team
- Detailed architecture decisions deferred to the architecture workflow after GDD completion

---

## Development Epics

### Epic Structure

### Epic Overview

| # | Epic Name | Scope | Dependencies | Est. Stories |
| --- | --- | --- | --- | --- |
| 1 | Expedition Movement & Navigation | Movement, camera, traversal readability, return-path clarity | None | 5-7 |
| 2 | Capture & Delivery Loop | Capture interactions, carry state, delivery flow, payout trigger | 1 | 5-7 |
| 3 | Oxygen Risk System | Oxygen drain (flat configurable rate), travel-commitment risk, fail/recovery loop | 1, 2 | 4-6 |
| 4 | Base Income Core | Delivery payout rules, passive base income, reward readability | 2, 3 | 4-6 |
| 5 | Upgrade Economy | Upgrade catalog, pricing curves, stat scaling, anti-stall flow | 4 | 5-8 |
| 6 | Rebirth Economy & Meta Reset | Rebirth gates, reset behavior, permanent multipliers, slot growth | 5 | 5-7 |
| 7A | Monetization Infrastructure | Robux store shell, entitlement persistence, purchase restore/rejoin reliability | 4, 5, 6 | 4-6 |
| 7B | Monetization Offers & Tuning | Offer integration and balancing for Collect All, 2x Revenue, 2x Oxygen | 7A, 8A | 5-8 |
| 8A | Content Scaling & Progression Depth | Zone depth scaling, rarity/mutation pacing, retention depth tuning | 3, 5, 6 | 5-8 |
| 8B | Platform Hardening & Live Systems | Low-end mobile perf, 4-8 player stability, cloud saves, leaderboards, event hooks | 7B | 6-10 |

### Recommended Sequence

1. Epic 1 -> 2 -> 3 to establish playable risk loop
2. Epic 4 -> 5 -> 6 to stabilize economy and meta progression
3. Epic 8A to provide content depth for monetization and retention testing
4. Epic 7A -> 7B to integrate monetization safely (infra first, tuning second)
5. Epic 8B to harden platform quality and live systems before launch

### Vertical Slice

The first playable milestone is a complete 1-3 minute loop where players move out from base, capture a common Brainrot, manage oxygen pressure, return to deliver, and receive visible progression feedback.

### Go/No-Go Gates

- Gate after Epic 6: rebirth loop proves constant progression (no stuck states)
- Gate after Epic 8A: content depth supports retention tests
- Gate after Epic 7B: monetization does not break core risk/reward loop
- Gate before launch (8B complete): performance, crash, and rejoin quality pass

---

## Success Metrics

### Technical Metrics

Moonwalk for brainrots is considered technically successful when it maintains stable play quality on low-end mobile while supporting core multiplayer and persistence systems.

Key technical KPIs:
| Metric | Target | Measurement Method |
| ------ | ------ | ------------------ |
| Low-end mobile frame rate | >= 30 FPS stable | Runtime performance telemetry + device-tier profiling |
| Initial playable load time | <= 10 seconds | Client load-time instrumentation |
| Crash rate | < 0.5% | Crash reporting pipeline + session-based crash analytics |
| Major launch bugs | 0 open critical blockers | QA triage dashboard + release gate checklist |
| Multiplayer stability | Stable 4-8 player sessions | Server health telemetry, disconnect/error rate tracking |
| Persistence reliability | Cloud save integrity maintained | Save/load success logs + recovery error monitoring |

### Gameplay Metrics

Gameplay success is measured by short-session engagement, retention quality, and progression momentum aligned with the game pillars.

Key gameplay KPIs:
| Metric | Target | Measurement Method |
| ------ | ------ | ------------------ |
| Average session length | 8 minutes | Session analytics (median/mean by cohort) |
| Day-1 retention | 13% | Cohort retention tracking |
| Concurrent users (CCU) | 3,000 | Live concurrency monitoring |
| Conversion rate | 1.5% | Purchase funnel and transaction analytics |
| Early progress clarity | Meaningful progress within first minute | Time-to-first-upgrade / first-value milestone telemetry |
| Anti-stall progression | No repeated same-area farming required for forward progress | Progression path analytics + stagnation/churn point detection |

Qualitative success criteria:
- Players describe the loop as fast, engaging, and rewarding
- Players report feeling successful even in short sessions
- Rare/mutation outcomes generate social flex behavior and sharing momentum
- Community/feedback reflects easy to learn, hard to stop experience
- User sentiment acknowledges polish and readability improvements vs similar titles

Metric review cadence:
- Daily (launch window): crash rate, FPS stability, major bug status, core economy anomalies
- 2-3x weekly (early live): retention, session length, progression stall signals, conversion trends
- Weekly synthesis: KPI trend review mapped against pillars/goals, with tuning actions prioritized by impact
- Per-epic gate reviews: validate go/no-go criteria before advancing to next major milestone

---

## Out of Scope

- No console support at launch (mobile-first release scope)
- No additional maps in v1.0
- No alternate game modes in v1.0

Deferred to post-launch:
- Additional maps/biomes
- Alternate modes or limited-time variants beyond core loop
- Expanded platform support beyond Roblox mobile-first target

---

## Assumptions and Dependencies

### Key Assumptions

- The 3-person full-time team capacity remains stable through delivery.
- Brainrots-style market demand remains viable through the launch window.
- Low-end mobile remains the dominant player environment and design anchor.
- Progression model assumptions (constant forward momentum, no dead runs) hold under live data.
- AI-assisted audio workflow remains usable within legal/platform constraints.

### External Dependencies

- Roblox platform services for cloud saves and leaderboard infrastructure.
- Roblox runtime performance characteristics and service uptime consistency.
- Roblox commerce systems for Robux purchase handling and entitlement restore.
- External ad distribution channels (Roblox ads, TikTok) for acquisition strategy.

### Risk Factors

- Trend cooling or faster competitor shipping could reduce growth potential.
- Platform/service instability could impact persistence or live features.
- Monetization offers may require additional tuning to avoid progression distortion.
- Small team bandwidth may constrain iteration speed during live balancing.

### Document Information

**Document:** Moonwalk for brainrots - Game Design Document  
**Version:** 1.0  
**Created:** 2026-02-24  
**Author:** Ivan  
**Status:** Complete

### Change Log

| Version | Date       | Changes              |
| ------- | ---------- | -------------------- |
| 1.0     | 2026-02-24 | Initial GDD complete |
