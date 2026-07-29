# Risbacka Game Design Document

## Context
A cozy-yet-tense tower defense game set at a real Swedish homestead (Risbacka skogsväg 8, Härryda) where players defend against nightly wild boar attacks, manage repairs, and establish community relationships. Inspired by MDA framework (Koster), narrative-focused systems (Adams), and player psychology (Shell).

---

## Core Premise & Loop

**Day Cycle (Preparation Phase):**
- Repair home damage from previous night
- Build/upgrade defensive structures
- Gather resources and supplies
- Manage relationships with neighbors
- Plan strategy for incoming night

**Night Cycle (Combat Phase):**
- Defend home from escalating boar waves
- Real-time tower defense gameplay
- Visible consequence of damage to the home
- Resource expenditure under pressure

**Daily Consequence Loop:**
- Clean up dead boars
- Transport meat to neighbor for processing (story progression)
- Observe home degradation if defenses fail
- Weather affects both defense placement and boar behavior

---

## Design Pillars (MDA Framework)

### Mechanics (Rules & Systems)
**Defense System:**
- Fence building (wood → stone → electric)
- Chop marked wood sources with an axe, collect the dropped wood, and deposit it in a shared storage area
- Trap placement (pit, spring, electrified wire)
- Guard post (player controlled or AI-assisted)
- Home reinforcement (walls, doors, shutters)
- Resource conversion (boar meat → money or supplies)

**Damage Model:**
- Home structure integrity (visual/functional decay)
- Incremental wall damage that compounds
- Window boarding system
- Roof damage affects interior during rain
- Visual storytelling through destruction

**Day/Night Cycle:**
- Real-time day/night (adjustable speed)
- Different boar types emerge at different times
- Weather affects visibility and boar aggression
- Time pressure on repairs creates decision-making

**Economic Loop:**
- Money from selling boar meat to neighbor
- Spend on materials (wood, nails, stone, wire)
- Scarcity mechanics force prioritization
- Risk/reward on expensive upgrades

### Dynamics (Emergent Behavior)
**Waves & Escalation:**
- Boar population scales with in-game day count
- Boss encounters (larger, more aggressive boars)
- Seasonal patterns (autumn has more aggressive boars)
- Damage short of total destruction persists into the next day and creates repair pressure
- The run fails if the main base is destroyed or no active player remains alive

**Player Agency Moments:**
- Moral choice: Kill boars or just deter them?
- Resource allocation: Repair home or build offense?
- Community help: Call neighbors for assistance (Bamse, Andreas)
- Risk tolerance: Invest in expensive tech vs. simpler defenses?

**Tension Curve:**
- Early days: Tutorial-like, plenty of time
- Mid-game: Increasing pressure, harder choices
- Late-game: Home becomes character (aesthetic decay)
- Optional: "Endless" mode for high scores

### Aesthetics (Emotional Response)
**Tone: Cozy-Horror**
- Swedish rural beauty juxtaposed with threat
- Humor through absurdity (boars are destructive but not evil)
- Pride in home defense (home becomes extension of self)
- Community warmth (neighbors are allies, not threats)

**Themes (Koster's Approach):**
- **Survival:** Can you protect what matters?
- **Preparation:** Planning beats reactivity
- **Community:** You're not alone (neighbors help)
- **Consequences:** Failure is costly but not fatal (teaches systems thinking)

---

## World Design

**Location: Risbacka (Real Swedish Homestead)**
- Main house (main structure to defend)
- Tool shed (resource storage)
- Neighbor Bamse's compound (safe zone for meat processing)
- Neighbor Andreas's house (beer Easter egg location)
- Surrounding forest (boar spawn points)
- Fields (where boars emerge from)

**Environmental Storytelling:**
- Home becomes increasingly worn (visible damage)
- Defensive improvements accumulate over time
- Seasonal changes (autumn = boar season peak)
- Photos/items on walls showing memories at stake

---

## Neighbor Relationships (Narrative Mechanics)

**Bamse (Primary Neighbor):**
- **Role:** Meat processor and economic hub
- **Mechanic:** Trade boar meat for money/supplies
- **Story Arc:** Builds relationship over time
- **Quest Hook:** "Help me protect the area" → optional cooperative mode

**Andreas (Easter Egg Neighbor):**
- **Role:** Beer supplier for morale/energy boost
- **Mechanic:** Special resource that increases work speed or morale temporarily
- **Unlock:** Random visits, or triggered by low morale
- **Flavor:** Swedish beer culture ("En stark öl" = a strong beer)
- **Hidden Benefit:** His company at night slightly increases boar deterrence

---

## Mechanics in Detail

### Defense Building (Tower Defense Elements)

**Fence Tiers:**
1. **Wooden Fence** (Fast, cheap, breakable)
   - Cost: 50 wood
   - HP: Low
   - Effect: Slows boars, can be destroyed

2. **Stone Wall** (Durable, expensive, permanent)
   - Cost: 150 stone + 100 wood
   - HP: Very High
   - Effect: Blocks boars completely

3. **Electric Fence** (Expensive, powerful, limited range)
   - Cost: 200 wire + 50 copper
   - HP: Medium
   - Effect: Damages boars on contact, audio deterrent

**Trap Placement:**
- Pit traps: Boars fall in (recover after time)
- Spring traps: Direct damage
- Electrified wire: Damage + stun

**Home Reinforcement:**
- Board windows (blocks visibility but adds defense)
- Reinforce doors
- Repair walls (visual indicator of damage)
- Build watchtower (player post, range advantage)

### Combat System (Real-Time)

**Player Actions (During Night):**
- Move around the home with an axe used for both chopping wood and fighting boars
- Aim and strike at boars
- Activate traps manually
- Call for help (cooldown-based, Bamse or Andreas)
- Retreat to safe room if overwhelmed

**Boar AI:**
- Seek gaps in defense
- Target damage points
- Pack behavior (stronger in groups)
- Different species (young aggressive, old tough, alpha leaders)

**Resource Drain:**
- Each action costs stamina/focus
- Fatigue increases mistakes
- Coffee from Andreas temporarily restores stamina
- "Escape to bed" option (surrender wave, pay reputation cost)

### Day Management (Resource Strategy)

**Tasks Available Each Day:**
1. **Cleanup** (Required)
   - Collect dead boars (mini-game: dragging/loading)
   - Transport to Bamse (travel phase)
   - Receive payment

2. **Repair** (Priority)
   - Visible damage must be addressed
   - Morale decreases if home falls apart
   - Some repairs are permanent, others temporary

3. **Build** (Strategic)
   - Requires planning and resources
   - Can only place where damage permits
   - Takes time (can be interrupted)

4. **Gather** (Optional)
   - Chop marked wood sources with the axe
   - Collect and carry dropped wood pickups
   - Deposit wood in the shared storage area for building and repairs
   - Scavenge the forest for other resources later in progression
   - Risk/reward (might encounter stray boar)

5. **Rest** (Necessary)
   - Restore energy for night
   - Morale recovery
   - Option to skip (costly consequences)

### Time Management

**Full Cycle:**
- One complete cycle represents 24 in-game hours
- Day runs from 6am to 6pm (12 in-game hours)
- Night runs from 6pm to 6am (12 in-game hours)
- Phase 1 uses a 3-minute preparation day and a 5-minute defense night
- Real-time durations remain tunable for later balancing

**Day Cycle (12 in-game hours / 3 real minutes in Phase 1):**
- 6-8am: Morning cleanup and repairs (focus on speed)
- 8am-12pm: Main building/resource gathering
- 12pm-3pm: Travel and trading (Bamse's house)
- 3pm-6pm: Final preparations and rest

**Night Cycle (12 in-game hours / 5 real minutes in Phase 1):**
- 6pm-8pm: Early waves (easy)
- 8pm-12am: Mid waves (harder)
- 12am-4am: Peak waves (boss encounters)
- 4am-6am: Retreat phase (last survivors, prepare for dawn)

---

## Progression & Escalation

**Difficulty Curve:**
- Day 1-3: Tutorial, single boar types
- Day 4-7: Increasing numbers, mixed types
- Day 8-14: Boss encounters introduced
- Day 15+: Endless scaling or narrative climax

**Unlock System:**
- Better defenses unlock through progression
- Neighbor events trigger at story points
- Easter eggs unlock based on choices/time

**Victory Conditions:**
- **Soft Victory:** Survive 30 days
- **True Victory:** Protect home AND restore relationship with community
- **Hidden Victory:** Befriend the alpha boar (Easter egg)

---

## Jesse Shell's 12 Elements (Player Psychology)

1. **Tetris Effect** - Learning defense patterns becomes automatic
2. **Aesthetic** - Beautiful home degradation creates emotional weight
3. **Expectation** - Wave patterns teach prediction
4. **Reward** - Successful defense = visible home preservation
5. **Intensity** - Night combat spikes, day eases tension
6. **Risk** - Expensive defenses vs. cheap alternatives
7. **Comfort** - Safe zone during day, sanctuary feeling at home
8. **Fun** - Absurdity of boar attacks contrasts with stakes
9. **Story** - Neighbors, home history, ecosystem narrative
10. **Exploration** - Andreas's beer, hidden tactics, Easter eggs
11. **Collection** - Boar trophy system, defense variety
12. **Performance** - Leaderboard: survived days, minimal damage, efficiency

---

## Tone & Writing (Adams' Narrative Approach)

**Voice:** Humble, practical, slightly deadpan Swedish humor
- Bamse's pragmatism: "Boars will be boars. Meat is meat."
- Andreas's optimism: "More beer than sense, but both help."
- Your character: Internal monologue reflecting on rural life

**No Melodrama:** Focus on systems, not tragedy
- Home damage is mechanical problem, not emotional trauma
- Boars are pests, not villains
- Community works together (no betrayal arcs)

**Easter Eggs (Rewards Curiosity):**
- Andreas's shed contains absurd amounts of beer
- Photos of the real people at this address (breaking fourth wall gently)
- Boar behavior patterns hint at deeper ecosystem
- Secret location: "The Old Hunting Cabin" with mysterious history

---

## Implementation Roadmap

**Phase 1: Core Loop**
- Placeholder boar spawning and objective-focused pathfinding
- Wood gathering, shared storage, and simple fence placement
- Day/night cycle and shared-camera local co-op
- Basic wave system

**Phase 2: Home & Damage**
- Home structure integrity visualization
- Repair system integration
- Cleanup mechanics (resource collection)

**Phase 3: NPC & Economy**
- Neighbor NPCs (Bamse, Andreas)
- Trading system
- Morale/energy tracking

**Phase 4: Polish & Easter Eggs**
- Integrate the selected Fab boar models, physics assets, and slapstick ragdolls
- Seasonal weather effects
- Audio/ambient systems
- Hidden events and Easter eggs
- Leaderboard/progression tracking

Detailed module architecture, public contracts, and quality gates live in
[Architecture/README.md](Architecture/README.md). High-level asset targets and Unreal
workflow notes live in
[Docs/Implementation-Plan.md](Docs/Implementation-Plan.md). Executable feature work,
dependencies, and current status live in [Tasks/README.md](Tasks/README.md).

---

## Success Metrics (How We Know It Works)

✓ Players feel increasing tension through night cycle  
✓ Day management creates meaningful decisions  
✓ Home becomes emotionally significant (visual decay)  
✓ Neighbors feel like allies, not NPCs  
✓ Failure teaches systems thinking, not feels unfair  
✓ Easter eggs reward exploration (Andreas's beer quest)  
✓ 30+ minutes per session (cozy game pacing)  
✓ Replayability through difficulty scaling  

---

## Scope Decisions (Confirmed)

- ✓ **Mode:** Local Co-op (2 players)
- ✓ **Camera:** Shared view of the complete active playing area
- ✓ **Tone:** Comedy-first with slapstick physics
- ✓ **Start:** Core loop (day/night + simple defense)

### Implications:
- Both players remain visible in one shared, high-angle gameplay view
- Neighbor homes do not need to fit inside the Phase 1 playing area
- How distant neighbor interactions work remains a later design decision
- Final boar models and exaggerated ragdoll physics arrive after Phase 1
- Phase 1 economy is limited to wood pickups, shared storage, and wooden defenses
- Two-player coordination becomes strategic layer

---

## Phase 1 Implementation Plan (Core Loop)

### Deliverables:
1. **Day/Night Cycle Manager**
   - 24 in-game hours per full cycle
   - 3-minute preparation day followed by a 5-minute defense night
   - UI shows time, events, and tasks
   - Transitions with audio/visual cues

2. **Boar Spawning & Wave System**
   - 3 difficulty tiers (easy, medium, hard)
   - Placeholder enemy presentation until the Fab animal models are integrated
   - Simple AI (walk toward home, break things)

3. **Wood Gathering & Shared Storage**
   - Chop marked wood sources with the axe
   - Collect physical wood pickups
   - Carry and drop wood inside a designated storage area
   - Convert deposited pickups into a shared wood stockpile

4. **Defense Placement (Simple Version)**
   - Place one wooden fence type
   - Spend wood from the shared storage stockpile
   - Player collision detection

5. **Home Structure**
   - Visible damage model (temporary for phase 1)
   - Simple "gates" that boars breach
   - Health bar or visual indicator

6. **Two-Player Controls & Shared Camera**
   - Two locally controlled player characters
   - One camera frames the complete active playing area
   - Shared responsibility for gathering, building, and defense
   - Rally point (regroup mechanic)

7. **Failure Conditions**
   - Main base destruction immediately fails the run
   - Player death fails single-player
   - The death of both players fails local co-op

### Success Criteria (Phase 1):
- Players can complete a 3-minute day and 5-minute night
- Players can chop, carry, deposit, and spend wood
- Playable 5-minute night cycle
- 2 players share one camera, cooperatively build 1 fence, and defend it
- Boars pathfind and damage home
- Player/base failure conditions end the run cleanly
- Can complete 1 full day/night cycle without crash

### Not in Phase 1:
- NPC dialogue or visits (Bamse, Andreas)
- Distant-neighbor travel/interaction flow
- Economy beyond the shared wood loop
- Cleanup mechanics
- Weather effects
- Easter eggs
- Final Fab boar models and slapstick ragdoll polish
