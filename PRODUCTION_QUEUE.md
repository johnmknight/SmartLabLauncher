# SmartLab Launcher — Production Queue

**Last Updated:** 2026-03-13

---

## ✅ DONE — Design Phase

- [x] Visual concept: 2001: A Space Odyssey HAL panel + Semiotic Standard Cobb border fusion
- [x] Color assignments per app
- [x] Button (monolith) proportions: tall portrait rectangle, now doubled to 380px wide
- [x] Glyph definition locked: square W÷3, inset 14px L+B, Cobb octagonal border, no text
- [x] 3-letter code as dominant typographic element (~88px)
- [x] Corner meta: SYS·01 / IP:PORT / APPSERV1
- [x] Top/bottom chrome bars with SMARTLAB·LAUNCHER + UTC + infra readout
- [x] 4 buttons implemented: STB, CDK, AO, MSO — all synced to nginx routes
- [x] Font corrected to Orbitron (Eurostile Bold Extended / HAL 9000 reference)
- [x] Button width doubled: 190px → 380px (right half reserved for background illustration)
- [x] AO selected as design template for illustration aesthetic

---

## 🚧 Active Sprint — AO Button Illustration

- [ ] Review 8-panel concept board (orbital paths, trajectories, ISS schematic, telemetry, etc.)
- [ ] Select 1 illustration direction
- [ ] Implement as inline SVG inside AO button at ~15–20% opacity, right-biased
- [ ] Validate against full 4-button layout
- [ ] Apply illustration pattern to STB, CDK, MSO

---

## 🚧 Next Up — Font Deployment

- [ ] Download Orbitron woff2 (regular 400, bold 700, black 900) from Google Fonts
- [ ] Add to repo: `fonts/orbitron-*.woff2`
- [ ] Replace `<link href="https://fonts.googleapis.com/...">` with local `@font-face`
- [ ] Test offline on appserv1 nginx

---

## 📋 Backlog

### Additional Apps — when they go live
- [x] SmartToolbox — :8091 — nginx /toolbox/ ✅
- [x] CommandDeck — :8090 — nginx /deck/ ✅
- [x] ArtemisOps — :8085 — nginx /artemis/ ✅
- [x] MarchogSystemsOps — :8082 — nginx /marchog/ ✅
- [ ] FindAJob — :8100 — excluded (no nginx route; parked)
- [ ] VirtualCupola2 — port TBD
- [ ] CaptainMurphys — :8081
- [ ] JohnsSpares — :7700

### Future UX
- [ ] App status dots (ONLINE/OFFLINE) — poll /health per button
- [ ] Keyboard nav: 1–4 keys to launch apps
- [ ] Live container count — dependency: CommandDeck agent loop
- [ ] App name decision: SMARTTOOLBOX vs SMART RACK OPS
