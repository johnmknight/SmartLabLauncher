# OPEN ISSUES — SmartLab Launcher

**Last Updated:** 2026-03-13

---

## 🟡 Design Decisions Pending

- [ ] **App name for SmartToolbox going live**
  - Currently displayed as: `SMARTTOOLBOX`
  - Candidate rename: **Smart Rack Ops** (better ops branding)
  - Decision needed before first deploy — affects 3-letter code (STB vs SRO), button label, and any CommandDeck references
  - Note: SmartToolbox is the internal dev name; launcher-facing name may differ

- [ ] **Background illustrations not yet designed**
  - STB button: white line-art rack/network diagram, right-biased, ~15–20% opacity behind glyph zone
  - CDK button: TBD representational art
  - Phase 2 work — launch without illustrations is acceptable

---

## 🔵 Architecture / Integration

- [ ] **Live container count in bottom chrome**
  - Bottom bar shows: `APPSERV1 · 192.168.4.148 · N CONTAINERS RUNNING`
  - Options:
    a. **CommandDeck health endpoint** — if CDK exposes `/health` with container data, fetch from there
    b. **SmartToolbox/SRO health endpoint** — same approach
    c. **Static** — hardcode `2 CONTAINERS RUNNING` for v1, update manually as apps are added
  - Recommend option (c) for v1 launch, revisit when CommandDeck agent loop is live

- [ ] **Launcher communication channel**
  - Launcher is currently static HTML — no backend
  - If live status per-app is needed (ONLINE/OFFLINE dot), needs a polling mechanism
  - Options:
    a. Fetch `http://192.168.4.148:{PORT}/health` directly from browser JS
    b. Proxy through CommandDeck (single source of truth for all app health)
  - CommandDeck is the natural hub once its agent loop (`agent.py`) is complete
  - **Dependency:** CommandDeck agent loop build (next priority in CDK queue)

---

## 📋 Session Notes

### 2026-03-13
- Project created from design-phase concept work
- Full design language established in conversation: 2001 + Semiotic Standard fusion
- Glyph geometry locked: square W÷3, inset 14px L+B, Cobb octagonal border, no text, corners = button color
- Typography: 3-letter code dominant at ~88px, full name below, wide letter-spacing
- Corner meta: SYS·01 / IP:PORT / APPSERV1
- Colors: STB cobalt `#1A42CC`, CDK violet `#7B22B0`
- Background `#07070F`, top/bottom chrome bars
- App name TBD: SmartToolbox vs Smart Rack Ops (going live soon — resolve before deploy)
- Implementation not yet started — all work is SVG mockup in design session
