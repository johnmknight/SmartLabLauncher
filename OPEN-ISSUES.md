# SmartLabLauncher — OPEN ISSUES

## Animation Lab (anim-lab.html)

### RESOLVED THIS SESSION
- ✅ Corner text / glyph misalignment — caused by `position:relative` override on `.monolith-inner`. Fixed by only setting z-index, not position.
- ✅ MSO rotating opposite direction — changed `rotation.y -= 0.003` to `+= 0.004`
- ✅ OBJLoader not attaching to THREE — added CDN script tag for OBJLoader before background script block
- ✅ initSTB crash — removed erroneous `Object.assign` on mesh position
- ✅ Backgrounds not firing — `initAllBackgrounds()` never called; added Step 5 to reveal sequence
- ✅ Button content hidden after background added — `monolith-inner` had `position:relative` breaking absolute-positioned corners/glyph

### OPEN
- [ ] STB model still slightly larger than AO visually — may need further scale tweak (currently 0.55)
- [ ] MSO coffee glyph position shifts as model rotates — glyph is drawn in model space, looks fine at rest
- [ ] AO Dragon loads async — brief moment where AO button has no background before OBJ loads
  - Mitigation: background canvas stays opacity 0 until fetch completes? Or show placeholder?
- [ ] No error state shown if dragon.obj fetch fails (currently silent console.warn)

## index.html (Functional Launcher)

### OPEN
- [ ] Container count hardcoded "— CONTAINERS" until CDK API responds
- [ ] Status polling uses `mode: no-cors` — opaque responses always look "online"
  - Need a CORS-enabled health endpoint on each app, or a SmartLab proxy
- [ ] TST dummy button still in file — remove before production deploy
- [ ] No keyboard nav visual feedback beyond box-shadow ring
- [ ] Self-host Orbitron woff2 in fonts/ for offline/LAN use

## Infrastructure

- [ ] nginx needs to serve dragon.obj from SmartLabLauncher static root
- [ ] App manifest API not yet defined — needed for dynamic button generation
- [ ] Animation sequence not integrated into index.html yet
