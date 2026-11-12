## Summary

<!-- What does this PR change and why? A few sentences, then bullets for the details a reviewer should look at. -->

## Type of change

- [ ] New feature
- [ ] Bug fix
- [ ] Refactor (no behaviour change)
- [ ] Tests only
- [ ] Backend contract bump (new pinned release in `api/`, regenerated `lib/api`)
- [ ] Dependency or toolchain bump
- [ ] CI / dev container / repository automation
- [ ] Documentation only
- [ ] Other (describe above)

## How it was verified

<!-- Commands run and their result (format, analyze, test, boundaries, a manual run on web or the emulator), or why CI alone is enough. -->

## Screenshots

<!-- Invented data only. Write "Not applicable: no UI change." when there is none. -->

## Breaking change

- [ ] This change breaks existing data or behaviour (use a `feat!:` or
`fix!:` commit type and a `BREAKING CHANGE:` footer; the `breaking
change` label is added automatically)

## Checklist

- [ ] This PR targets `develop` (only the `develop` → `main` release PR
targets `main`)
- [ ] The **CI passed** check is green
- [ ] `dart format`, `flutter analyze --fatal-infos` and `flutter test`
pass locally
- [ ] New or changed logic has tests (unit tests for domain logic,
widget tests for screens)
- [ ] A change to `api/openapi.yaml` includes the regenerated `lib/api` and
names the backend release it was built against
- [ ] Money is handled as integer minor units with a currency (no
`double`), and times are UTC until they are displayed
- [ ] No real customer, restaurant or personal data in code, tests,
screenshots or logs
- [ ] User-facing text is in the ARB files, and the UI keeps semantic
labels, contrast and scalable text
- [ ] New dependencies are pinned in `pubspec.yaml`, `pubspec.lock` is
committed, and new GitHub Actions are pinned to a full commit SHA with a
`# vX.Y.Z` comment
- [ ] `README.md`, `docs/` and `docs/steps.md` are updated where the
change affects them
- [ ] The title is a Conventional Commit (labels are added from it and
drive the release notes), or `skip-changelog` if this should not appear in
them

## Related issues

<!-- Closes #123, or "None." -->
