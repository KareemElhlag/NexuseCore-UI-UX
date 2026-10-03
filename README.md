# NexuseCore-ui-ux v2.0.0

Reusable UI/UX engineering skill for NexusCore ERP and other RTL operational interfaces.

**Author and maintainer:** Karim (KaReem Elhlag) Abdelhady  
**Version:** 2.0.0

## Purpose

This skill guides an agent through the complete UI workflow: understand the user job, trace routes and data contracts, reuse one central component implementation, handle all interaction states, and verify the result in the browser.

It is designed to reduce visual drift, duplicated components, disconnected buttons, misleading previews, and responsive regressions.

## Included

- `SKILL.md`: routing, workflow, UX rules, and completion gates.
- `references/quality-gate.md`: detailed review criteria for substantial UI work.
- `references/component-creator.md`: contract for creating and promoting reusable components.
- `scripts/audit-ui.ps1`: advisory consistency audit for a React frontend.
- `references/ux-workflow-v2.md`: user-job, state, contract, and verification workflow.
- `references/performance.md`: frontend UX performance budgets and baseline/delta record.
- `roles/`: scoped frontend architecture, UX governance, and UI platform/security roles.
- `scripts/ux-v2-check.ps1`: deterministic skill-package and UX-record shape check.
- `agents/openai.yaml`: display metadata for Codex skill discovery.

## Installation

Copy the `nexusecore-ui-ux` folder into the local Codex skills directory:

```text
%USERPROFILE%\.codex\skills\nexusecore-ui-ux
```

The skill can then be invoked explicitly as `$nexusecore-ui-ux` or selected automatically when the task matches its description.

## Audit usage

From the frontend repository root:

```powershell
pwsh -File "$env:USERPROFILE\nexusecore-ui-ux\scripts\audit-ui.ps1" -FrontendPath .
```

Use `-Strict` in CI when the team is ready to treat findings as a blocking quality gate. The audit is intentionally advisory by default and never rewrites source files.

## Component policy

`src/components/ui` is the single source of truth for shared interaction primitives. Feature folders compose those primitives; they do not fork drawers, dialogs, tables, fields, buttons, or feedback behavior. New components need a stable typed API, accessibility and RTL behavior, responsive rules, a focused test, and a real usage before promotion.

## Companion skills

Use this skill alone for frontend work. Pair it with `kmg-agent-skill` only when the UI change also crosses backend boundaries such as tenancy, authorization, persistence, money, inventory, or workflow integrity.

## License and attribution

Copyright (c) Karim (KaReem Elhlag) Abdelhady.  
Distributed according to the license selected by the repository owner. Keep this attribution and the author metadata when redistributing or adapting the skill.
