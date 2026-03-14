# SmartLab Production Triage Log

## Date: 2026-03-14

---

## STB — SmartToolbox (http://192.168.4.148/toolbox/)

### Status: DEPLOYED AND VERIFIED ✅

**Symptom:** Page loads (200) but shows "SERVER OFFLINE", "0 UNITS",
"NO BOXES DETECTED". Database has 7 boxes (confirmed via direct API call).

**Root cause:** `const API = ''` on line 957 of `client/index.html`.
All fetch calls use `${API}/api/boxes/` which resolves to the root-absolute
path `/api/boxes/`. Behind nginx at `/toolbox/`, this should be
`/toolbox/api/boxes/`. The fetch 404s, catch block calls
`setServerStatus(false)`, UI shows "SERVER OFFLINE".

**Three broken layers:**
1. API calls — root-relative `/api/...` misses nginx `/toolbox/` prefix (404)
2. Nav links — all root-relative (`/`, `/testing`, `/client/labels.html`,
   `/provision`, `/m`) — click navigates to wrong URL
3. Other client pages — `racks.html` (8 fetches), `testing.html` (3 fetches),
   `labels.html` (2 fetches) all hardcode `/api/...` paths

**Fix:** Auto-detect reverse proxy prefix from URL at runtime.
Apply to all 4 client HTML files. Fix nav links with JS on load.

**Files fixed (2 commits: 41fa650 + 50e4a25):**

Static client files:
- `client/index.html` — API detection + nav links + all fetches via `${API}`
- `client/testing.html` — API detection + nav links + 3 fetch calls
- `client/racks.html` — API detection + nav links + 8 fetch calls
- `client/labels.html` — API detection + nav links + 2 fetch calls

Server-rendered pages:
- `server/routes/mobile.py` — API detection + nav links + 1 fetch call
- `server/routes/rfid.py` — API detection + nav links + 1 fetch call
- `server/routes/box_detail.py` — API detection + nav/img links + 7 fetch calls

**Verified:** Zero remaining hardcoded root-relative fetch calls.
**Deploy needed:** Push to GitHub → GH Actions ARM64 build → pull on appserv1.

**Deployed:** GH Actions Run #2 (43s build), pulled and restarted on appserv1.

**Verified on production:**
- SERVER ONLINE ✅ (was SERVER OFFLINE)
- API detection: `/toolbox` ✅
- Boxes rendering with data (racks, categories, inventory) ✅
- Nav links prefixed correctly ✅
- Remaining edge: `/box/{box_id}` links from box cards still root-relative
  (generated in JS render loop, not caught by nav link fixer)

---

## CDK — CommandDeck (http://192.168.4.148/deck/)

### Status: DEPLOYED (new API) — reverse proxy fix needed

- Page loads (200), `/api/projects` returns 8 items
- `/api/apps` returns 404 — expected, running old Docker image
- New code (migrate_db, /api/apps, APP_SERVER_URL) not yet deployed
- Fix: rebuild image, push to ghcr.io, pull on appserv1

---

## AO — ArtemisOps (http://192.168.4.148/artemis/)

### Status: NOT TRIAGED

- Page loads (200)
- Likely same reverse proxy URL issue as STB
- Needs investigation

---

## MSO — MarchogSystemsOps (http://192.168.4.148/marchog/)

### Status: NOT TRIAGED

- Page loads (200), `/api/pages` has data, `/api/screens` returns 0 items
- Likely same reverse proxy URL issue as STB
- 0 screens may be expected (no physical screens registered)
- Needs investigation

---

## Cross-cutting: Reverse Proxy Subpath Problem

ALL apps likely have the same root-relative URL issue behind nginx.
Each app's frontend uses `/api/...` paths that resolve correctly when
accessed directly on the app's port, but fail behind nginx where the
app is served under a subpath (`/toolbox/`, `/deck/`, `/artemis/`, `/marchog/`).

Fix pattern: detect the proxy prefix from `window.location.pathname`
and prepend it to all API calls and nav links.
