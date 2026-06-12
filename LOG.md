# Action Log

## 2026-06-07 19:08
Eval done: 18 images, engine=pilgram-demo

## 2026-06-07 19:31
Eval done: 18 images, engine=pilgram-demo

## 2026-06-07 19:48
Eval done: 18 images, engine=pilgram-demo

## 2026-06-07 19:50
Eval done: 18 images, engine=pilgram-demo

## 2026-06-07 20:03
Eval done: 18 images, engine=pilgram-demo

## 2026-06-07 20:04
Eval done: 18 images, engine=pilgram-demo

## 2026-06-07 20:05
Eval done: 18 images, engine=pilgram-demo

## 2026-06-07 20:06
Eval done: 18 images, engine=pilgram-demo

## 2026-06-07 20:09
Eval done: 18 images, engine=pilgram-demo

## 2026-06-07 20:14
Eval done: 18 images, engine=pilgram-demo

## 2026-06-07 20:20
Eval done: 18 images, engine=pilgram-demo

## 2026-06-07 20:21
Eval done: 18 images, engine=pilgram-demo

## 2026-06-07 20:22
Eval done: 18 images, engine=pilgram-demo

## 2026-06-07 20:24
Eval done: 18 images, engine=pilgram-demo

## 2026-06-07 20:27
Eval done: 30 images, engine=CAIR-S

## 2026-06-08 08:31
Eval done: 18 images, engine=pilgram-demo

## 2026-06-08 09:33
Eval done: 18 images, engine=pilgram-demo

## 2026-06-12 15:30 — PHASE 1+2 complete
Phase 1: Fixed pass-through bytes in scanner, regenerated gallery with proper labels (21 MATRIX / 11 PASS-THROUGH), deployed to unfilter-eval-v3-rollback.vercel.app
Phase 2: 150-image classifier sanity test — 32.7% accuracy (synthetic sim artefact, not real classifier issue). Gate 2 FAILED — blocked Phase 3 pending user decision.
Phase 3: NOT RUN. Waiting for user override on Gate 2.
Key change: scanner no longer re-encodes pass-through images (verbatim bytes fix).
HF Space commit ab51e41. HANDOFF.md fully updated.
Eval done: 30 images, engine=CAIR-S

## 2026-06-12 16:10
Phase 1+2 complete — scanner fix, gallery labels, classifier test (paused at Gate 2)
