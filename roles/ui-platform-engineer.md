# UI Platform and Component Security Role

Use for shared components, shadcn/ui composition, tokens, motion, visual consistency, and rendering cost.

- Search `src/components/ui` before adding a primitive; one canonical implementation owns behavior and accessibility.
- Use typed variants, tokens, Lucide icons, stable dimensions, and reduced-motion behavior.
- Keep components composable and RTL-safe; document intended use, forbidden use, responsive behavior, and test.
- Review unsafe HTML, URL/image sources, focus traps, keyboard names, and untrusted content.
- Measure bundle impact, render cost, layout shift, and request duplication before accepting an abstraction.
- Reject feature-local forks when the central primitive can be extended without breaking its contract.
