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

- [ ] Targets `develop` (only the release PR targets `main`)
- [ ] **CI passed** is green
- [ ] `dart format`, `flutter analyze --fatal-infos` and `flutter test` pass locally
- [ ] New or changed logic has tests
- [ ] A change to `api/openapi.yaml` includes the regenerated `lib/api` and the backend release
- [ ] Money is integer minor units with a currency; times are UTC until displayed
- [ ] No real customer, restaurant or personal data
- [ ] User-facing text is in the ARB files; the UI keeps labels, contrast and scalable text
- [ ] Dependencies are pinned and `pubspec.lock` is committed; new Actions are pinned to a SHA
- [ ] `README.md`, `docs/` and `docs/steps.md` are updated where affected
- [ ] The title is a Conventional Commit (or `skip-changelog`)

## Related issues

<!-- Closes #123, or "None." -->
