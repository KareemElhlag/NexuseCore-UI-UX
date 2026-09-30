# Component Creator Contract

Maintained by **Karim (KaReem Elhlag) Abdelhady** as part of `NexuseCore-ui-ux`.

Use this procedure whenever a UI behavior may be reused. It is a design and review contract, not permission to add a large component library.

## Create or reuse

1. Search `src/components/ui` and nearby feature code for an equivalent behavior.
2. If an equivalent exists, extend it with a typed variant or compose it. Do not create a second component with a new name for the same job.
3. If no equivalent exists, create the smallest component under `src/components/ui`, using existing tokens, `cn()`, Lucide icons, and shadcn conventions already present in the app.
4. Define the public API before styling: required data, callbacks, controlled/uncontrolled state, pending/error states, keyboard behavior, RTL behavior, and responsive contract.
5. Add a focused test for the risky behavior and at least one usage example in the real feature. Do not add a showcase-only demo.
6. Run the UI audit and TypeScript test before promoting the component as canonical.

## Promotion checklist

- Does it remove real duplication from at least two surfaces?
- Is the name based on behavior rather than one page or business module?
- Can it handle loading, disabled, error, keyboard focus, RTL, and mobile wrapping?
- Does it preserve the existing visual tokens and permission boundaries?
- Is motion optional and reduced when the user requests reduced motion?

## Rejected patterns

- Copying shadcn source into multiple feature folders.
- A component that owns API calls, routing, and visual rendering at the same time.
- A generic `Universal*` component with dozens of feature-specific flags.
- A visual-only wrapper that does not remove meaningful duplication.
