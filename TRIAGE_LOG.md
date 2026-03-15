# SmartLab Production Triage Log

## Date: 2026-03-14
## Status: ALL APPS FIXED, DEPLOYED, AND VERIFIED ✅

---

## STB — SmartToolbox (http://192.168.4.148/toolbox/)

### Status: DEPLOYED AND VERIFIED ✅

**Root cause:** All fetch calls used root-relative `/api/...` paths that fail
behind nginx reverse proxy at `/toolbox/`.

**Fix:** Auto-detect reverse proxy prefix from URL at runtime.
Commits: `41fa650` (4 static client files) + `50e4a25` (3 server-rendered pages).
7 files fixed, zero remaining hardcoded root-relative fetch calls.

**Deployed:** GH Actions ARM64 build → pulled on appserv1.
**Verified:** SERVER ONLINE, 7 boxes, racks, categories, nav links all working.

---

## CDK — CommandDeck (http://192.168.4.148/deck/)

### Status: DEPLOYED AND VERIFIED ✅

**Root cause:** Same reverse proxy issue — `api.js` had root-relative `/api/...`
paths, WebSocket used `location.host/ws`, HTML files had `/static/...` paths.

**Fix:** Added `BASE` detection in `api.js`, prepended to all get/post/patch +
WebSocket URL. Added `<base>` tag script to both HTML files. Relative CSS/JS paths.
Commit: `42185f1` — 4 files (api.js, dashboard.js, index.html, project.html).

**New infrastructure:** Created GH Actions workflow, `.dockerignore`, added
`python-dotenv` to requirements. `/api/apps` endpoint returns `app_server_url`
and all 4 deployed apps. `.env.commanddeck` updated with `APP_SERVER_URL`.

**Deploy pattern:** Switched to build-on-Pi (git clone → docker build → compose up).
**Verified:** 8 project cards, all API calls 200, BOARD/RESUME/LAUNCH buttons work.

---

## AO — ArtemisOps (http://192.168.4.148/artemis/)

### Status: DEPLOYED AND VERIFIED ✅

**Root cause:** Same reverse proxy issue, spread across shell + tab iframes.
Additional issues: server serves `index-shell.html` (not `index.html`),
iframe `src` attributes used absolute `/tabs/...` paths, `API_BASE` used
`location.origin` without proxy prefix, inner tracking iframes used `/mockups/...`.

**Fix:** Created `ao-base.js` with monkey-patched `window.fetch` that auto-prepends
proxy prefix to all root-relative URLs. Added to shell + all 9 tab files.
Fixed WebSocket URL, `API_BASE`, iframe srcs, script paths.
Commits: `c22dec4`, `8f210be`, `3ee17d8` — 15 files total.

**Verified:** Countdown timer, NASA logo, launch details, mission status, news ticker.
All API calls routing through `/artemis/api/...` with 200s.

---

## MSO — MarchogSystemsOps (http://192.168.4.148/marchog/)

### Status: DEPLOYED AND VERIFIED ✅

**Root cause:** Same reverse proxy issue — fetch calls, WebSocket, manifest/icon
hrefs, config.html template literal paths, video.html `apiBase` using `location.origin`.

**Fix:** Created `mso-base.js` with monkey-patched `window.fetch`. Added to
shell + all 9 page iframes + config.html. Fixed WebSocket URL, manifest/icon hrefs,
template literal paths, video.html apiBase.
Commit: `d920195` — 12 files total.

**Verified:** Shell loads, `MSO_BASE="/marchog"`, fetch patched, 10 pages loaded,
9 iframes created. Fullscreen overlay renders correctly.

---

## Launcher (http://192.168.4.148/)

### Status: DEPLOYED AND VERIFIED ✅

**Dynamic rendering from CommandDeck API:** 4 buttons (STB/CDK/AO/MSO) with
Three.js wireframe backgrounds, glyphs, palette colors, all driven by
`GET /deck/api/apps` returning `app_server_url` and app metadata.

**Infrastructure:** Static files served by nginx at root, volume-mounted
from `/home/john/smartlab/launcher/`.

---

## Infrastructure Changes

- **Build pattern:** Switched from GH Actions → ghcr.io to build-on-Pi
  (git clone → docker build → docker compose up). Faster, simpler, no registry auth.
- **Repos on appserv1:** All 4 app repos cloned at `/home/john/smartlab/`
  (commanddeck, artemisops, marchogsystemsops, smarttoolbox)
- **nginx:** Root location serves launcher, volume mount added for launcher dir
- **CommandDeck:** `.env.commanddeck` has `APP_SERVER_URL=http://192.168.4.148`
- **smartlab-infra:** Updated nginx.conf + docker-compose.yml committed
