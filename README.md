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

## Production Apps

| Code | App | Port | Color |
|------|-----|------|-------|
| STB  | SmartToolbox | :8091 | `#1A42CC` cobalt |
| CDK  | CommandDeck  | :8090 | `#7B22B0` violet |

## Stack

Static site — HTML + CSS + vanilla JS. No framework, no build step.
Served directly from nginx on appserv1.

## Repo

`C:\Users\john_\dev\SmartLabLauncher`
GitHub: (to be created — `johnmknight/smartlab-launcher`)
