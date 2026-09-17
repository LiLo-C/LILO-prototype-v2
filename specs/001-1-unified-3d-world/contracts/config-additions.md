# Contract: GameConfig Additions (001-1)

These keys are **added** to the single tunables source defined by 001 FR-015 and documented in
[001's `contracts/game-config.md`](../../001-core-prototype/contracts/game-config.md) — they do
not create a second config source (spec FR-021). `GameConfig.swift` gets one new `extension` /
`enum` section for this feature's keys; every system listed under "Reads" MUST read from here,
none hardcoded at the call site.

| Key | Type | Default | Source / Notes | Reads |
|---|---|---|---|---|
| `flashlightNormalRadius` | `Double` (world units) | `TBD` | Normal-state lit radius; small enough that darkness is visible on all four landscape screen edges (FR-004). Tuned on-device — same "tune by feel, key must still exist" rule 001 used for its own `TBD`s. | `LightingController` |
| `flashlightCriticalMinRadius` | `Double` (world units) | `TBD` | Lit radius at the bottom of Critical / Compact Darkness's base before the `compactDarknessRadiusFraction` multiply (FR-005). Must be `< flashlightNormalRadius`. | `LightingController` |
| `lightRadiusEaseRate` | `Double` (1/s, exponential ease rate) | `TBD` | How fast the displayed radius chases its target (FR-005). Ported technique from the LILO spike's `radiusEaseRate` (spike default `5`); numeric value re-tuned on-device for this room's scale. | `LightingController` |
| `flickerIntervalMin` | `Double` (seconds) | `TBD` | Shortest gap between flicker dip events while in Flickering (FR-006). | `LightingController` |
| `flickerIntervalMax` | `Double` (seconds) | `TBD` | Longest gap between flicker dip events (FR-006). Must be `≥ flickerIntervalMin`. | `LightingController` |
| `flickerEventDuration` | `Double` (seconds) | `TBD` | How long one dip event lasts, start to recovery (FR-006). | `LightingController` |
| `flickerDipFraction` | `Double` (0–1) | `TBD` | How far the lit radius/intensity dips during an event, as a fraction of the Flickering-state target (FR-006). `0` = no visible dip, `1` = dips to nothing. | `LightingController` |
| `readabilityFillIntensity` | `Double` (SceneKit ambient light intensity units) | `TBD` | The single tunable controlling out-of-flashlight readability (FR-007). `0` MUST produce pure black outside the lit radius (User Story 3 Scenario 2). | `LightingController` |
| `cameraTiltDegrees` | `Double` | `45` | Already existed as `TBD` in 001's contract; this spec supplies the default per GDD 13 (FR-012). | `CameraController` |
| `cameraOrthographicScale` | `Double` | `TBD` | Already existed as `TBD` in 001's contract; still tuned on-device here — fixed zoom, no dynamic zoom (FR-012). | `CameraController` |
| `cameraDistance` | `Double` (world units) | `TBD` | How far back along the tilt axis the camera sits (needed for an orthographic rig; irrelevant to the visible framing but must not clip room geometry). Ported concept from the LILO spike's `cameraDistance`. | `CameraController` |
| `shadowsEnabled` | `Bool` | `true` | Performance fallback switch (FR-022). Setting `false` disables `SCNLight.castsShadow` with no other code change. | `LightingController` |
| `shadowMapSize` | `Int` (pixels, square) | `TBD` | Shadow map resolution; lower value is the "reduced quality" half of FR-022's fallback. | `LightingController` |
| `shadowSampleCount` | `Int` | `TBD` | Shadow softness sample count; lower value trades softness for performance, same fallback as above. | `LightingController` |
| `highlightColor` | color (RGB) | `TBD` | The one color used for both highlight intensity levels (FR-013). | `HighlightController` |
| `highlightOutOfRangeIntensity` | `Double` (0–1, emission intensity) | `TBD` | Faint level, visible in every light state including Compact Darkness (FR-013). Must be `> 0` (never invisible) and `< highlightInRangeIntensity`. | `HighlightController` |
| `highlightInRangeIntensity` | `Double` (0–1, emission intensity) | `TBD` | Clearly stronger level shown while an object is within interaction range (FR-013). | `HighlightController` |
| `wallHeight` | `Double` (world units) | `TBD` | Wall/desk solid height (FR-011). Trades shadow reach against how much of the room the walls hide, same tension the LILO spike documents for its own `wallHeightOptions`. | `SceneNodeFactory` |
| `maxFrameDelta` | `Double` (seconds) | `TBD` | Clamp on one frame's delta time, applied to movement/light-easing/flicker/camera alike (FR-015). Ported concept from the LILO spike's `1.0 / 20` clamp; numeric value re-validated for this project. | `MovementController`, `LightingController`, `CameraController` |
| `batteryPickupAnimationDuration` | `Double` (seconds) | `TBD` | How long a picked-up battery's grow/fade-out animation takes (FR-016). | battery pickup handling (wherever 001-1's task work lands this — see plan.md `Systems`/scene layer) |
| `doorOpenAnimationDuration` | `Double` (seconds) | `TBD` | How long the door's closed→open animation takes (FR-017). | door-open handling |
| `joystickControlZoneWidthFraction` | `Double` (0–1, fraction of screen width) | `TBD` | Width of the left-side zone a touch may start in to spawn the floating joystick (FR-019). Replaces 001's never-numerically-supplied fixed `joystickCenterOffset`. | `JoystickView` |
| `joystickControlZoneHeightFraction` | `Double` (0–1, fraction of screen height) | `TBD` | Height of the same zone. | `JoystickView` |

## Keys explicitly *not* added

- `joystickDiameter`, `joystickDeadZone`, `joystickOpacity`, `actionButtonSize`,
  `actionButtonCenterOffset`, `actionButtonTouchRadius` — already exist in 001's contract and are
  unaffected by this spec; the joystick becomes floating (a new *zone*, above) but its own base
  size/opacity/dead-zone are unchanged.
- A `characterRenderMode` switch — out of scope for 001-1 (see spec.md "Impact on Other Specs");
  015 owns that decision.

## Non-negotiable shape rules

- Same rules as 001's contract: one source file, `TBD` keys present with a placeholder value (not
  omitted) so every system is wired up before on-device tuning happens, later specs never create
  a second config source.
