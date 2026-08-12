# Travel Feature Foundation

This directory is the feature-oriented foundation for the eTrip Travel module.

## Current scope

- Design tokens and base theme
- Shared Travel UI components
- Canonical Travel route contracts
- Extensible Travel shell

The existing Travel screens under `lib/src/presentation/screens/travel/` are
intentionally preserved during this foundation phase. Domain screens will move
or be migrated only after their API and state contracts are approved.

## Explicit non-goals

- No Hotel/Flight/eSIM/Tour dashboard is implemented here.
- No new API endpoint is consumed.
- No mock booking or payment flow is introduced.
- No code is copied from `ecardo_userapp_v1` without an explicit migration decision.
