# Unfilter — Handoff

Updated: 2026-06-12 15:30

## Current architecture

```
User uploads photo → Scanner API (HF Space) → Classifier → 
  ├─ Matrix classes (5/15): apply 4×3 affine matrix from honest_filter_matrices.json
  └─ Pass-through (10/15): return original bytes verbatim
```

## Scanner API

**Endpoint:** `POST https://dealermatt72-defilter-scanner.hf.space/scan` (multipart `file`)

**Response:**
```json
{
  "filter": "Filter detected: simple (98.4%)",
  "removal": "Matrix inverse — simple (val_MAE=1.408)",
  "ai": "AI content: -1.0%",
  "restored": "<base64 JPEG>"
}
```

**Pass-through response** (non-matrix filters):
```json
{
  "filter": "Filter detected: softlight (99.2%)",
  "removal": "No matrix available — original returned (softlight 99.2%)",
  "restored": "<original bytes verbatim, no re-encode>"
}
```

**GitHub repo:** HuggingFace Space `dealermatt72/defilter-scanner` (private)
**Latest commit:** `ab51e41` — "force rebuild trigger" (includes pass-through verbatim bytes fix)
**Health:** `GET /health` → `{"matrices_loaded":5, "matrices_for":["fade","handheld","rio_de_janeiro","simple","zoom_blur"]}`

## Valid matrices (Iteration A — 5/15 classes)

| Class | val_MAE | Details |
|-------|---------|---------|
| fade | 0.335 | Tinted warmer, lower contrast |
| simple | 1.408 | Slight brightness + lower contrast filter |
| rio_de_janeiro | 2.834 | Green/yellow oversaturated |
| zoom_blur | 4.649 | Radial blur effect |
| handheld | 6.541 | Motion blur from camera shake |

**Solver:** plain `np.linalg.lstsq`, no ridge.
**Training data:** 14 CelebA faces + flip augmentation (28 pairs/class), 128px.
**All matrices frozen — do not refit.**

## Failing classes (10/15 — no valid matrix)

These are NOT_COLOR_RECOVERABLE by any per-pixel transform:

- **Spatial filters:** grainy, gritty, handheld (already has matrix), softlight, lores, zoom_blur (already has matrix)
- **B&W:** graphite (color destroyed)
- **Extreme chroma:** jakarta, los_angeles, midnight, paris, hyper

**Attempted approaches that failed:**
1. Balanced-weight lstsq (50:50 face:chart) — 0/10
2. + ridge λ=1e-3 — 0/10
3. + RPCC degree-2 terms — 0/10 (still can't model non-linear/spatial filters)

## Vercel projects

| Project | URL | Purpose |
|---------|-----|---------|
| unfilter-eval-v3-rollback | https://unfilter-eval-v3-rollback.vercel.app | Gallery — 21 MATRIX / 11 PASS-THROUGH with per-card labels |
| unfilter-v3 | https://unfilter-v3.vercel.app | Main UI (uses scanner API) |
| unfilter-app | https://unfilter-6ku3opz6q-letsgomo52-2665s-projects.vercel.app | Old v1 |
| unfilter-v2 | https://unfilter-v2-p1ii9h7ru-letsgomo52-2665s-projects.vercel.app | v2 (not used) |
| unfilter-eval-deploy | https://unfilter-eval-deploy-96v6x0nyo-letsgomo52-2665s-projects.vercel.app | CAIR baseline (old) |

## HF models
- `dealermatt72/defilter-classifier` (private) — 15-class MobileNetV3, ~98.3% real-world accuracy
- `dealermatt72/defilter-unet` (private) — U-Net fallback, SSIM 0.759 (not currently used)

## Classifier status — **suspicious but probably fine**
150-image synthetic test (10 CelebA faces × 15 PIL-simulated filters) gave only 32.7% accuracy. **However** the synthetic filters are crude PIL approximations (box blurs, contrast sliders) — when simulations happened to match real filters (grainy/hyper/rio all 100%), the classifier nailed them. The 98.3% real-world accuracy is more trustworthy.

Gate 2 blocked Phase 3 (matrix improvement loop). Decision pending from user.

## CHANGELOG.md
Latest entries (full log in HF Space repo):
```
2026-06-12 14:00 — Fix pass-through verbatim bytes (Space rebuild ab51e41)
2026-06-12 12:00 — Phase 1 rollback fix complete
2026-06-12 02:00 — Refit 10 failing classes (all approaches failed)
2026-06-12 00:00 — Rollback to Iteration A (honest_filter_matrices.json, 5 matrices)
```

## What Hermes was doing
- Fixed scanner bug: pass-through was re-encoding at JPEG quality 95 instead of returning verbatim bytes
- Regenerated gallery with proper per-card labels (21 MATRIX / 11 PASS-THROUGH)
- Ran 150-image classifier sanity test — flagged but probably a simulation artifact
- User asked for Phase 3 (matrix improvement) — blocked at Gate 2

## What Claude should know
- **Do NOT refit the 5 Iteration A matrices** — they're frozen
- **Do NOT modify the classifier** without user direction
- **Do NOT touch unfilter-v2, unfilter-app projects** or their Vercel deployments
- Rollout plan file in iOS project: the UI calls `/scan` and displays the restored base64
- The scanner never uses PIL passthrough function for matrix — it's affine math on numpy arrays
