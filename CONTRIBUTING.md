# Contributing

This is the restaurant app of Wasli: the screens restaurant staff use to receive and answer orders. The backend is a
separate repository and the customer app is a sibling repository; this one holds only the restaurant app. Changes are
kept small, reviewed and verified.

## Ground rules

- **The backend decides, the app renders.** The app never builds chat text, never computes a price and never decides an
  order status change. It sends accept or reject and shows what the server returns.
- **The generated client is the only way to reach the API.** `lib/api` and `api/openapi.yaml` are never edited by hand;
  a change to the contract goes through the backend first, then this repository pins the new release.
- **Layers and folders.** `lib/` is `app/`, `core/`, `theme/`, `api/` (generated) and `features/<feature>/` with
  `domain`, `data`, `application` and `presentation`. `core`, `theme` and `api` never import `features` or `app`; a
  feature never imports another feature's `data` or `presentation`; `domain` is pure Dart. `scripts/check-boundaries.sh`
  enforces this (run it locally; CI runs it too).
- **Personal data** (customer position, car plate, notes, staff tokens) is never logged, never written to disk by the
  app beyond the token store, and never appears in tests, fixtures, issues or pull requests. Use invented data.

## Branching and pull requests

- `main` is the released state; `develop` is the integration branch and the default branch. Neither accepts direct
  pushes.
- Work on a short-lived topic branch (`feat/…`, `fix/…`, `docs/…`, `ci/…`, `chore/…`, `deps/…`) and open the pull
  request against **`develop`**. One branch is one reviewable change.
- Only a `develop` → `main` pull request may target `main`; it is the release.
- Merge with a **merge commit**. Squash and rebase merging are disabled.
- Fill in the pull request template and use a Conventional Commit title.
- The **CI passed** check must be green before merging.
- A change to `api/openapi.yaml` must include the regenerated `lib/api` in the same pull request.

## Before you start

The git hooks are registered when the dev container is created (`pnpm install`). To register them again:

```bash
pnpm install
```

## Commit messages

[Conventional Commits](https://www.conventionalcommits.org/), enforced by commitlint locally (the `commit-msg` hook) and
in CI for every commit of a pull request:

```text
feat(orders): add the incoming orders list
fix(auth): clear the session after a 401
docs(readme): describe the local backend setup
build(deps): bump the commitlint group
```

Valid types: `feat` `fix` `docs` `style` `refactor` `perf` `test` `build` `ci` `chore` `revert` `wip`. The type is
lower-case, the subject is imperative, is not sentence-, start-, Pascal- or upper-case, has no trailing period, and the
header is at most 100 characters. A breaking change is `feat!:` with a `BREAKING CHANGE:` footer.

## Checking your change locally

Run these in the dev container; they are the same checks as CI:

```bash
dart format --set-exit-if-changed .
flutter analyze --fatal-infos
flutter test
scripts/check-boundaries.sh
```

The commit hooks run the format, analyze and test checks. Fix what they report; do not bypass them.

## Code style

- Dart files are `snake_case.dart`, lines are at most 120 characters, indentation is 2 spaces, and `very_good_analysis`
  is the lint set (`analysis_options.yaml`).
- Public APIs have doc comments. No `// ignore` without a reason, no `TODO` without an issue number.
- No hard-coded UI strings (ARB files for `en` and `ar`), no raw colours or magic numbers (use the theme tokens),
  directional APIs only (`EdgeInsetsDirectional`), and every new screen is checked in both text directions.
- Tests use invented data, never call the real backend, and use deterministic clocks.

## Spelling

`cspell.json` configures the spell checker. Add a genuine project word (a name, a tool, a technical term; never a typo)
to `.cspell/project-words.txt`, lowercase and in alphabetical order.

## Workflows and scripts

- Shell scripts and hooks use LF line endings and are executable in Git; a CRLF script fails inside the container.
- GitHub Actions are pinned to a full commit SHA with a `# vX.Y.Z` comment. Workflows use least-privilege
  `permissions:`, `persist-credentials: false` on checkout, `timeout-minutes` on every job, and `${{ }}` values reach
  `run:` scripts through `env:`, never inline.
- Only the signed Android build job may use the signing secrets, and only the release-draft job may have
  `contents: write`.
- Every build runs in one place and is never repeated for the same change: a pull request into `develop` builds the
  web app (and the Android test builds when it changes `android/` or `pubspec.*`), a merge into `develop` and a pull
  request into `main` build nothing, a merge into `main` builds the release, and a staging build is started by hand
  (Actions → Build → Run workflow). Keep a new workflow to the same rule. Details: `docs/environments.md`.

## Bugs and feature requests

Use the issue templates under **New issue**. Problems with the base dev image belong in
[`flutter-devcontainer`](https://github.com/alihaidar0/flutter-devcontainer/issues).

## Security issues

Do not open a public issue for a vulnerability. See [`SECURITY.md`](SECURITY.md).

## Conduct

Participation is governed by the [Code of Conduct](.github/CODE_OF_CONDUCT.md).
