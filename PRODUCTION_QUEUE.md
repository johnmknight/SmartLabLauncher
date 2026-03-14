# SmartLabLauncher — PRODUCTION QUEUE

## Status: FINAL APP BUILT ✅

---

## DONE THIS SESSION

### AO Dragon OBJ wireframe fix ✅
- `buildWireframe()` was calling `c.add()` inside `obj.traverse()` → infinite
  recursion → stack overflow
- Fix: collect meshes into array first, then process separately

### Dynamic app rendering from CommandDeck API ✅
- Launcher fetches `GET /deck/api/apps` on boot — all buttons, CLI lines, glyphs,
  and backgrounds built from response
- `createButton(app, index)` factory generates monolith HTML per app
- CLI animation driven by APPS array (no more hardcoded CLI_APPS)
- Legacy glyphs preserved as LEGACY_GLYPHS lookup (used when glyph_svg is null)
- Legacy Three.js backgrounds preserved as LEGACY_BG lookup (used when bg_js is null)
- Keyboard nav adapts to dynamic app count (1..N)
- Status polling uses route_path from API
- Error state shown in CLI area if API unreachable
- Removed: all hardcoded button HTML, CLI_APPS, APP_MANIFEST, per-app CSS color vars

### CommandDeck API additions ✅ (in CommandDeck repo)
- `migrate_db()`: adds route_path, glyph_svg, bg_js, is_deployed, sort_order columns
- Inserts SmartToolbox + CommandDeck as projects (missing from original seed)
- Sets launcher palette colors and correct ports for all 4 deployed apps
- `GET /api/apps`: returns `{ app_server_url, apps[] }` ordered by sort_order
- `PATCH /api/projects/{pid}`: supports all fields including new launcher columns
- `APP_SERVER_URL` env var via python-dotenv — no hardcoded IPs in launcher
- `.env.example` and `smartlab-infra/.env.commanddeck.example` updated

### Button URL fix ✅
- All button hrefs built from `app_server_url + route_path` (from API)
- Status polling and container count also use `app_server_url`
- No hardcoded IPs anywhere in the launcher — CommandDeck is single source of truth
- `CDK_BASE` handles local dev API access (localhost:8090) vs production (nginx /deck/)

---

## PRIOR SESSION

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
- [x] App manifest API: GET /deck/api/apps ✅ — built and tested
- [x] Replace hardcoded buttons with manifest-driven render ✅

---

## FILES

| File | Status |
|------|--------|
| index.html | ✅ Dynamic — fetches apps from CommandDeck API |
| anim-lab.html | Keep — reference / sandbox |
| font-preview.html | Keep — reference |
| dragon.obj | Present — needs nginx static serving |
| concepts/ | Reference — keep |
| DESIGN_DYNAMIC_LAUNCHER.md | ✅ Architecture + design doc |
