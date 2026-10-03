# UI/UX Senior Monitor Certification

Mandatory final review for every non-trivial UI or workflow change.

## Evidence bundle

- User job, entry route, permission boundary, and primary success action.
- Changed-file and component-owner map.
- Loading, empty, error/retry, permission, saving, saved, stale/conflict, and destructive-action states.
- API contract, mutation, refresh/readback, and tenant scope evidence.
- Focused tests plus browser evidence at desktop and mobile widths.
- Keyboard, screen-reader labels, RTL, mixed Arabic/Latin, reduced-motion, and contrast checks.
- Performance baseline and delta for the touched route or interaction.

## Gates

| Area | Pass condition |
|---|---|
| Workflow | The primary action is obvious and reaches a real durable result. |
| Data | The UI uses one typed owner and proves persistence after refresh. |
| Components | Shared primitives are reused; no feature-local duplicate exists. |
| Accessibility | Labels, focus, keyboard flow, semantics, contrast, and reduced motion are covered. |
| RTL/responsive | Arabic, mixed identifiers, narrow screens, and mobile interaction remain usable. |
| Reliability | Pending, retry, conflict, permission, and server failure behavior are explicit. |
| Performance | Baseline/delta and interaction stability are recorded. |
| Security | Tenant, role, and permission boundaries are enforced by the API and reflected in the UI. |

## Decisions

- `CERTIFIED`: all applicable gates pass.
- `CERTIFIED_WITH_RESIDUE`: safe to proceed with an owned and dated follow-up.
- `REWORK_REQUIRED`: UX or contract changes are required.
- `BLOCKED`: required runtime, browser, or contract evidence is unavailable.
