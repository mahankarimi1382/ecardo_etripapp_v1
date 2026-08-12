# Travel Web CI/CD

## Current pipeline

`.github/workflows/web.yml` runs on:

- push to `main`
- push to `develop/travel-redesign`
- pull requests targeting either branch
- manual dispatch

The workflow:

1. Checks out the repository.
2. Installs Flutter 3.44.6.
3. Enables Web.
4. Scaffolds only the missing Web platform files in CI.
5. Runs `flutter pub get`.
6. Generates localization.
7. Checks Dart formatting.
8. Runs `flutter analyze`.
9. Runs `flutter test`.
10. Builds a release Web artifact.
11. Uploads the Web build and logs.

## Web API routing

Web builds use same-origin API paths by default:

```text
/api                 → https://ecardo.ir/api
/travel-api/v1       → https://trip.ecardo.ir/api/v1
```

The hosting layer must proxy these paths to the corresponding HTTPS APIs. This
keeps browser requests same-origin and avoids relying on an unapproved CORS
allow-list. Native builds continue to use the public HTTPS URLs directly.

The paths can be overridden for staging/preview builds with:

```text
ECARDO_MAIN_API_BASE_URL
ECARDO_TRAVEL_API_BASE_URL
```

## Deployment status

There is no deployment job yet because the target host, deployment API and
secret contract were not provided. Adding a deploy step without those facts
would violate the no-guessing rule. The uploaded release artifact is the CD
handoff until a deployment target is approved.
