# Security Policy

## Scope

This repository is the Wasli restaurant app, used by restaurant staff to receive and answer orders from customers
parked at the restaurant. The app shows personal data of customers (position, car plate, notes) to the staff of the
restaurant that received the order, so reports about the following are taken seriously:

- Secrets or credentials committed to the repository or its history
- A way for one restaurant's staff to see or change another restaurant's orders through the app
- Storage or logging of a staff token or of customer data outside what the app needs
- A GitHub Actions workflow that could allow unauthorized code execution or exfiltration of secrets (for example
  script injection through untrusted input, or an unpinned third-party action)
- A dependency (pub, npm or GitHub Action) with a known critical vulnerability that affects the app

Rules about who may see which order are enforced by the backend, which has its own repository and policy. If a report is
about the API itself, say so and it will be passed on.

## Supported versions

Only the latest release of the app and the latest commit on `develop` are supported.

## Supply chain

- Every GitHub Action is pinned to a full commit SHA. Workflows run with least-privilege `permissions:` and
  `persist-credentials: false`, and `${{ }}` values reach scripts only through `env:`.
- Dependabot proposes updates weekly with a 7-day cooldown. Pull requests scan every resolved package in
  `pubspec.lock` against the OSV vulnerability database, and `actionlint` and `zizmor` check the workflows.
- The npm dependencies (Husky, commitlint) are locked in `pnpm-lock.yaml`.
- Only public values are compiled into the app (`env/*.json`). Signing keys and deployment credentials live in GitHub
  environment secrets, never in the repository.

## Reporting a vulnerability

**Please do not open a public issue for a security vulnerability.**

Report it privately through GitHub:
**Security → Report a vulnerability** on this repository (private vulnerability reporting). Include:

- A description of the vulnerability and its potential impact
- Steps to reproduce (a minimal example is ideal), using invented data only: never send real customer or restaurant
  data
- A suggested fix, if you have one

Expect an initial response within **5 business days**. Once the report is confirmed, a fix will be prioritized and a
GitHub Security Advisory published when a patch is available.
