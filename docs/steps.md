# Steps

The build plan of the Wasli restaurant app, from the empty template to the product. Every step is a checkbox:
tick it (`- [x]`) in the same pull request that does the work. Steps are added, changed or removed as the project
moves; when a step is removed because it no longer applies, say why in the pull request.

- Phases follow the backend milestones (D0 to D4, then pilot). A phase that depends on a backend release names it.
- **Decide** marks a choice the project owner makes before the step can start.
- One topic branch per reviewable change (`feat/...`, `chore/...`, `ci/...`, `docs/...`), pull request into `develop`,
  merged with a merge commit. The suggested branch name is given where a phase is one change.

Guides used by these steps: [`README.md`](../README.md) (sections 2, 3, 7 and 9),
[`github-setup.md`](github-setup.md), [`environments.md`](environments.md),
[`android-signing.md`](android-signing.md), [`consuming-the-api.md`](consuming-the-api.md).

---

## Phase 0: Repository from the template

- [x] Create `wasli-restaurant-flutter` from `flutter-template` (**Use this template**, private, `develop` only)
- [x] Clone it with the SSH alias remote `git@github.com-personal:Aalihaidar/wasli-restaurant-flutter.git`
- [x] Open it in the dev container (image pulled, `pnpm install` registered the Husky hooks)
- [x] `main` created from `develop` by the **Bootstrap main** workflow
- [x] Check that the **Labels** workflow created the labels (**Actions → Labels**; if missing: `gh workflow run labels.yml`)
- [x] Check that **Bootstrap main** finished without errors
- [x] Check the first Dependabot pull requests (if any) and merge or close them before the scaffold

## Phase 1: Local setup in the container

- [x] Set the git identity **repository-locally** (today it comes from the global `~/.gitconfig`):
      `git config --local user.name ...`, `git config --local user.email ...`, then check with
      `git config --show-origin --get user.email` (must show `.git/config`)
- [x] SSH key of the right account: `ssh -T git@github.com-personal` greets `Aalihaidar`
      (else `scripts/pin-ssh-key.sh --key SHA256:...`)
- [x] `gh auth login` inside the container (needed to download the private backend contract)
- [x] `flutter doctor -v` is green for Android and web (Xcode is not expected on Linux)

## Phase 2: Flutter scaffold (D0), branch `feat/initial-app`

- [x] **Decide** the platforms created now: **web, Android and iOS** (decided 2026-11-12)
- [x] `flutter create --org com.alihaidar --project-name wasli_restaurant --platforms web,android,ios .`
- [x] Application ID `com.alihaidar.wasli.restaurant` as the Android `applicationId` and in every iOS
      `PRODUCT_BUNDLE_IDENTIFIER` of `ios/Runner.xcodeproj/project.pbxproj` (keep the `.RunnerTests` suffix on the test
      target), **before the first commit**; leave the Android `namespace` as generated (`flutter create` gives iOS
      `com.alihaidar.waslirestaurant`, without the dot, so it must be changed)
- [x] Flavors `staging` (suffix `.staging`) and `production` with their signing configs in
      `android/app/build.gradle.kts`, and remove the generated `release { signingConfig ... }` block
      ([`android-signing.md`](android-signing.md) section 2)
- [x] `default-flavor: staging` in `pubspec.yaml`, and check that a web run and an Android run still start
- [ ] iOS flavors (Xcode schemes `staging` and `production`, a bundle ID per flavor) need a Mac and are **not** set up
      now; until they are, `default-flavor` makes an iOS build fail, so the `BUILD_IOS` variable stays unset
      ([`environments.md`](environments.md), "Not set up yet")
- [x] Debug-only cleartext exception for `10.0.2.2` and `localhost` (`android/app/src/debug/`, see
      [`consuming-the-api.md`](consuming-the-api.md) section 5), so the emulator reaches a local backend
- [x] `flutter pub get` (creates `pubspec.lock`, which switches CI to its full checks)
- [x] Freeze the toolchain: `scripts/pin-image.sh` (pins the image digest in `docker-compose.yml` and
      `environment: flutter:` in `pubspec.yaml`)
- [x] `version: 0.1.0+1` in `pubspec.yaml`
- [x] **Decide** the lint set: `very_good_analysis` (decided 2026-11-12)
- [x] `flutter pub add --dev very_good_analysis`; strict `analysis_options.yaml` that includes it, with `strict-casts`,
      `strict-inference`, `strict-raw-types`, formatter width 120 and `lib/api/**` excluded when it is generated
- [x] Boundary check: `scripts/check-boundaries.sh` for the folder rules (`core`, `theme`, `api` never import `features`
      or `app`; features never import each other's `data`/`presentation`), run in CI as the **Folder boundaries** job
- [x] Web entry point uses `usePathUrlStrategy()`
- [x] Replace the generated counter app with a minimal placeholder page (`lib/main.dart` calls `bootstrap()`) and one
      passing test in `test/`
- [ ] `env/staging.json` (written) and `env/production.json` (waits for the production URLs) (public values only: `API_BASE_URL`, `CUSTOMER_SITE_URL`,
      `RESTAURANT_SITE_URL`); the names listed in `.env.example`
- [x] `.vscode/launch.json`: `--dart-define=API_BASE_URL=http://localhost:8000` for web and
      `http://10.0.2.2:8000` for the emulator (the server address only, no path)
- [x] Quality gates pass: `dart format --set-exit-if-changed .`, `flutter analyze --fatal-infos`, `flutter test`
- [x] Run it: `flutter run -d web-server --web-port 8080` opens in the host browser

### Replace the template files (same branch or a `chore/` branch right after)

- [x] `.github/CODEOWNERS`: `@alihaidar0` → `@Aalihaidar`
- [x] `.github/dependabot.yml`: `assignees` → `Aalihaidar`; uncomment the `pub` and `docker-compose` blocks
- [x] `README.md`: `scripts/init-readme.sh --description "..."` (after `pin-image.sh`), then add the project sections
- [x] `LICENSE`: all rights reserved (proprietary), decided 2026-11-12
- [x] `SECURITY.md`, `CONTRIBUTING.md`: rewrite for this app
- [x] Delete `CHANGELOG.md` (the changelog is the GitHub Releases page)
- [x] `package.json` `name` → `wasli-restaurant-flutter`
- [x] `scripts/welcome.sh`: banner title and link
- [x] `.cspell/project-words.txt`: add the project's own words (`wasli`, `fils`, ...)
- [x] Delete the template-only files: `.github/workflows/image-contract.yml`, `.github/scripts/check-image-contract.sh`,
      `.github/workflows/release.yml`, the `template-guard` job of `ci.yml` (and its entry in `CI passed`), and
      `.github/workflows/bootstrap-main.yml` (`main` exists)
- [x] Keep or trim `docs/` (template guides stay useful as reference)

### Android signing and environments (before the merge)

With the flavors in place, a merge into `main` and a manual staging run build signed files, which stop without their keys.
Prepare these first ([`android-signing.md`](android-signing.md) sections 1 and 3):

- [ ] Two keystores outside the repo (or in the ignored `.signing/`) with distinctive aliases
      (`wasliresto-staging`, `wasliresto-upload`), each with its own password; both **backed up** in a password manager
- [ ] `android/key.staging.properties` and `android/key.production.properties` locally (ignored by Git)
- [x] GitHub environments `staging` and `production` exist (the branch restriction and administrator bypass off need
      GitHub Pro, Phase 3)
- [x] In each environment: secrets `ANDROID_KEYSTORE_BASE64`, `ANDROID_STORE_PASSWORD`, `ANDROID_KEY_PASSWORD`,
      `ANDROID_KEY_ALIAS` and the variable `ANDROID_CERT_SHA256` (public fingerprint); the signed builds on `develop`
      and `main` pass, so the values work (the secrets themselves are not readable through the API)

### Merge

- [x] Pull request into `develop` (#1); **CI passed** green; web, APK and AAB test builds produced by `build.yml`
- [x] Merged with **Create a merge commit**
- [x] Signed staging build succeeded, the draft release "Staging" holds three APKs, the App Bundle and the web zip;
      `build.yml` verifies the signature with `apksigner`
- [x] First release: `develop` promoted to `main` (#11, 2026-11-18), signed production build green, draft release
      `v0.1.0` filled with the same files; nothing published (draft)
- [x] Build once per purpose (branch `ci/build-once-per-purpose`): a pull request into `develop` builds the web app, and the
      Android test builds only when it changes `android/` or `pubspec.*`; a merge into `develop` and the release pull request
      into `main` build nothing; a merge into `main` builds the release once; a staging build is a manual run from `develop`
      (production only from `main`); the **Labels** workflow runs on `develop` only (`docs/environments.md`)

### Checks for the build-once rule (tick each one the first time it is seen on GitHub)

Each check is done by the work that normally happens anyway; write the date and the run or pull request next to the tick.
Look at the **Actions** tab (or `gh run list`) and tick only what was seen.

- [x] (a) A pull request that changes the build workflow runs **Build**, including the Android test builds, which proves
      the `detect` step and its `pull-requests: read` permission (2026-11-19, pull request #12)
- [x] (b) A pull request that changes only documentation shows **no Build run** (2026-11-19, pull request #13: **CI** and
      **PR labels** ran, **Build** did not)
- [x] (c) A pull request that changes only Dart code runs the web build and **skips** the two Android jobs (2026-11-25,
      pull request #19: **Web** ran, both Android jobs were skipped; #18, which changed `pubspec.yaml`, ran them)
- [x] (d) A merge into `develop` starts **no Build run** (2026-11-19, merge of #12: no Build run after it)
- [ ] (e) **Actions, Build, Run workflow** from `develop` with `staging` works and refreshes the draft "Staging"
- [ ] (f) A manual run of `production` from `develop`, or of `staging` from a topic branch, fails at once with the
      "Wrong branch for this environment" message
- [ ] (g) The release pull request `develop` → `main` runs **CI** only, no Build
- [ ] (h) The merge of the release pull request into `main` runs **one** Build and fills the draft `v<version>`

## Phase 3: GitHub repository settings (after the first pull request has run CI)

The repository is normally **private** on the **GitHub Free plan** (owner, 2026-11-13). It was made **public on
2026-11-20** because the monthly Actions allowance ran out, and it will become private again later. Settings are changed
by the owner in the web UI; they are read back with read-only `gh` calls. Items marked **needs GitHub Pro (or public)**
are only available while the repository is public (rulesets, environment branch rules, secret scanning, CodeQL, private
vulnerability reporting). When the repository becomes private again, read these settings back and update this list and
[`github-setup.md`](github-setup.md) ("Repository visibility").

- [x] **General**: default branch `develop`; template repository off; merge commits on, squash and rebase off; suggest
      updating branches, auto-merge and delete head branches on; wiki, projects and discussions off (read back 2026-11-13)
- [x] **Actions → General**: selected actions only (GitHub-created plus `raven-actions/actionlint@*`,
      `zizmorcore/zizmor-action@*`, `google/osv-scanner-action/*`; Marketplace verified creators off); full-SHA pinning
      required; read-only workflow permissions; Actions may not create or approve pull requests; 30-day retention (read
      back 2026-11-13)
- [x] Fork pull request approval: all external contributors (read back 2026-11-20, while the repository is public;
      GitHub does not offer the setting on a private repository)
- [x] **Code security, free part**: Dependabot alerts on (read back 2026-11-13)
- [x] **Code security, rest**: Dependabot security updates on (read back 2026-11-20); the dependency graph is not
      readable separately by the API
- [x] **Needs GitHub Pro (or public):** secret scanning with push protection on, private vulnerability reporting on,
      CodeQL default setup configured for the language Actions (read back 2026-11-20, repository public). They stop
      being available when the repository is private again
- [x] **Needs GitHub Pro (or public):** rulesets `main-protect`, `develop-protect`, `tags-protect` imported and active,
      with an empty bypass list (read back 2026-11-20; [`github-setup.md`](github-setup.md) section 5). While the
      repository is private on the Free plan, `develop` and `main` are protected only by the local `pre-push` hook and
      by never pushing to them
- [ ] **Needs GitHub Pro (or public):** verify the protection ([`github-setup.md`](github-setup.md) section 7): direct
      pushes to `main`/`develop` are rejected, a topic branch into `main` fails **Verify source branch**,
      `Fixed stuff` fails **Commit messages**
- [x] Environments `staging` and `production` exist (read back 2026-11-13)
- [x] **Needs GitHub Pro (or public):** `staging` restricted to `develop` and `production` to `main` (read back
      2026-11-20, repository public)
- [ ] Administrator bypass is still on for both environments (read back 2026-11-20): untick **Allow administrators to
      bypass configured protection rules**
- [ ] Add the web deploy secrets to the environments when the hosting is decided (Phase 6)
- [x] Backend contract check: repository variable `BACKEND_REPO` and secret `BACKEND_READ_TOKEN` (fine-grained,
      read-only Contents on the backend repository only), added by the owner 2026-11-13 (they cannot be read through the
      API, so this is taken from the owner)
- [x] Run **Backend contract** once by hand (Actions → Backend contract → Run workflow). Done 2026-11-14: green in 9 s,
      "no published release yet; nothing to compare", because the backend's `v0.1.0` is still a draft (Phase 4). The run
      read the private backend with `BACKEND_READ_TOKEN`, so the variable and the token work
- [x] Expiry of `BACKEND_READ_TOKEN`: the owner created it **without an expiry** (2026-11-14), so there is no date to
      renew. It is read-only on the backend repository, so replace it only if it leaks or the backend repository
      changes (an invalid token fails the weekly run on purpose)

## Phase 4: Backend contract and generated client (D1, backend `v0.1.0`), branch `feat/api-client`

- [x] **Decided (owner, 2026-11-14):** the backend keeps `v0.1.0` as a draft until the whole backend is finished (on
      2026-11-13 it is an unpublished draft without the `openapi.yaml` asset, and the backend has no tags). Until a
      release with that asset is published, this app pins the contract file `openapi/schema.yaml` by backend commit:
      `scripts/sync-api.sh --commit <sha>`, which records the full SHA in `api/BACKEND_VERSION`. Both apps pin the same
      commit, each through its own pull request. The weekly check finds no published release and does nothing until
      then; pinning by release tag (`scripts/sync-api.sh vX.Y.Z`) starts once a release is published
- [x] `api/BACKEND_REPO` with the backend repository (`OWNER/REPO`)
- [x] `flutter pub add dio retrofit json_annotation`
- [x] `flutter pub add --dev build_runner json_serializable retrofit_generator swagger_parser`
- [x] `swagger_parser.yaml` rewritten for `swagger_parser` 2.x (the template's keys belong to the 1.x series). It generates
      only this app's endpoints: `operation_filters.include_paths` lists `/api/v1/config`, `/api/v1/auth/**` and
      `/api/v1/staff/**` (the staff paths match nothing until a pin contains them, which is `a139e8a` below), and `prune_unused_models` drops the
      models only the other endpoints use. Enums keep an `Unknown` case (`unknown_enum_values: preserve`)
- [x] `scripts/sync-api.sh --commit a4f8591dab8d07aa97f6aec5b31b1293088b4255` (the head of the backend `develop` on
      2026-11-14, the same commit the customer app pins; its `openapi/schema.yaml` was last changed at `7793413`):
      writes `api/openapi.yaml` and `api/BACKEND_VERSION`, and `scripts/generate-api.sh` generates `lib/api` (only the
      `config` client, since the pinned contract has no staff endpoint yet). `info.version` in the pinned file reads
      `0.1.0`
- [x] `lib/api/**` is excluded from analysis (since Phase 2); `flutter analyze --fatal-infos` reports nothing
- [x] Commit `api/` and `lib/api` together (#6); the **API client is current** job is green
- [ ] Fixture for `GET /config` with invented values taken from the contract example
- [x] Moved the pin from `a4f8591` to `2f36d7212eab9815dd4dd67271306a544c0d9518` (backend `develop`, 2026-11-23) in its
      own pull request with `scripts/sync-api.sh --commit <sha>`. `lib/api` is unchanged: the config schema did not change
      and the new paths (chat, `order_type`) are outside this client's paths. The contract now has `service_radius_m` on
      the restaurant detail and on `nearest`, `parking_lot` removed from both (breaking, customer side only), nested menu
      categories, `order_type` on conversations and orders, and the error code `phone_not_verified`. The backend still has
      no staff path (D3)
- [x] Moved the pin from `2f36d72` to `a139e8ab3342fab007ab9827ddc287997af9446e` (backend `develop`, PR #96, Round 8 of
      the staff orders topic) in its own pull request with `scripts/sync-api.sh --commit <sha>`. It is the first pin with
      staff paths: `lib/api` now has the `auth` client (`POST /auth/login`, `POST /auth/logout`, `POST /auth/password`)
      and the `staff` client (`GET /staff/me`, `GET /staff/orders?since=`) with their models (`StaffOrder`,
      `StaffOrderItem`, `StaffOrderOption`, `StaffVehicle`, `StaffLocation`, `StaffOrderList`, `StaffMe`, the status,
      order type, distance band, role and permission enums). Accept and reject are not in this pin yet. No app code uses
      the new clients yet
- [ ] **Backend:** when the backend publishes `v0.1.0` with its `openapi.yaml` asset, run `scripts/sync-api.sh v0.1.0`
      in a pull request of its own and compare the diff with the commit pin (it should be empty or explained)

## Phase 5: App foundation (D1)

Each item is its own small pull request.

- [x] Packages: `flutter_riverpod` 3.5.0, `go_router` 18.1.4, `intl` 0.20.3, `flutter_localizations` (Flutter SDK),
      added with `flutter pub add`; nothing imports them yet
- [x] **Decide** providers and value classes: hand-written Riverpod providers, plain Dart 3 classes, no `freezed` or
      `equatable`, no `riverpod_generator` (decided 2026-11-12)
- [x] `app/`: `bootstrap()` reads `AppEnvironment` once (a wrong build-time value shows a plain error screen and the app
      does not start), runs the app in a `ProviderScope` that overrides `appEnvironmentProvider`, and reports uncaught
      errors by their type only; `go_router` with one placeholder route (`appRouterProvider`)
- [ ] App shell: the page frame with the responsive size classes and the navigation, after `theme/` and the layout helpers
- [x] `core/config`: `AppEnvironment` reads `APP_ENV` (then the flavor); unknown counts as staging
- [x] `core/network`: Dio factory with timeouts; interceptors for the auth header (never on public endpoints),
      `X-Request-ID`, locale, redacted logging (no tokens, bodies or query strings); retry with backoff for reads only
      (never a `429`, never a call that changes something); `guardRequest` turns a failed call into a `Failure`. The
      Dio client takes the server address without a path (the generated paths start with `/api/v1`)
- [x] **Decided (owner, 2026-11-25):** `API_BASE_URL` is the server address only, with no path (for example
      `https://wasli-staging.onrender.com`), because the generated paths already start with `/api/v1`. `AppEnvironment`
      refuses a value with a path at start, `env/staging.json`, `.env.example` and `.vscode/launch.json` follow, and a
      test sends the generated `GET /config` through the parsed value and checks the URL `.../api/v1/config`
- [x] `core/error`: sealed `Failure`, error-body parser, code → failure mapper (unknown code and non-JSON body =
      generic failure of the status)
- [x] `core/storage`: `TokenStore` interface (`read`, `write`, `clear`) and the in-memory implementation, the interim
      store on the web (the token is gone when the page reloads); `tokenStoreProvider` gives the in-memory store until a
      platform store overrides it. The token never reaches `shared_preferences`, a log or a `toString`
- [ ] `flutter_secure_storage` implementation of `TokenStore` for Android, iOS and Windows (Android backups exclude it;
      cleared on logout and on a `401`), chosen where the app is assembled
- [x] `core/format`: money from integer fils (`AED 12.50` / `12.50 د.إ`, thousands grouped, sign kept, any other currency
      as its code), UTC → Asia/Dubai as a fixed +4 h (no daylight saving, no time-zone package) with `HH:mm` and
      `YYYY-MM-DD`, Western digits in both languages. Distance, plate and "time since placed" come with the orders feature
- [x] `core/logging`: `AppLogger` interface without personal data (a failure writes the error's type, never its message;
      debug is dropped in a release build), `SinkLogger` with the developer-console sink, and the `CrashReporter` hook
      (no-op until a service is chosen). `bootstrap` reports uncaught errors through them
- [x] `theme/` colours and tokens: the Ink & Mustard `ColorScheme` in light and dark, the `WasliColors` extension for the
      colours without a Material slot (accent, muted, borders, link, focus ring, the four status pills; read as
      `context.wasli`), the spacing, radius and motion tokens, and `lightTheme`/`darkTheme` (the app follows the system
      setting). A test checks the contrast of every text pair (4.5:1) and of the input outline and focus ring (3:1)
- [x] `theme/` typography: Rubik, the variable font (`wght` 300 to 900, SIL Open Font License 1.1, from the Google Fonts
      repository, upstream `googlefonts/rubik` at `9167c98`), bundled in `assets/fonts/` with its licence text; the ten
      text styles of the design (`WasliTextStyles`, read as `context.wasliText`) mapped onto all 15 Material text slots;
      Arabic with no letter spacing and a line height 0.1 taller (one constant, to remove if no clipping shows on a real
      screen); the licence is registered for the licence page. The themes now depend on the language
- [ ] A licence page reachable from a settings screen (`showLicensePage`), so the Rubik licence is shown to the user
- [ ] Check a long mixed Arabic and Latin line, and text scaled to 200 %, on the first real screens
- [ ] `theme/` component themes: buttons (48 high, 56 on the orders screen), inputs, cards, app bar, tabs, dialogs, the
      2 px focus ring
- [x] Responsive layout helpers in `theme/`: `WindowSize` (compact below 600, medium 600 to 839, expanded from 840;
      `context.windowSize`, the page `gutter` of 16 or 24, `isTwoPane` for list beside detail), the `WasliLayout` widths
      in `design_tokens.dart` and `WasliContentFrame` (gutter on both sides, content at most 1200 wide and centred).
      Tests check the class boundaries and the frame at three widths in both text directions
- [x] Localisation: `l10n/app_en.arb` and `app_ar.arb` with `flutter gen-l10n` (`l10n.yaml`, `generate: true`; the
      generated code is not committed), `AppLocales`, `LocaleController` (English at start, whatever the device uses, like
      the customer app), `context.l10n`, and the `material_ui` Material delegates so Arabic flips the layout to right to
      left and gives the framework widgets their Arabic labels. Only the app title exists so far; each screen adds its own
      messages. The Arabic title "وصلي للمطاعم" is a first wording for the owner to confirm
- [ ] Remember the chosen language between runs (`shared_preferences`, non-sensitive settings only): a `LocaleStore`
      interface with a platform implementation, and a language switch on a settings screen
- [ ] `GET /config` on start (without a token), with the "waking up the server" message after 3 s
- [ ] Staff login screen skeleton (username and password, no password auto-fill), not reachable from a route yet
- [ ] Unit and widget tests for each of the above (money formatting in both languages, error mapping, RTL smoke test)
- [x] **Decide** golden tests: yes, for the core widgets in Arabic and English, light and dark (decided 2026-11-12)
- [ ] Golden tests for the core widgets (`core/widgets` and the theme components), four variants each (en/ar,
      light/dark), generated in the dev container so they match Linux CI; Rubik bundled for the tests

## Phase 6: Staging web deploy

- [ ] **Decide** the hosting (Cloudflare Pages is the working assumption) and the staging site name
- [ ] Deploy workflow: staging from `develop`, production from `main`, pinned actions, `contents: read`, credentials as
      environment secrets
- [ ] The host serves `index.html` for unknown paths (path URL strategy)
- [ ] Security headers on the host (`_headers` or equivalent): strict CSP, no third-party scripts
- [ ] Backend CORS allows the staging origin (`https://wasli-restaurant-staging.pages.dev` today; change it with the
      backend if the hosting changes)
- [ ] Placeholder site live on staging

## Phase 7: Order screen on fake data (D2, backend `v0.2.0`)

- [ ] Pin `v0.2.0` (`scripts/sync-api.sh v0.2.0`) and fix what the compiler reports
- [ ] Orders feature skeleton (`features/orders/` with `domain`, `data`, `application`, `presentation`) on a fake
      repository with invented data
- [ ] Order card and detail layout: number, time since placed, items with options and notes, customer note box, total,
      plate in large type with model and colour, parking note
- [ ] List and detail side by side at medium/expanded, single column at compact; both text directions

## Phase 8: Restaurant side (D3, backend `v0.3.0`)

Before D3 freezes the staff order object, raise the backend requests (see "Backend requests" below).

- [ ] Pin the contract commit of each backend slice (login, logout, `staff/me` and password first; then the orders list;
      then accept and reject; the tag `v0.3.0` once published) and fix what the compiler reports
      (pinned so far: login, logout, password, `staff/me` and the orders list at `a139e8a`; accept and reject wait for
      the backend's next commit)
- [ ] Staff login (`POST /auth/login`, answers only the token), logout (`POST /auth/logout`), `GET /staff/me` right after
      login (role, permissions, `must_change_password`, restaurant); a `401` returns to login once; a `403` on
      `GET /staff/me` means the account has no restaurant membership any more
- [ ] Change password (`POST /auth/password`, `current_password` and `new_password`, `204`) when `must_change_password` is
      `true`; the other staff endpoints keep working meanwhile, the app decides how firmly to ask
- [ ] Hide or disable actions by role and permissions (`orders.view`, `orders.decide`, ...); the server stays the
      authority (`403 permission_denied`)
- [ ] Lifecycle-aware poller in `core/polling`: `GET /staff/orders?since=<server_time>` every `poll_interval_seconds`
      while visible; backoff on 429/5xx honouring `Retry-After`
- [ ] Merge orders by `id`, keeping the one with the latest `updated_at` (an order can arrive again with the same
      `updated_at`: same state), without rebuilding the whole list; send the previous `server_time` as `since`
- [ ] Orders list (new first, highlighted) and the "Decided" section
- [ ] Distance badge from `distance_band` (`in_lot` within the restaurant's service distance, `near`, `far`, `unknown`),
      always with the distance in metres, accuracy, age of the position
- [ ] Small map with the restaurant and the customer (`flutter_map`, OpenStreetMap on staging only), and a circle of
      `service_radius_m` around the restaurant when `GET /staff/me` sends it
- [ ] Accept dialog: 5, 10 or 15 minutes; button disabled while sending; never auto-retried
- [ ] Reject dialog: reason (preselect `too_far` on `far`, `location_unclear` on `unknown`), note required for `other`,
      at most 200 characters
- [ ] After a network failure or `409 order_invalid_transition`, poll at once with the last `server_time` and show the
      order from the answer (there is no `GET /staff/orders/{id}`)
- [ ] Start shift: unlocks sound (`audioplayers`), wake lock (`wakelock_plus`), behind platform interfaces
- [ ] New order plays a sound and stays highlighted; connection banner when polling fails
- [ ] Staging extras: Share dialog with QR codes for both sites (`qr_flutter`, deferred import); polling pauses after
      60 minutes without interaction ("Tap to resume")
- [ ] Clear cached orders and the token on logout
- [ ] Tests: polling rules (visible, hidden, idle pause), merge by `server_time`, reject dialog validation,
      accept/reject result states, distance badge variants, connection banner, Start shift
- [ ] Integration test against a fake server: login → new order appears → accept / reject
- [ ] Staging shown to restaurant managers

## Phase 9: Polish (D4, backend `v1.0.0`)

- [ ] Pin `v1.0.0`
- [ ] Arabic and English with RTL on every screen, all three size classes checked
- [ ] Accessibility pass (semantics, contrast, text scaling, 56 px action buttons)
- [ ] Optional Ready button (`POST /staff/orders/{id}/ready`)
- [ ] Measure the web bundle size; **decide** the budget and check it in CI
- [ ] Profile the orders screen in DevTools over a long session

## Phase 10: First production release

- [ ] Production site name and CORS origin decided and set on the backend
- [ ] `env/production.json` filled with the production public values
- [ ] Release pull request `develop` → `main` titled `release: ...`, `version:` raised in `pubspec.yaml`
- [ ] Production test build checked before merging
- [ ] Merged; draft release `v<version>` filled by `build.yml`; published on the Releases page
- [ ] Production deploy done; rollback path checked (redeploy the previous release tag)

## Phase 11: Before the pilot

- [ ] Real staff login on per-device tokens with a short lifetime (backend)
- [ ] Ready, Delivered, Can't find car, No-show, Block
- [ ] Sound that loops until Accept
- [ ] Idle prompt and logout timing on shared devices (**decide** the timing)
- [ ] Restaurant admin panel basics: orders and totals, reports, menu, prices, availability, settings, members with
      temporary passwords
- [ ] Keyed map tile provider (**decide**: MapTiler, Stadia Maps, ...)
- [ ] Error reporting without personal data (**decide** the service)
- [ ] Optional order-slip printing (behind the platform layer)
- [ ] Web cookie session once a custom domain exists (backend)

## Later (only when needed)

- [ ] Realtime orders instead of polling (same order shapes)
- [ ] Windows app: `windows/` folder, `windows-latest` CI runner, sound/wake lock/printing in the platform layer,
      `flutter_secure_storage` token store
- [ ] Android store release (only if restaurants need it): Play listing and staged rollout, release builds with
      obfuscation and split debug info, `min_app_version` in `/config`
- [ ] iOS flavors on a Mac (schemes `staging` and `production`, bundle ID per flavor, the same IDs as Android), then
      the `BUILD_IOS` variable for the unsigned compile check on a macOS runner
- [ ] iOS store release (only if restaurants need it): signing, App Store Connect listing, TestFlight
- [ ] Dine-in and delivery: order type on the staff order, `features/kitchen/` ticket view

---

## Decisions still open

- [ ] The restaurants' real device (Android, iPad, Windows or phone; printing; POS; Wi-Fi; audible alert)
- [ ] Hosting and custom domain
- [ ] Tooling still open: bundle-size budget (after the first measurement), certificate pinning (native apps only)
- [ ] Idle logout timing on shared devices
- [ ] Production site name and CORS origin
- [ ] Who provides the Arabic UI copy, the logo and the font licence text
- [ ] Map tile provider and error-reporting service

## Backend requests (API request issues in the backend repository)

- [x] Order type (`car`, `dine_in`, `delivery`) on the staff order object, before D3 freezes it: agreed with the backend
      on 2026-11-14 and part of its API request issue #52 (open; the staff part is built with D3)
- [x] Staff endpoints (login, logout, `staff/me`, password, orders list, accept, reject), backend API request issue #94:
      agreed on 2026-11-25 (Rounds 2 to 4); built in three backend slices, each with a commit to pin; adds `decided_at`
      on the staff order and extensible enums
- [ ] Staff token expiry and rotation, per-device staff tokens (one token per account until then)
- [ ] HttpOnly cookie session for the web once a custom domain exists
- [ ] `min_app_version` in `/config` before any native app ships
