---
name: nexusecore-ui-ux
description: Use for NexusCore ERP UI/UX design, audit, refactoring, and implementation when a screen or workflow must be usable, data-backed, permission-aware, RTL-safe, and verifiable. Covers React, TypeScript, Tailwind, shadcn/ui, accessibility, dense operational screens, and responsive visual QA.
metadata:
  short-description: NexusCore ERP UI/UX quality gate
  author: "Karim (KaReem Elhlag) Abdelhady"
  project: "NexuseCore-ui-ux"
  version: "2.0.0"
---

# NexuseCore UI/UX

> Maintained and authored by **Karim (KaReem Elhlag) Abdelhady** for the NexuseCore UI/UX component and workflow standard.

This skill is intentionally independent from backend architecture skills. It can be used on its own for frontend audits and implementation, or alongside an engineering/DDD skill when the workflow crosses API, tenancy, permissions, or persistence boundaries.

Build interfaces that are calm, clear, dense enough for ERP work, and easy to extend. This skill is independent: it does not require or invoke `kmg-agent-skill`.

## Use when

- Creating, reviewing, or repairing a NexusCore page, workflow, form, table, dashboard, modal, navigation surface, or component.
- Improving visual hierarchy, RTL behavior, accessibility, responsive layout, or perceived quality.
- Introducing or extending shadcn/ui components in the existing React/Tailwind application.

## shadcn/ui usage

- Treat shadcn/ui as the preferred source for new primitives: add only the needed component with the shadcn CLI, then keep its source in `src/components/ui`.
- Use the existing NexusCore tokens, `cn()` helper, Lucide icons, RTL behavior, and accessibility conventions when adapting a shadcn component.
- Prefer composition and variants over copying a full design system. Do not overwrite `tailwind.config.js`, `src/index.css`, or existing shared primitives during initialization.
- Before adding a component, search `src/components/ui` and the existing custom primitives for an equivalent; extend one when that preserves behavior.
- For a new reusable component, use the component-creator procedure in [references/component-creator.md](references/component-creator.md). The creator must first locate an equivalent, then add one canonical primitive, a focused test, and a usage note before allowing feature-local copies.

Skip for backend-only work, data migrations, or purely mechanical changes with no visible behavior.

## Operating workflow

For any non-trivial screen or workflow, follow this order and keep the scope bounded:

1. **Map the user job:** identify the actor, goal, entry route, primary action, success result, failure recovery, and permission boundary. If the screen cannot be described as a short workflow, stop and clarify the structure before styling.
2. **Trace the data contract:** locate the route, query/mutation service, DTO/type, persistence source, and existing permission wrapper. A button is not implemented until its action changes durable state or navigates to a real, supported workflow.
3. **Choose one owner for each concern:** page orchestration in a page/hook, server communication in a service, domain state in the API, and rendering in components. Do not duplicate the same editor or mutation in dashboard, setup, and detail surfaces without an explicit reason.
4. **Design the states first:** loading, empty, error with retry, permission denied, disabled/submitting, saved, and stale/conflict. Empty data must not be presented as an unexpected server failure.
5. **Implement the smallest composable surface:** reuse existing primitives and tokens. Add a shadcn primitive only when an existing equivalent is absent; do not introduce a new wrapper for a one-off visual.
6. **Verify the real workflow:** test the route, permission, mutation, refresh/readback, keyboard flow, RTL layout, and mobile layout. Source inspection alone is not completion evidence.
7. **Run the consistency audit:** run `scripts/audit-ui.ps1` against the frontend. Treat duplicate primitives, feature-local copies of shared controls, missing reduced-motion handling for custom animation, and non-token colors as review findings.

8. **Run the UX performance loop:** use [references/ux-workflow-v2.md](references/ux-workflow-v2.md) to record the
   user job, route/data owner, interaction states, and browser evidence. Use [references/performance.md](references/performance.md)
   for a baseline and changed measurement; do not optimize from intuition alone.

## Operating rules

1. Inspect the existing design system, shared components, route, permissions, translations, and nearby screens before editing.
2. Prefer existing NexusCore primitives. Use shadcn/ui as a composable source for new primitives; do not replace Ant Design or custom components wholesale.
3. Keep business logic in hooks/services and keep visual components focused on rendering and interaction.
4. Use semantic HTML, visible labels, keyboard focus, error recovery, and screen-reader names. RTL must be structural, not a final text-direction patch.
5. Every data surface needs loading, empty, error-with-retry, success, disabled, and permission-denied states where applicable.
6. Optimize for repeated ERP use: scanning, comparison, keyboard flow, stable columns, restrained decoration, and predictable actions.
7. Avoid nested cards, oversized marketing layouts, decorative gradients/orbs, text inside icon-only controls without tooltips, and one-off colors that bypass tokens.
8. Keep layout stable with responsive constraints. Check long Arabic labels, narrow screens, dark mode, and mixed Arabic/Latin identifiers.
9. Prefer small composable components and tokenized variants over duplicated page-specific CSS.
10. Verify rendered behavior, not source appearance alone: run focused tests and inspect the page in a real browser at desktop and mobile widths.

## Anti-patterns that block completion

- A dashboard card links to a generic page while claiming to show tenant/store/module-specific data without passing and honoring a supported filter.
- The same business action is implemented twice with different persistence paths, especially JSON settings plus a relational endpoint.
- A preview is hard-coded or only updates local state while the saved configuration uses another shape.
- A success toast appears without a successful server response and a readback path.
- A visible control has no route, API mutation, permission check, or meaningful disabled/error state.
- A new page is added only to hide an existing broken flow; fix the owner workflow instead.
- A drawer, modal, button, table, field, or feedback surface is recreated inside a feature when an equivalent exists in `src/components/ui`.
- A custom animation changes layout, traps focus, or ignores `prefers-reduced-motion`.
- Responsive behavior is patched per page instead of being expressed by a shared primitive or layout contract.

## Workflow contract

For each changed workflow, record these facts in the implementation or task report:

| Contract | Required evidence |
| --- | --- |
| Entry | Reachable route and permission wrapper |
| Read | Loading, empty, error/retry, and tenant-scoped query |
| Write | Typed mutation, validation, authorization, and conflict handling |
| Feedback | Pending/disabled state and success/error message |
| Persistence | Refresh or readback proves the result survived |
| UX | Primary action, next step, keyboard focus, RTL and mobile behavior |
| Test | Focused component/route test; browser check when layout or interaction changes |

If one contract row is missing, report the gap instead of calling the feature complete.

## Central component policy

- `src/components/ui` is the single source of truth for shared interaction primitives.
- Feature folders may compose central components, but may not fork their behavior or styling.
- A component becomes central only when it has a stable API, an accessibility contract, and at least one focused test. Promote it when a second real surface needs the same behavior.
- Prefer one drawer/modal/table/form primitive with variants over several visually similar implementations.
- Motion is a shared behavior: use short tokenized transitions, preserve layout stability, and disable non-essential motion under `prefers-reduced-motion`.
- Every new primitive must document its intended use, forbidden uses, responsive behavior, and RTL behavior in the component creator record.

## Scripts

- `scripts/audit-ui.ps1`: scans a frontend for duplicated primitive names, feature-local modal/drawer/button copies, hard-coded color values, and custom animation without a reduced-motion branch. It is advisory and produces findings; it never rewrites source.
- Run it from the repository root with `pwsh -File <skill>/scripts/audit-ui.ps1 -FrontendPath nexusecore-web`.
- Use findings to decide whether to promote a component, compose an existing primitive, or document an intentional exception.

## Token discipline

- Read only the relevant reference for the current UI task.
- Search symbols and shared primitives before reading whole files.
- Reuse existing copy, tokens, icons, and test helpers.
- Do not create a design-system abstraction until at least two real surfaces need it.
- Report verification evidence and remaining visual debt briefly.

## v2 role routing

Select one primary role by the files and risk actually touched, then consult the other role when the change crosses
their boundary:

- [roles/frontend-architect.md](roles/frontend-architect.md): React, TypeScript, API state, browser performance, and
  security boundaries.
- [roles/ux-governance-reviewer.md](roles/ux-governance-reviewer.md): user jobs, information architecture, interaction
  states, accessibility, RTL, responsive behavior, and review/acceptance control.
- [roles/ui-platform-engineer.md](roles/ui-platform-engineer.md): shared components, shadcn/ui, tokens, rendering
  performance, visual consistency, and maintainable implementation.

All roles are software architecture/design and security-aware roles. Route by evidence, not by the screen's name. If a
role is not applicable, record why; do not load every reference for a small visual change.

## Required result

Before calling a UI task complete, confirm:

- The primary workflow is obvious without explanatory feature text.
- Actions, status, hierarchy, and next steps are visually clear.
- Arabic/RTL, keyboard focus, responsive wrapping, and contrast are acceptable.
- Loading, empty, error, and retry behavior are intentional.
- Shared components remain reusable and the change does not silently bypass permissions.
- TypeScript and focused UI tests pass; browser evidence is included when the task changes layout or interaction.
- The workflow contract above is satisfied, or every remaining gap is explicitly reported.
- A v2 UX record contains baseline/changed measurements, the route/data owner, the state matrix, and the remaining
  visual debt with a decision: `ACCEPTED`, `ACCEPTED WITH FOLLOW-UP`, `REJECTED`, or `BLOCKED`.

For detailed review criteria, read [references/quality-gate.md](references/quality-gate.md).
