# concepts/

Background illustration candidates for the AO (ArtemisOps) launcher button.

**Aesthetic:** White line-art on dark field, ~15–20% opacity when composited into button.
**Reference:** HAL 9000 screen graphics from 2001: A Space Odyssey.
**Usage:** Right-biased within the 380px button — glyph occupies bottom-left, illustration fills right half.

## Candidates

| File | Description |
|------|-------------|
| `ao-01-orbital-path.svg` | Concentric ellipses, central planet, spacecraft dot with apogee/perigee ticks |
| `ao-02-launch-trajectory.svg` | Parabolic ascent arc, staging event markers, altitude drop lines |
| `ao-03-station-schematic.svg` | ISS top-view: main truss, solar arrays, habitat modules, nadir port |
| `ao-04-telemetry-curve.svg` | Exponential decay graph with axes, grid, and dashed secondary curve |
| `ao-05-earth-limb.svg` | Planet curvature, atmosphere band, dashed orbit arc, surface-to-orbit radials |
| `ao-06-mission-timeline.svg` | Vertical spine with alternating milestone branches and endpoint dots |
| `ao-07-ground-track.svg` | Sinusoidal orbital trace over lat/lon map grid, current position dot |
| `ao-08-crew-vitals.svg` | Three-channel biometric waveforms: ECG, respiration, blood pressure |

## Status

- [ ] Select 1 direction (or hybrid)
- [ ] Scale and position for 380×470px button at correct opacity
- [ ] Implement as inline SVG in `index.html` AO button
- [ ] Validate against full 4-button layout
- [ ] Apply illustration pattern to STB, CDK, MSO buttons
