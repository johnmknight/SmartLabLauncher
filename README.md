# SmartLab Launcher

Web-based app launcher for all SmartLab production services running on appserv1.

## Purpose

Single-page cinematic launcher styled after the HAL 9000 interface aesthetic from
*2001: A Space Odyssey* + Ron Cobb Semiotic Standard iconography. Each app gets a
tall monolith-proportioned button with a 3-letter code, Cobb-bordered glyph, and
live IP:port readout.

## Design Language

- **Color field:** Flat saturated panel per app (no gradients)
- **Typography:** Monospace bold, wide letter-spacing — Eurostile Bold Extended aesthetic
- **Glyph:** Square, W÷3 of button width, inset 14px left + 14px bottom, Cobb octagonal border
- **Codes:** 3-letter operational shorthand (STB, CDK, ...)
- **Background:** `#07070F` — near-black field with top/bottom chrome bars

## Infrastructure

- **Host:** appserv1 — 192.168.4.148 (Docker app host)
- **Served by:** nginx :80 (reverse proxy)
- **Pattern:** Static HTML/CSS/JS — no backend required
- **Production URL:** `http://192.168.4.148/`

## Deployment

### Deployment Architecture

SmartLabLauncher is a static site served at nginx root (`/`):
- **Local development:** `C:\Users\john_\dev\SmartLabLauncher\`
- **Production path:** `/home/john/smartlab/launcher/` on appserv1
- **nginx volume mount:** `./launcher:/usr/share/nginx/launcher:ro` (read-only)
- **Served at:** `http://192.168.4.148/` (root path)

### Deployment Method

1. **Edit locally** on dev PC (`C:\Users\john_\dev\SmartLabLauncher\`)
2. **Test changes** using local HTTP server (port 7700)
3. **Commit & push** to GitHub (`johnmknight/SmartLabLauncher`)
4. **Deploy to production** via SCP:
   ```bash
   scp index.html dragon.obj john@192.168.4.148:/home/john/smartlab/launcher/
   ```
5. **Changes are live immediately** (nginx serves static files, no restart needed)

### Manifest source (HomeOps)

SmartLabLauncher loads app data dynamically from the HomeOps `launcher_manifest`
add-in (HomeOps is the SmartLab backend framework on appserv1):
- **API endpoint:** `http://192.168.4.148:8086/addins/launcher_manifest/api/apps`
  (cross-origin from the launcher; HomeOps sends `Access-Control-Allow-Origin: *`)
- **Returns:** `{ app_server_url, apps[] }` — codes, names, colors, ports, routes, glyphs
- **Container counts:** `…/api/containers` (via the Docker socket HomeOps mounts)
- **Buttons generated** client-side from the API response (no hardcoded apps)
- **Config mode** (`[ CFG ]` button or Shift+C) does add/move/toggle/delete via
  the add-in's CRUD endpoints — a capability CommandDeck never had.

> **Note:** This replaced CommandDeck's `/deck/api/apps`. CommandDeck was
> decommissioned 2026-05-28; the manifest now lives in HomeOps and is editable.

## Production Apps

Dynamic — loaded from the HomeOps launcher_manifest add-in. Current apps:

| Code | App | Port | Color | Route |
|------|-----|------|-------|-------|
| CHM  | CargoHoldManager | :8091 | `#1A42CC` cobalt | `/cargo/` |
| AO   | ArtemisOps | :8085 | `#1A5C8A` blue | `/artemis/` |
| MSO  | MarchogSystemsOps | :8082 | `#8A1A1A` red | `/marchog/` |
| LDL  | LEDLibris | :8088 | `#F59E0B` amber | `/libris/` |

## Stack

Static site — HTML + CSS + vanilla JS. No framework, no build step.
Served directly from nginx on appserv1.

## Repository

- **Local:** `C:\Users\john_\dev\SmartLabLauncher`
- **GitHub:** `https://github.com/johnmknight/SmartLabLauncher`
