# Contract: GameConfig

The single tunables source required by spec FR-015. Every value a system (`MovementController`,
`BatteryController`, `CameraController`) reads MUST come from here — none hardcoded at the call
site. Values below are sourced from GDD Ch. 17.1/17.2 and this feature's Clarifications; a
`TBD` value means the GDD explicitly defers it to on-device tuning during this same phase (spec
Assumptions) — the *key* must still exist and be read from `GameConfig`, only the *number* is
pending.

| Key | Type | Default | Source / Notes |
|---|---|---|---|
| `walkSpeed` | `Double` | `1.0` | base unit, GDD 17.1 |
| `sprintMultiplier` | `Double` | `1.6` | × walkSpeed, GDD 17.1 |
| `sprintJoystickThreshold` | `Double` (0–1 deflection) | `TBD` | tuned on-device, spec Assumptions |
| `interactionRadius` | `Double` (world units) | `TBD` | tuned on-device, spec Assumptions |
| `batteryDuration` | `Double` (seconds) | `180` | GDD 17.2, spec FR-004 |
| `lightStateFlickerStart` | `Double` (fraction of duration) | `0.30` | GDD 17.2, spec FR-005 |
| `lightStateCriticalStart` | `Double` (fraction of duration) | `0.10` | GDD 17.2, spec FR-005 |
| `compactDarknessRadiusFraction` | `Double` | `0.10` | ~10% of normal radius, GDD 17.2 / spec FR-006 |
| `cameraFollowLerpFactor` | `Double` (0–1 per frame-normalized step) | `TBD` | needed for FR-012's "smooth, non-instant" requirement; not numerically specified by GDD, tune on-device |
| `roomBoundsInset` | `Double` | `TBD` | camera clamp inset from room edge, FR-012 |

## Non-negotiable shape rules

- One source file (`Game/GameConfig.swift`), no duplicate constants elsewhere (FR-015).
- `TBD` keys MUST still be present with a placeholder value (not omitted) so every system can be
  wired up against the final shape before on-device tuning happens — only the *value* changes
  later, not which system reads from where.
