# UX Performance v2

Measure a baseline and the changed result with the same route, fixture, viewport, and browser conditions. Keep raw
traces in ignored scratch storage; durable records contain only safe numbers and evidence paths.

| Area | Measure |
|---|---|
| Navigation | route start-to-interactive and route error rate |
| Interaction | input-to-feedback latency and duplicate-submit rate |
| Rendering | LCP, INP, CLS, long tasks, and unnecessary rerenders when available |
| Network | request count, payload size, waterfalls, retries, timeout rate |
| Data UI | query time, pagination/virtualization behavior, stale-read rate |
| Accessibility | keyboard completion, focus loss, contrast, label/name coverage |

## Default review budgets

- Investigate a P95 interaction regression above 10%; reject above 20% without an approved exception.
- Reject new duplicate requests, unbounded lists, layout shift caused by loading, or retries without idempotency.
- Prefer route-level code splitting and stable dimensions when a screen is large; measure before and after.
- A performance shortcut must not remove loading, error, permission, accessibility, or readback states.

## Waste controls

- Search before reading; read one bounded slice per file.
- Reuse a central primitive before creating a local copy.
- Stop at the first failing verification stage and resume from that stage.
- Record one decision and one evidence path per claim; do not paste raw logs into the report.
