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

## Deployment status

There is no deployment job yet because the target host, deployment API and
secret contract were not provided. Adding a deploy step without those facts
would violate the no-guessing rule. The uploaded release artifact is the CD
handoff until a deployment target is approved.
