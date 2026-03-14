# SmartLabLauncher — PRODUCTION QUEUE

## Status: Animation lab complete. Wiring phase next.

---

## DONE THIS SESSION

### index.html — Functional Launcher ✅
- 380px wide buttons (STB, CDK, AO, MSO)
- Status polling via fetch HEAD (30s interval), green/red/grey dots
- Keyboard nav 1-4 (first press highlights, second press navigates)
- Offline state: dimmed + diagonal hatch overlay via CSS pseudo-element
- UTC clock (1s interval)
- Container count (polls CDK API /deck/api/containers, 60s interval)
- Share Tech Mono font (Orbitron kept for button codes)
- TST dummy button (offline hatch demo, removed from prod)

### anim-lab.html — Animation Lab ✅
Full boot sequence:
1. CLI phase (Share Tech Mono, CRT scanlines + phosphor glow on CLI only)
   - LOAD APPSERV1\{STB,CDK,AO,MSO,TST} commands typed out
   - Per-character keyboard click sounds (filtered noise burst, 180-300Hz)
   - System responses typed out (connection established / ERR)
   - Bare > prompt with blinking cursor
   - "HAL71 Interface Loaded.." end response
   - End chime (two-tone sine chord 520/780Hz)
   - [ SKIP ] button to bypass CLI instantly
2. CLI fades to black (0.8s)
3. Button phase — color blocks fade in L→R (620ms each, soft beep per button)
4. All glyphs appear simultaneously
5. All codes + app names fade in (codes fast 0.5s, names slow 1.2s)
6. All corner text fades in (1.2s)
7. All Three.js backgrounds fire simultaneously (1.4s fade-in)
8. [ REPLAY ] resets everything

### Three.js Backgrounds ✅
- STB: Ammo can (procedural, exact geometry from experiment, scale 0.55)
- CDK: Pi rack (full geometry incl. handles, faceplates, side panels, camX -2.8)
- AO: SpaceX Dragon OBJ (dragon.obj fetched, OBJLoader, auto-fit camera)
- MSO: 3× stacked monitors + coffee glyph (top) + waveform (mid) + bar chart (bot)
- TST: No background (open Cobb border glyph = no-icon fallback)

### Visual Design
- Offline hatch: CSS repeating-linear-gradient -45deg, brightness 0.35
- Corner text: 13px, 0.75 opacity, Share Tech Mono
- App name: 13px, 1.2s fade
- Glyph wrap: z-index 3, position absolute (not relative — fixed alignment bug)
- bg canvas: z-index 0, opacity 0 → 1 transition

---

## NEXT — WIRING PHASE

### Phase 1: Architecture (index.html)
- [ ] Replace hardcoded app list with dynamic fetch from appserv1
- [ ] API endpoint: GET /deck/api/apps (or equivalent) → returns app manifest
- [ ] App manifest schema: { id, code, name, url, port, hasIcon, color }
- [ ] If hasIcon=false → use open Cobb border glyph fallback
- [ ] Status polling uses manifest URLs

### Phase 2: Boot Animation Integration
- [ ] Move CLI + animation sequence into index.html
- [ ] CLI runs on first load only (sessionStorage flag to skip on reload)
- [ ] Or: always run on fresh load, skip on back-navigation
- [ ] Animation sequence wired to real app manifest data

### Phase 3: Three.js Background Integration
- [ ] Move experiment HTML backgrounds into index.html inline
- [ ] Each .monolith gets its bg canvas initialized after button reveal
- [ ] dragon.obj served from nginx static or inline as data URI

### Phase 4: Polish
- [ ] Hover state: brightness already works, consider subtle scale
- [ ] Active/focused state ring (keyboard nav)
- [ ] Status dot animation: pulse on polling, solid when confirmed
- [ ] Bottom chrome: live container count from CDK API

---

## FILES

| File | Location | Status |
|------|----------|--------|
| index.html | SmartLabLauncher/ | Functional, no animation yet |
| anim-lab.html | SmartLabLauncher/ | Complete animation lab |
| font-preview.html | SmartLabLauncher/ | Reference, keep |
| dragon.obj | SmartLabLauncher/ | AO background model |
| concepts/ | SmartLabLauncher/concepts/ | Experiment saves |
