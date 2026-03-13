# SmartLab Launcher — Production Queue

**Last Updated:** 2026-03-13

---

## ✅ DONE — Design Phase

- [x] Visual concept: 2001: A Space Odyssey HAL panel + Semiotic Standard Cobb border fusion
- [x] Color assignments: SmartToolbox = cobalt `#1A42CC`, CommandDeck = violet `#7B22B0`
- [x] Button (monolith) proportions established — tall portrait rectangle
- [x] Glyph definition locked: square, W÷3 button width, inset 14px L + 14px B, Cobb octagonal border
- [x] Glyph corners = button color (no darken underlay)
- [x] No text inside glyph — pure symbol only
- [x] 3-letter code as dominant typographic element (88px, HAL panel convention)
- [x] Corner meta: SYS·01 top-left, IP:PORT top-right, APPSERV1 bottom-right
- [x] App symbols: STB = 3-shelf rack with drawer pulls, CDK = 4-quadrant grid
- [x] Top/bottom chrome bars with SMARTLAB·LAUNCHER + UTC + infra readout
- [x] Cinematic layout selected: full-bleed dark field, maximum button size, minimal chrome

---

## 🚧 Active Sprint — Implementation

### HTML/CSS Foundation
- [ ] Single-file HTML (index.html) — no build step, no framework
- [ ] CSS variables for button colors, glyph size, margins
- [ ] Responsive: buttons scale to fill viewport height, centered pair
- [ ] Hover state: subtle brightness lift + cursor pointer
- [ ] Click: navigate to IP:PORT in new tab

### Glyph SVG
- [ ] Inline SVG for STB rack symbol (3 shelves + pulls)
- [ ] Inline SVG for CDK quad symbol (4-quadrant grid + micro lines)
- [ ] Cobb octagonal border as SVG polygon (outer 1.8px + inner hairline 0.5px)

### Chrome + Live Data
- [ ] Top bar: SMARTLAB·LAUNCHER left, live UTC clock right (JS setInterval)
- [ ] Bottom bar: APPSERV1 · 192.168.4.148 · N CONTAINERS RUNNING
- [ ] Container count: hardcode for v1, revisit when CommandDeck agent loop is live

### Deployment
- [ ] Add to smartlab-infra docker-compose.yml (nginx static serve)
- [ ] Add nginx route /launcher/ or serve as root
- [ ] GitHub repo: johnmknight/smartlab-launcher
- [ ] GH Actions: build + deploy on push to main

---

## 📋 Backlog

### Design — Background Illustrations
- [ ] Design white line-art illustration for STB button (network/rack diagram, right-biased)
- [ ] Design white line-art illustration for CDK button (representational, right-biased)
- [ ] Layer: color field → illustration (15–20% opacity) → glyph

### Additional Apps — Add buttons as each goes live
- [x] **SmartToolbox** — :8091 — nginx /toolbox/ ✅ live
- [x] **CommandDeck** — :8090 — nginx /deck/ ✅ live
- [x] **ArtemisOps** — :8085 — nginx /artemis/ ✅ live 2026-03-13
- [x] **MarchogSystemsOps** — :8082 — nginx /marchog/ ✅ live 2026-03-13
- [ ] **FindAJob** — :8100 — paused (ghcr.io package visibility — needs docker login or make public)
- [ ] **VirtualCupola2** — port TBD
- [ ] **CaptainMurphys** — :8081
- [ ] **JohnsSpares** — :7700

### Future
- [ ] App status indicators (ONLINE / OFFLINE dot per button, poll /health)
- [ ] Keyboard nav: 1–N keys launch apps
- [ ] nginx path (/artemis/, /marchog/ etc.) as click target rather than direct IP:PORT
