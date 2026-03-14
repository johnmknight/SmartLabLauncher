# OPEN ISSUES — SmartLab Launcher

**Last Updated:** 2026-03-13

---

## ✅ Resolved This Session

- [x] **Font** — Changed from `'Courier New', monospace` to `'Orbitron'` (Google Fonts)
  - Orbitron is the closest freely available match to Eurostile Bold Extended (the HAL 9000 panel typeface)
  - NOTE: Self-host woff2 files in repo for offline/LAN use — Google Fonts CDN unavailable on isolated network
  - Apply to: all chrome bars, corner meta, code, app-name, everywhere `--font` is used

- [x] **Button width** — Doubled from `190px` → `380px`
  - Extra canvas on the right side is reserved for background illustration
  - Glyph and code remain left/center anchored — no repositioning needed

- [x] **AO button selected as design template** — all aesthetic decisions validated here first before applying to STB, CDK, MSO

---

## 🟡 Design Decisions Pending

- [ ] **App name for SmartToolbox button**
  - Currently: `SMARTTOOLBOX` / code `STB`
  - Candidate: `SMART RACK OPS` / code `SRO`
  - Resolve before deploy

- [ ] **Background illustrations — AO in progress**
  - Aesthetic: white line-art at ~15–20% opacity, right-biased, 2001 HAL panel style
  - Reference: 2001 A Space Odyssey HAL 9000 screen graphics (orbital diagrams, graph curves)
  - AO concept board: 8 candidate illustrations under review (orbital paths, trajectories, telemetry, ISS schematic, etc.)
  - Once AO illustration selected → apply pattern to STB, CDK, MSO

- [ ] **Self-host Orbitron font**
  - Download woff2 from Google Fonts
  - Add to repo under `fonts/`
  - Replace Google Fonts `<link>` with local `@font-face`

---

## 🔵 Architecture / Integration

- [ ] **Live container count in bottom chrome**
  - Currently hardcoded: `4 CONTAINERS RUNNING` (accurate for app containers: STB, CDK, AO, MSO)
  - Full compose stack is 6 services (+ mosquitto + nginx)
  - Revisit when CommandDeck agent loop is live

- [ ] **App status indicators (ONLINE/OFFLINE)**
  - Poll each app's `/health` endpoint from browser JS
  - Or proxy through CommandDeck once agent loop is built
  - Dependency: CommandDeck `agent.py`

---

## 📋 Session Notes

### 2026-03-13 (session 1)
- Project created from design-phase concept work
- Full design language established: 2001 + Semiotic Standard fusion
- Glyph geometry locked: square W÷3, inset 14px L+B, Cobb octagonal border, no text, corners = button color
- Typography: 3-letter code dominant at ~88px, full name below, wide letter-spacing
- Corner meta: SYS·01 / IP:PORT / APPSERV1
- Colors: STB cobalt `#1A42CC`, CDK violet `#7B22B0`, AO steel `#1A5C8A`, MSO crimson `#8A1A1A`
- Background `#07070F`, top/bottom chrome bars
- Initial 4 buttons implemented: STB, CDK, AO, MSO

### 2026-03-13 (session 2)
- Confirmed active apps from docker-compose: STB :8091, CDK :8090, AO :8085, MSO :8082
- FAJ (FindAJob :8100) excluded — no nginx route, parked
- Font corrected: Courier New → Orbitron (Eurostile Bold Extended reference)
- Button width doubled: 190px → 380px
- AO selected as design template button
- Background illustration direction established: 2001 HAL panel white line-art aesthetic
- 8-panel concept board created for AO illustration candidates
