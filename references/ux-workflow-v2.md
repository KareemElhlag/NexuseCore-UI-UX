# UX Workflow v2

Use this record before coding a non-trivial UI change. It is designed to reduce repeated exploration and prevent a
polished screen with no real workflow behind it.

## Fast intake block

| Fact | Record |
|---|---|
| Actor and job | who is trying to do what |
| Entry | route, permission, entitlement |
| Primary action | one observable action |
| Success | durable state or supported navigation |
| Failure recovery | retry, correction, escalation |
| Data owner | API/service/persistence owner |
| Risk | money, stock, privacy, permission, or operational cost |

## Exploration order

1. Search route, service, DTO, permission, shared primitive, and nearest test.
2. Read bounded slices around the decision points; do not scan unrelated files.
3. Draw the smallest UI → service → API → persistence path.
4. Identify the single owner for state, mutation, and visual primitive.
5. Establish a baseline before visual or interaction edits.

## State matrix

Every data surface explicitly defines loading, empty, error/retry, permission denied, pending/disabled, success/readback,
and stale/conflict behavior. A state is not complete because it has a spinner; it is complete when the user knows the
next safe action.

## Acceptance loop

1. Type/build and focused component/route tests.
2. API contract and mutation/readback verification.
3. Keyboard and focus order.
4. RTL and mixed Arabic/Latin content.
5. 1280px, 768px, and 390px layout checks.
6. Console/network error check.
7. Baseline versus changed performance record.
8. Decision: `ACCEPTED`, `ACCEPTED WITH FOLLOW-UP`, `REJECTED`, or `BLOCKED`.

Do not call a visual-only success a feature success when the primary action has no supported durable behavior.
