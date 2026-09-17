# Feature Specification: LILO Phase 1 — Core Movement & Light System Prototype

**Feature Branch**: `001-core-prototype`

**Created**: 2026-09-17

**Status**: Draft

**Input**: User description: "Fase 1 — Core Prototype untuk LILO (Lights In, Lights Out), horror survival iOS game. Referensi lengkap: LILO GDD v2 Production Lock. Scope (sesuai GDD Bab 20): satu ruangan kotak sebagai prototype level, tanpa monster, tanpa art asli (placeholder kotak/kapsul), tanpa audio. Player bisa bergerak + sprint via joystick, senter yang menguras battery real-time selama 180 detik dengan 4 light state bertingkat, battery pickup + slot cadangan, tombol aksi context-sensitive, satu pintu, kamera orthographic smooth-follow, karakter 3D di atas background 2D (SK3DNode risk validation), vignette 2D + spotlight 3D menyatu. Semua angka tuning wajib dari satu GameConfig. Definition of Done sesuai GDD Bab 20.3."

## Clarifications

### Session 2026-09-17

- Q: Device iPhone spesifik mana yang jadi baseline minimum buat validasi 60fps di SC-002? → A: iPhone 17 — superseded from the initial iPhone SE (3rd gen) recommendation once the iOS 26 minimum was set: the team is standardizing on iPhone 17 as everyone's development/testing baseline for this iOS 26 cycle, not the lowest-end device in the abstract.
- Q: Should the battery/flashlight charge have a persistent HUD indicator, beyond the diegetic light itself? → A: Yes — a simple bar is sufficient (per GDD Ch. 15.1's "indikator battery + slot cadangan"); see FR-017.
- Q: Minimum iOS deployment target buat project ini? → A: iOS 26, chosen to allow use of newer SpriteKit/Sprite3D and Core Haptics APIs. (Experimenting with iOS 27 preview APIs was also raised — tracked separately; not required for this feature's scope.)
- Q: Battery satu-satunya di test room itu respawn setelah diambil, atau statis (sekali diambil hilang)? → A: Static — it does not respawn once picked up.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Move and Explore the Test Room (Priority: P1)

A player spawns in a single test room and can walk around freely and sprint when they need to move faster, with the camera smoothly keeping them in view, so that the core feel of moving through LILO's world can be validated on a real device before anything else is built on top of it.

**Why this priority**: Every other system in the game (light, battery, interaction, eventually the monster) is experienced through this movement and camera loop. If it doesn't feel right or doesn't run correctly on device, nothing built after it matters.

**Independent Test**: Can be fully tested by placing a player character in the test room with nothing else present and walking/sprinting around it — delivers a working, feelable movement loop entirely on its own.

**Acceptance Scenarios**:

1. **Given** the player is idle at the spawn point, **When** the player pushes the joystick partway in any direction, **Then** the character walks in that direction at base speed and the camera smoothly follows.
2. **Given** the player is walking, **When** the player pushes the joystick to full deflection, **Then** the character moves at sprint speed (1.6× base speed) with no separate control needed to trigger it.
3. **Given** the player moves toward the edge of the room, **When** the character approaches the room boundary, **Then** the camera stops panning further so the player never sees empty space beyond the level.

---

### User Story 2 - Experience the Flashlight Running Down (Priority: P1)

A player carries a flashlight that drains in real time, and can tell — purely by looking at it — how much charge is left through four visibly distinct states, so the tension at the heart of "Lights In, Lights Out" is provable before any other system is added.

**Why this priority**: The light/battery system is the game's core mechanic, not a supporting feature — the GDD's own title refers to it directly. It must be validated as early and in isolation as movement.

**Independent Test**: Can be fully tested by starting with a fully charged flashlight and letting time pass without touching any pickup — delivers an observable, self-contained light-decay experience.

**Acceptance Scenarios**:

1. **Given** the flashlight is freshly installed at 100% charge, **When** no battery is swapped in, **Then** the charge depletes continuously in real time and reaches 0% at exactly 180 seconds.
2. **Given** the flashlight charge drops below 30%, **When** the player observes the light, **Then** it visibly flickers, signalling the Flickering state.
3. **Given** the flashlight charge drops below 10%, **When** the player observes the light, **Then** its radius visibly narrows, signalling the Critical state.
4. **Given** the flashlight charge reaches 0%, **When** the player continues playing, **Then** the light shrinks to a small fixed radius (Compact Darkness) and the player can still move and act — the game does not end.
5. **Given** the player is standing still or hiding-equivalent idle, **When** time passes, **Then** the charge drains at the same rate as while moving.

---

### User Story 3 - Recover a Spare Battery Before Running Out (Priority: P2)

A player finds a loose battery in the room, picks it up, and swaps it into the flashlight to refill it, so the resource-management decision at the center of the game can be tested independently of movement polish or light-state tuning.

**Why this priority**: This depends on User Story 2 existing (a battery to manage) but is a distinct, separately testable interaction loop — pickup, carry, install — that can be validated once the light system works.

**Independent Test**: Can be fully tested by spawning a player near a single battery item, walking up to it, and using the action button to pick it up and later install it — delivers a complete pickup-and-refill loop.

**Acceptance Scenarios**:

1. **Given** the player is near a battery lying in the room, **When** the player presses the context-sensitive action button, **Then** the battery is picked up into the spare slot and disappears from the world.
2. **Given** the player is carrying a spare battery, **When** the player presses the action button to install it, **Then** the flashlight's charge is set to exactly 100% and the previously installed battery's remaining charge is discarded.
3. **Given** the player already has an installed battery and a full spare slot, **When** the player tries to pick up another battery, **Then** the pickup is rejected, the battery remains in the world, and the player is shown clear feedback explaining why it couldn't be picked up.

---

### User Story 4 - Reach the Exit (Priority: P3)

A player locates the room's single door and opens it using the same action button used for every other interaction, completing the smallest possible full loop through the prototype.

**Why this priority**: This closes the loop end-to-end but depends on nothing new being built — it reuses the same interaction button as User Stories 2 and 3, so it's the lowest-risk, lowest-priority piece to validate last.

**Independent Test**: Can be fully tested by walking a player character to the door and pressing the action button — delivers a demonstrable "start to finish" run through the prototype room.

**Acceptance Scenarios**:

1. **Given** the player is near the door, **When** the player presses the context-sensitive action button, **Then** the door opens with clear feedback that it succeeded.
2. **Given** the player is not near any interactable object, **When** the player looks at the action button, **Then** it shows no label or prompt.

---

### Edge Cases

- What happens when the flashlight reaches exactly 0% while the player is sprinting? The transition to Compact Darkness MUST occur without interrupting movement or causing an error state.
- What happens when the player tries to pick up a battery while both the installed and spare slots are full? The pickup MUST be rejected with feedback, per User Story 3, Scenario 3 — the item is never silently lost.
- What happens when the player is near the door while carrying a spare battery? The action button MUST reflect whichever interactable is nearest/relevant, not conflate the two prompts.
- What happens if the player sprints directly into the room boundary? The camera MUST stop panning (per US1) while the character's own collision with the wall is handled separately — the character does not pass through geometry.
- What happens if the device is rotated out of landscape? Out of scope for this feature — the app is landscape-only; no portrait behavior is defined.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST let the player move the character in any direction using a virtual joystick control positioned in the left portion of the screen.
- **FR-002**: System MUST let the player sprint at 1.6× walking speed automatically when the joystick is pushed to full deflection, without a separate sprint control.
- **FR-003**: System MUST NOT drain the flashlight's charge any faster while the player is sprinting than while walking or standing still — drain is time-based only.
- **FR-004**: System MUST continuously drain the installed battery's charge in real time such that a fully charged (100%) battery reaches 0% at exactly 180 seconds, regardless of player action.
- **FR-005**: System MUST present four visibly distinct light states driven by remaining charge, with each charge value mapping to exactly one state (boundaries are not shared): Normal is `30% < charge ≤ 100%` (full radius), Flickering is `10% < charge ≤ 30%` (visible flicker), Critical is `0% < charge ≤ 10%` (visibly narrowing radius), and Compact Darkness is `charge = 0%` (radius fixed at roughly 10% of normal). E.g., exactly 30% charge is Flickering, not Normal; exactly 10% charge is Critical, not Flickering.
- **FR-006**: At 0% charge, system MUST keep the player able to move and act normally — reaching Compact Darkness MUST NOT end the session or block input.
- **FR-007**: System MUST let the player pick up a battery item in the room through a single context-sensitive action button that appears when an interactable object is within range.
- **FR-008**: System MUST cap the player's carried batteries at one installed plus one spare; a pickup attempted while both are full MUST be rejected, MUST leave the item in the world, and MUST show the player feedback explaining why.
- **FR-009**: System MUST let the player install the spare battery via the action button, which MUST always set the flashlight's charge to exactly 100% and discard the remaining charge of whatever was previously installed.
- **FR-010**: System MUST let the player open the room's single door via the same context-sensitive action button when standing near it.
- **FR-011**: System MUST update the action button's label/icon to match the nearest interactable object (battery, door) and MUST show no prompt when nothing is in range.
- **FR-012**: System MUST keep the camera centered on the player with smooth, non-instant follow motion, and MUST stop the camera from panning past the test room's boundaries.
- **FR-013**: System MUST keep the player character's apparent position, scale, and grounding on the environment visually consistent while the player moves and the camera follows (no drifting, scaling, or floating artifacts).
- **FR-014**: System MUST let 2D environment elements (e.g., a piece of furniture) visually occlude the player character when that element is positioned in front of the character from the camera's viewpoint.
- **FR-015**: Every tunable numeric value used by this feature's systems (including but not limited to walk speed, sprint multiplier, battery duration, and light-state thresholds — see `contracts/game-config.md` for the authoritative full list) MUST be defined in exactly one configuration source, with no such value hardcoded elsewhere.
- **FR-016**: System MUST NOT respawn the test room's battery once it has been picked up — it remains removed from the world for the rest of the session.
- **FR-017**: System MUST display the installed flashlight's current charge as a persistent bar-style indicator in the HUD, and MUST show whether the spare battery slot is empty or occupied, so the player has an at-a-glance view of both without any menu (per GDD Ch. 15.1's HUD spec; decided in Clarifications above).

### Key Entities

- **Player Character**: The in-scene avatar (Eddie), placeholder-rendered for this phase. Tracks position, movement state, and which battery is currently installed.
- **Battery**: A pickup with a charge level. Exists either lying in the world at a fixed spawn point, installed in the flashlight, or carried as a spare. The room has exactly one loose battery, which does not respawn once collected.
- **Flashlight (Light Source)**: Attached to the player; its visible radius and flicker behavior are driven entirely by the installed battery's charge state, and its charge is additionally mirrored as a persistent HUD bar (FR-017).
- **Door**: The room's single interactable exit object.
- **Test Room**: The fixed, single-room environment containing the player spawn point, one battery, and one door — no other rooms or geometry are in scope.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A first-time player can walk and sprint around the test room on the target iPhone hardware and describe the movement as responsive, with no noticeable camera stutter.
- **SC-002**: The game sustains at least 60 frames per second on an iPhone 17 — the project's baseline target device for this iOS 26 development cycle — during continuous player movement, measured on physical hardware, not a simulator.
- **SC-003**: In an observation test with at least 2 people outside the development team, each person can correctly identify which of the four light states they're currently seeing without being told what to look for.
- **SC-004**: A player can let the flashlight drain from 100% to 0% and keep playing afterward without the game crashing or becoming unresponsive.
- **SC-005**: Every tunable value used in this prototype (speed, drain duration, thresholds) can be changed by editing a single configuration source, with no other file requiring a change.
- **SC-006**: A new player can complete the full loop — spawn, watch the flashlight begin to drain, recover the spare battery, and exit through the door — in under 2 minutes without being given instructions.

## Assumptions

- Per the project's already-locked technical direction (GDD v2 Ch. 11 and the project constitution's platform constraints), the test room's environment is rendered in 2D and the player character in 3D layered above it; this spec's rendering-related requirements (FR-013, FR-014) describe the observable outcome that approach must produce, not a mandated implementation.
- Performance validation (SC-002) is measured on physical iPhone hardware — specifically an iPhone 17, the team's standardized baseline device for this iOS 26 cycle — not the iOS Simulator, per the GDD's own Phase 1 test plan.
- Minimum iOS deployment target is iOS 26, to allow use of newer SpriteKit/Sprite3D and Core Haptics APIs. This resolves the constitution's previously open `TODO(IOS_DEPLOYMENT_TARGET)`.
- All room geometry, the player character, and the battery/door objects are placeholder primitive shapes for this feature — no final art is in scope.
- No audio assets are in scope for this feature; any sound-trigger points needed later are not required to produce actual sound yet.
- No monster/AI behavior, no narrative content (prologue/ending), and no multi-room or procedural level design are in scope — this feature is a single fixed test room only.
- Device orientation is locked to landscape; no portrait-mode behavior is defined or required.
- Exact values for a few parameters (e.g., joystick sprint threshold, interaction radius) are intentionally left to be tuned by feel on-device during this phase rather than fixed in advance, per the source GDD's own open items — FR-015 requires wherever they land to live in the single configuration source, not the specific numbers themselves.

## Related

- [[Index|Specs Vault Index]]
- [[constitution]] — governing principles this spec must comply with
- [[LILO-GDD-v2-Production-Lock]] — Ch. 4, 5, 11–13, 15, 17, 20 cover this feature directly
