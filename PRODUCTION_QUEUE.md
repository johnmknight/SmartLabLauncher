# SmartLabLauncher — PRODUCTION QUEUE

## Status: FINAL APP BUILT ✅

---

## DONE THIS SESSION

### AO Dragon OBJ wireframe fix ✅
- `buildWireframe()` was calling `c.add()` inside `obj.traverse()`, adding new mesh children that traverse then visited → infinite recursion → stack overflow
- Fix: collect meshes into array first with `obj.traverse()`, then loop the array separately to apply wireframe materials
- Dragon OBJ now loads, renders, and rotates correctly on the AO button

---

## DONE THIS SESSION

### index.html — Full Production Launcher ✅
Merged from `index.html` (functional) + `anim-lab.html` (animation lab).

**Boot sequence:**
- First load this session: full CLI boot animation (HAL71 interface, keyboard sounds, end chime)
- sessionStorage flag (`hal71-booted`) — skips animation on page reload, instant button reveal
- [ SKIP ] button available during CLI phase
- CLI fades to black → buttons reveal L→R with soft beep per button
- Glyphs, codes, app names, corner text fade in sequence
- Three.js 3D backgrounds fire after all content visible

**Buttons (production, TST removed):**
- STB — SmartToolbox :8091 (cobalt)
- CDK — CommandDeck :8090 (violet)
- AO  — ArtemisOps  :8085 (teal)
- MSO — MarchogSysOps :8082 (crimson)
- All are `<a>` tags → open in `target="_blank"`, launcher stays open

**Three.js backgrounds:**
- STB: Ammo can wireframe (navy hull, ice-blue edges)
- CDK: Pi rack wireframe (violet hull, lavender edges)
- AO: SpaceX Dragon OBJ (teal hull, ice-blue edges) — loads async via fetch('dragon.obj')
- MSO: Monitor stack with coffee glyph / waveform / bar chart overlays

**Live data:**
- UTC clock (1s interval)
- Status dots (30s poll, HEAD + no-cors)
- Container count (60s poll, CDK /deck/api/containers)
- Keyboard nav 1–4 (first press highlights, second press navigates)
- Offline state: brightness(0.35) + diagonal hatch overlay

**Fonts:**
- Share Tech Mono (chrome, CLI, app names, corners)
- Orbitron 900 (button codes only — 82px)
- Both loaded via Google Fonts (CDN, requires internet on first load)

---

## OPEN — NEXT PRIORITIES

### Critical
- [ ] Self-host Orbitron + Share Tech Mono woff2 in fonts/ for LAN/offline use
- [ ] dragon.obj: nginx must serve from SmartLabLauncher static root at /launcher/dragon.obj
- [ ] Status polling: no-cors opaque responses always look "online" — need CORS /health endpoint per app OR a SmartLab proxy endpoint

### Nice to Have
- [ ] Status dot: pulse animation while polling in-flight
- [ ] Hover: subtle scale(1.02) in addition to brightness
- [ ] Keyboard nav: visual ring more prominent (current: 2px box-shadow)
- [ ] GitHub repo: `johnmknight/smartlab-launcher` — push current state

### Infrastructure
- [ ] nginx: serve SmartLabLauncher at /launcher/ (currently served ad-hoc)
- [ ] App manifest API: GET /deck/api/apps → returns {id, code, name, url, port, color} for dynamic buttons
- [ ] If manifest defined: replace hardcoded buttons with manifest-driven render

---

## FILES

| File | Status |
|------|--------|
| index.html | ✅ FINAL — merged boot animation + functional launcher |
| anim-lab.html | Keep — reference / sandbox |
| font-preview.html | Keep — reference |
| dragon.obj | Present — needs nginx static serving |
| concepts/ | Reference — keep |
