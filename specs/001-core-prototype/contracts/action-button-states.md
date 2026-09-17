# Contract: Context-Sensitive Action Button

The single right-side action button (FR-007, FR-009, FR-010, FR-011) exposes exactly one active
state at a time, chosen by nearest in-range interactable. Scope for this phase only covers the
three interactables that exist in the test room.

| Nearest interactable | Button shows | On press | Notes |
|---|---|---|---|
| None in range | Hidden / no label | — | FR-011 |
| `worldBattery` (still `.world`) | "Pick up" | `worldBattery → .spare` if `spareBattery == nil`; otherwise rejected with feedback (FR-008) | pickup feedback per spec Edge Cases |
| Player has a `spareBattery` and is not near the door | "Install battery" | `spareBattery → .installed`, discard old `installedBattery`, `charge = 180` | available regardless of current installed charge — no "must be low" gate (see spec Assumptions) |
| `door` (`isOpen == false`) | "Open door" | `door.isOpen = true` | one-way; no state after this to represent re-closing |

## Priority rule when multiple interactables are in range

If both a battery-related action and the door are simultaneously in range (edge case from spec),
the nearer object by distance wins. This is a UI/UX tie-break, not a new functional requirement —
recorded here so it isn't decided ad hoc during implementation.
