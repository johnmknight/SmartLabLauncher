# SmartLab Launcher — Dynamic App Discovery Design

## Status: DESIGN PHASE

---

## Problem Statement

The launcher currently hardcodes four app buttons (STB, CDK, AO, MSO) with
static HTML, inline SVG glyphs, and hand-built Three.js background functions.
Adding, removing, or changing an app requires editing index.html directly.

The goal is to make the launcher fully data-driven: on startup it queries
CommandDeck for the list of deployed apps, then dynamically builds the CLI
boot animation, button tiles, glyphs, and 3D backgrounds from that data.

---

## Architecture Decision: CommandDeck as Source of Truth

### Decision
All app metadata lives in CommandDeck's `projects` table. The launcher
fetches it via a new API endpoint at boot time.

### Rationale (researched alternatives)

**Option A — CommandDeck API (chosen)**
- Already has a `projects` table with: `short_name` (3-letter code), `name`,
  `color`, `port`, `repo_path`, `github_url`
- Already has `/api/projects` endpoint with CORS enabled
- Runs on the same Docker bridge network as all other apps
- Can mount Docker socket to get live container health status
- Only needs: new columns + one new endpoint

**Option B — Direct Docker/appserv1 query (rejected)**
- Docker socket only knows container names and ports — no display metadata
  (color, code, glyph, nginx route)
- Launcher is static HTML served by nginx — cannot call Unix socket directly
- Would require building an entirely new proxy service
- Duplicates what CommandDeck already does

---

## Data Model Changes (CommandDeck `projects` table)

### New columns required

| Column | Type | Purpose | Example |
|--------|------|---------|---------|
| `route_path` | TEXT | nginx reverse proxy path | `/toolbox/` |
| `glyph_svg` | TEXT | Inner SVG content (no Cobb border) | `<rect x="14" y="17" .../>` |
| `bg_js` | TEXT | Three.js background function body | JS code string |
| `is_deployed` | INTEGER | Whether app appears on launcher | `1` or `0` |
| `sort_order` | INTEGER | Display order on launcher (L→R) | `0`, `1`, `2`, `3` |

### Existing columns used by launcher

| Column | Launcher use |
|--------|-------------|
| `short_name` | 3-letter button code (STB, CDK, AO, MSO) |
| `name` | App name displayed below code |
| `color` | Button background color |
| `port` | Shown in corner text (:8091, :8090, etc.) |

### Notes
- `glyph_svg` contains ONLY the inner icon elements, NOT the Cobb octagon
  border. The launcher wraps every glyph in the standard border at render time.
- `bg_js` is a function body string that receives a single `canvas` argument.
  The launcher executes it via `new Function('canvas', bgJs)(canvasEl)`.
- Both `glyph_svg` and `bg_js` are nullable — missing values fall back to:
  - Glyph: empty Cobb octagon (border only, no inner content)
  - Background: flat color (no Three.js scene, canvas stays hidden)
- `is_deployed` distinguishes launcher-visible apps (STB, CDK, AO, MSO) from
  dev-only projects (TikiBarOnTheMoon, FindAJob, etc.)

---

## New API Endpoint: `GET /api/apps`

Lives in CommandDeck (`backend/main.py`). Returns only deployed apps
with all fields the launcher needs.

### Response shape

```json
[
  {
    "id": "smarttoolbox",
    "code": "STB",
    "name": "SmartToolbox",
    "color": "#1A42CC",
    "port": 8091,
    "route_path": "/toolbox/",
    "glyph_svg": "<rect x=\"14\" y=\"17\" ... />",
    "bg_js": "const scene = new THREE.Scene(); ...",
    "status": "running"
  }
]
```

### Fields
- `code` — mapped from `short_name`
- `status` — live container state from Docker socket (`running`, `stopped`,
  `not_found`). Optional enhancement; can start without this and add later.
- All other fields direct from `projects` table

### Filtering
- Only returns rows where `is_deployed = 1`
- Ordered by `sort_order ASC`

---

## Launcher Dynamic Rendering

### Boot sequence (revised)

1. **Fetch manifest** — `GET {origin}/deck/api/apps`
   - On failure: show error state (no buttons, message in CLI area)
   - On success: proceed with app list

2. **Build CLI lines** — for each app in response, generate:
   ```
   > LOAD APPSERV1\{CODE}
   Connection established — APPSERV1\{CODE} online. Loading interface in background.
   ```

3. **Build button HTML** — for each app, create a `.monolith` element:
   - `style="--col:{color}"`
   - Corner text: `SYS·{index}`, `:{port}`, `APPSERV1`
   - Code in Orbitron 900
   - App name below rule
   - Glyph: Cobb border (always) + inner SVG from `glyph_svg` (if present)
   - Canvas element for Three.js background
   - `href` = `{origin}{route_path}`, `target="_blank"`

4. **Run CLI animation** — same as today, but driven by the fetched list
   instead of hardcoded `CLI_APPS` array

5. **Reveal buttons** — same L→R sequence

6. **Init Three.js backgrounds** — for each app:
   - If `bg_js` exists: `new Function('canvas', app.bg_js)(canvasEl)`
   - If null: skip (canvas stays hidden, flat color shows through)

### What gets removed from index.html
- All hardcoded `<a class="monolith">` blocks
- The `CLI_APPS` array
- The `APP_MANIFEST` array
- The four `initSTB()`, `initCDK()`, `initAO()`, `initMSO()` functions
- Replaced by a single `buildButton(app)` factory + dynamic `bg_js` execution

### What stays
- CSS (monolith styles, chrome bars, CLI overlay)
- Audio functions (beep, softBeep, endChime)
- CLI typing machinery (addRow, typeInto)
- Shared Three.js helpers (makeRenderer, makeWF)
- UTC clock, keyboard nav (adapted to dynamic key count)
- Status polling (adapted to use fetched route_paths)
- Container count polling

---

## Launcher Admin Mode

### Activation
- URL param: `?admin=1`
- Or keyboard shortcut (TBD — e.g. Ctrl+Shift+A)
- Adds a subtle admin indicator to chrome bar

### Workflow
1. Click any button tile → opens an admin panel overlay
2. Panel shows two sections:

**Glyph Editor**
- Current glyph preview (live, inside actual Cobb border at full size)
- Text prompt input: "Describe the icon you want for this app"
- "Generate" button → calls Claude API with glyph spec prompt
- Spec prompt includes: viewBox 0 0 70 70, stroke-based, rgba white,
  matching existing style, inner content only (no border)
- Generated SVG appears in live preview immediately
- "Regenerate" / "Save" buttons
- Save → `PATCH /deck/api/projects/{id}` with `glyph_svg` field

**3D Background Editor**
- Current background preview (live, on actual button canvas)
- Text prompt input: "Describe the 3D wireframe model"
- "Generate" button → calls Claude API with Three.js skeleton prompt
- Spec prompt includes: makeRenderer/makeWF helpers available, must return
  animation loop, wireframe style matching existing buttons
- Generated code executes in preview canvas
- "Regenerate" / "Save" buttons
- Save → `PATCH /deck/api/projects/{id}` with `bg_js` field

### Key principle
The admin mode is a lightweight overlay ON the launcher itself — not a
separate page. You see the actual rendered result in-place before saving.

### Claude API integration
- Called client-side from the launcher (browser → api.anthropic.com)
- API key: stored in localStorage or injected via admin URL param
- Model: claude-sonnet-4-20250514
- System prompt: includes the glyph spec or Three.js skeleton as context

---

## Fallback Patterns

Proven in `anim-lab.html` with the TST test button:

| Asset | Present | Fallback |
|-------|---------|----------|
| `glyph_svg` | Render inner SVG inside Cobb border | Empty Cobb octagon (border only) |
| `bg_js` | Execute function, show canvas | Canvas stays hidden, flat `color` shows |
| `color` | Used as `--col` CSS var | Required field — no fallback needed |
| `route_path` | Build href from origin + path | Button disabled / no link |

---

## Existing Art Inventory

Current hand-built assets to migrate into `glyph_svg` / `bg_js` columns:

| Code | Glyph (inner SVG) | 3D Background (JS function) |
|------|-------------------|----------------------------|
| STB | Drawer/shelf icon (3 rects + fills) | `initSTB()` — ammo can wireframe |
| CDK | 4-quadrant grid (lines + rects) | `initCDK()` — Pi rack wireframe |
| AO | Orbit diagram (ellipse + circles) | `initAO()` — Dragon OBJ loader |
| MSO | Monitor stack (3 rects) | `initMSO()` — monitor stack + overlays |

### AO special case: dragon.obj dependency
The AO background loads `dragon.obj` via fetch. When migrated to `bg_js`,
the function body must include the fetch call with a path relative to the
launcher's serving root. This file must be served by nginx alongside the
launcher. Alternatively, the OBJ data could be stored as a base64 string
in `bg_js` to eliminate the external dependency.

---

## Implementation Plan

### Phase 1 — CommandDeck API (do first, everything depends on it)
1. Add `route_path`, `glyph_svg`, `bg_js`, `is_deployed`, `sort_order`
   columns to `projects`
2. Migrate seed data: set `is_deployed=1` for STB, CDK, AO, MSO; add
   `route_path` values; add missing STB and CDK project rows
3. Build `GET /api/apps` endpoint (filter `is_deployed=1`, return shape above)
4. Add `PATCH /api/projects/{id}` support for new columns (needed by admin mode)
5. Test: hit endpoint from browser, confirm response shape

### Phase 2 — Launcher Dynamic Rendering
1. Add fetch call to `/deck/api/apps` on DOMContentLoaded
2. Build `createButton(app, index)` function that generates monolith HTML
3. Build `buildCLIScript(apps)` that generates CLI_APPS from response
4. Wire dynamic buttons into reveal sequence + keyboard nav
5. Execute `bg_js` per button via `new Function('canvas', app.bg_js)`
6. Backfill existing glyph SVG + background JS into CommandDeck DB
7. Remove all hardcoded button HTML, CLI_APPS, APP_MANIFEST, init functions
8. Test: full boot with dynamic data, verify all 4 buttons render correctly

### Phase 3 — Admin Mode
1. Detect `?admin=1` URL param, show admin indicator
2. Build click-to-edit overlay panel
3. Glyph editor: prompt input → Claude API → SVG preview → save
4. Background editor: prompt input → Claude API → JS preview → save
5. Test: generate new glyph for a test app, save, reload, verify

---

## Resolved Questions

1. **Sort order** — Add a `sort_order INTEGER DEFAULT 0` column to the
   projects table. We're already adding columns, and explicit ordering avoids
   fragile implicit sort-by-port or alphabetical. The `/api/apps` endpoint
   returns results ordered by `sort_order ASC`.

2. **dragon.obj serving** — Keep as external file served by nginx at
   `/launcher/dragon.obj`. Inlining 530KB of base64 into a DB text column
   bloats every API response and makes `bg_js` unreadable. The `bg_js`
   function body references it by relative URL (`fetch('dragon.obj')`),
   same as today. Deployment dependency is just one nginx location block.

3. **Claude API key in admin mode** — Stored in localStorage. Admin mode is
   a local dev tool, not a production feature. Prompt on first use, persist
   in browser. No backend changes needed.

4. **Hot reload** — Load once at boot. The launcher is a cinematic experience
   with a boot animation — rebuilding the DOM and re-initializing Three.js
   scenes mid-session has no use case. Deploy a new app → refresh the page.

5. **Container health** — Deferred. Skip Docker socket integration for all
   three phases. The existing status polling (HEAD request to each app's
   route_path via nginx) already provides online/offline state and is
   independent of Docker. Docker socket integration (volume mount +
   Python docker library) is a future enhancement for finer granularity
   (running vs. stopped vs. not found).
