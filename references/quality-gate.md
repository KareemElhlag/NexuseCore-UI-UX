# NexusCore UI/UX Quality Gate

Use this reference for a substantial redesign or review. Do not load it for a tiny copy or spacing change.

## Intake

- Identify the user, primary task, decision or action, data density, and failure cost.
- Locate the route, access guard, API/service hook, translations, shared primitives, and closest neighboring screen.
- Preserve existing domain terminology and permission behavior.

## Visual system

- Use the existing NexusCore color and spacing tokens.
- Use a restrained hierarchy: page title, context, primary action, filters, data, secondary actions.
- Keep panels and cards functional, with modest radius and borders; do not put page sections inside decorative cards.
- Prefer Lucide icons and familiar symbols. Add tooltips for unfamiliar icon-only actions.
- Keep Arabic and Latin content aligned without relying on accidental browser bidi behavior.

## Interaction

- One clear primary action per section.
- Destructive or state-changing actions explain impact and expose confirmation when risk warrants it.
- Forms show required fields, validation near the field, save progress, and a recoverable server error.
- Tables support stable headings, readable density, empty results, pagination or virtualization when needed, and a row-level path to details.
- Tabs, accordions, and drawers preserve URL/deep-link state when the workflow benefits from it.

## Accessibility and responsive checks

- Labels are associated with controls; focus is visible and keyboard order is logical.
- Status is not communicated by color alone.
- Dialogs trap focus, have a name, and close predictably.
- Check at 1280px desktop, 768px tablet, and 390px mobile. Check long Arabic labels and mixed identifiers.
- Avoid horizontal overflow unless the table explicitly provides a usable scroll model.

## Verification

- Run TypeScript and the smallest relevant Vitest test.
- For layout or interaction changes, run the relevant Playwright flow and capture desktop/mobile evidence.
- Confirm no console errors caused by the changed screen.
- Record known gaps instead of claiming visual completion from source inspection alone.
