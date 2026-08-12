# Travel Route Contract

Canonical route descriptors live in:

```text
lib/src/features/travel/routing/travel_route_contract.dart
```

## Rules

1. A route contract is not an implemented screen.
2. A route becomes active only after its screen, API, state and test contracts are complete.
3. Product routes must not be inferred from backend availability.
4. Existing `/travel_route`, `/travel_history_route` and `/travel_account_route`
   remain backward-compatible routes during migration.
5. New domain routes are additive until the replacement screen is approved.

## Foundation route

```text
/travel_foundation_route
```

This route only verifies that the shell and route infrastructure are wired. It
intentionally renders a foundation placeholder and is not a product dashboard.
