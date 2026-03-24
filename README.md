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

### Integration with CommandDeck

SmartLabLauncher loads app data dynamically from CommandDeck's `/api/apps` endpoint:
- **API endpoint:** `http://192.168.4.148:8090/api/apps` (proxied via nginx at `/deck/api/apps`)
- **Returns:** App manifest with codes, names, colors, ports, routes, glyphs
- **Buttons generated** client-side from API response (no hardcoded apps)

See [CommandDeck README](../CommandDeck/README.md) for database schema.

## Production Apps

Dynamic — loaded from CommandDeck API. Current apps:

| Code | App | Port | Color | Route |
|------|-----|------|-------|-------|
| STB  | SmartToolbox | :8091 | `#1A42CC` cobalt | `/toolbox/` |
| CDK  | CommandDeck  | :8090 | `#7B22B0` violet | `/deck/` |
| AO   | ArtemisOps | :8085 | `#F97316` orange | `/artemis/` |
| MSO  | MarchogSystemsOps | :8082 | `#EAB308` yellow | `/marchog/` |
| SLNO | SmartLabNetOps | :8096 | `#8b5cf6` purple | `/netops/` |

## Stack

Static site — HTML + CSS + vanilla JS. No framework, no build step.
Served directly from nginx on appserv1.

## Repository

- **Local:** `C:\Users\john_\dev\SmartLabLauncher`
- **GitHub:** `https://github.com/johnmknight/SmartLabLauncher`
