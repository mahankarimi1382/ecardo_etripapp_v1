# Travel Foundation — TRAVEL-FOUNDATION-001

Status: foundation implementation only.

## Included

- Feature-oriented Travel foundation under `lib/src/features/travel/`.
- Design tokens for color, typography, spacing, radius, borders, elevation and shadows.
- Shared `TravelCard`, `TravelButton`, `TravelInput`, `TravelSkeleton`, `TravelEmptyState` and `TravelErrorState`.
- Canonical route contracts for future Travel domains.
- Extensible shell widget and a foundation-only route.
- Web build/test workflow documentation.

## Intentionally not included

- Travel Home redesign.
- Hotel, Flight, eSIM or Tour main screens.
- New API calls.
- Booking/payment behavior changes.
- Tour API fabrication.
- eSIM purchase enablement.

## Migration rule

The existing screens under `lib/src/presentation/screens/travel/` remain the
compatibility surface during this phase. They will be migrated incrementally,
with tests and a phase report, after product/API contracts are approved.
