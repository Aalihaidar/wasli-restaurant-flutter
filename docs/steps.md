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
- [x] Boundary check: `scripts/check-boundaries.sh` written (make it executable, run it, then add it to `ci.yml`) for the folder rules (`core`, `theme`, `api` never import `features` or `app`;
      features never import each other's `data`/`presentation`), run in CI
- [x] Web entry point uses `usePathUrlStrategy()`
- [x] Replace the generated counter app with a minimal placeholder page (`lib/main.dart` calls `bootstrap()`) and one
      passing test in `test/`
- [ ] `env/staging.json` (written) and `env/production.json` (waits for the production URLs) (public values only: `API_BASE_URL`, `CUSTOMER_SITE_URL`,
      `RESTAURANT_SITE_URL`); the names listed in `.env.example`
- [x] `.vscode/launch.json`: `--dart-define=API_BASE_URL=http://localhost:8000/api/v1` for web and
      `http://10.0.2.2:8000/api/v1` for the emulator
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

With the flavors in place, a merge into `develop` runs the signed staging build, which stops without its keys.
Prepare these first ([`android-signing.md`](android-signing.md) sections 1 and 3):

- [ ] Two keystores outside the repo (or in the ignored `.signing/`) with distinctive aliases
      (`wasliresto-staging`, `wasliresto-upload`), each with its own password; both **backed up** in a password manager
- [ ] `android/key.staging.properties` and `android/key.production.properties` locally (ignored by Git)
- [ ] GitHub environments `staging` (only `develop`) and `production` (only `main`), administrator bypass off, created
      **before** the first build that names them
- [ ] In each environment: secrets `ANDROID_KEYSTORE_BASE64`, `ANDROID_STORE_PASSWORD`, `ANDROID_KEY_PASSWORD`,
      `ANDROID_KEY_ALIAS` and the variable `ANDROID_CERT_SHA256` (public fingerprint)

### Merge

- [ ] Pull request into `develop`; **CI passed** green; web, APK and AAB test builds produced by `build.yml`
- [ ] Merged with **Create a merge commit**
- [ ] Signed staging build succeeded, the draft release "Staging" holds three APKs and the App Bundle; signature checked
      with `apksigner`

## Phase 3: GitHub repository settings (after the first pull request has run CI)

- [ ] **General**: default branch `develop`; template repository off; merge commits on, squash and rebase off; suggest
      updating branches, auto-merge and delete head branches on
- [ ] **Actions → General**: allowed actions (GitHub-created plus `raven-actions/actionlint@*`,
      `zizmorcore/zizmor-action@*`, `google/osv-scanner-action/*`); require full-SHA pinning; read-only workflow
      permissions; Actions may not create or approve pull requests; fork workflows need approval
- [ ] **Code security**: dependency graph, Dependabot alerts and security updates, secret scanning with push
      protection, private vulnerability reporting, CodeQL default setup (language Actions)
- [ ] Import the rulesets `main-protect`, `develop-protect`, `tags-protect` ([`github-setup.md`](github-setup.md) section 5)
- [ ] Verify the protection ([`github-setup.md`](github-setup.md) section 7): direct pushes to `main`/`develop` are
      rejected, a topic branch into `main` fails **Verify source branch**, `Fixed stuff` fails **Commit messages**
- [ ] Environments `staging` and `production` exist as set up above; add the web deploy secrets to them when the
      hosting is decided (Phase 6)
- [ ] Backend contract check: repository variable `BACKEND_REPO` and secret `BACKEND_READ_TOKEN` (fine-grained,
      read-only Contents on the backend repository only)

## Phase 4: Backend contract and generated client (D1, backend `v0.1.0`), branch `feat/api-client`

- [ ] `api/BACKEND_REPO` with the backend repository (`OWNER/REPO`)
- [ ] `flutter pub add dio retrofit json_annotation`
- [ ] `flutter pub add --dev build_runner json_serializable retrofit_generator swagger_parser`
- [ ] Check whether `swagger_parser.yaml` can generate only this app's endpoints (staff and `config`); if not, generate
      the whole client
- [ ] `scripts/sync-api.sh v0.1.0` (writes `api/openapi.yaml`, `api/BACKEND_VERSION`, `lib/api`)
- [ ] Exclude `lib/api/**` from analysis if `flutter analyze --fatal-infos` reports generated code
- [ ] **API client is current** job green in CI

## Phase 5: App foundation (D1)

Each item is its own small pull request.

- [ ] Packages: `flutter_riverpod`, `go_router`, `intl`, `flutter_localizations`
- [x] **Decide** providers and value classes: hand-written Riverpod providers, plain Dart 3 classes, no `freezed` or
      `equatable`, no `riverpod_generator` (decided 2026-11-12)
- [ ] `app/`: `bootstrap()`, `ProviderScope`, global error zone, router, app shell
- [ ] `core/config`: `AppEnvironment` reads `APP_ENV` (then the flavor); unknown counts as staging
- [ ] `core/network`: Dio factory with timeouts; interceptors for the auth header (never on public endpoints),
      `X-Request-ID`, locale, redacted logging (no tokens, bodies or query strings)
- [ ] `core/error`: sealed `Failure`, error-body parser, code → failure mapper (unknown code and non-JSON body =
      generic failure of the status)
- [ ] `core/storage`: `TokenStore` interface; web interim implementation (memory first); `flutter_secure_storage`
      implementation for Android (Android backups exclude it; cleared on logout and on a `401`)
- [ ] `core/format`: money from integer fils (`AED 12.50` / `12.50 د.إ`), UTC → Asia/Dubai, Western digits
- [ ] `core/logging`: logger interface without personal data
- [ ] `theme/`: Ink & Mustard tokens, `ColorScheme`, `ThemeExtension`, Rubik typography, component themes, light/dark
- [ ] Responsive layout helpers: compact (< 600), medium (600-839), expanded (≥ 840), content max width 1200
- [ ] Localisation: ARB files `en` and `ar`, locale controller, RTL; every label from ARB
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

- [ ] Pin `v0.3.0` and fix what the compiler reports
- [ ] Staff login (`POST /auth/login`), logout (`POST /auth/logout`), `GET /staff/me`; a `401` returns to login once
- [ ] Hide or disable actions by role and permissions (`orders.view`, `orders.decide`, ...); the server stays the
      authority (`403 permission_denied`)
- [ ] Lifecycle-aware poller in `core/polling`: `GET /staff/orders?since=<server_time>` every `poll_interval_seconds`
      while visible; backoff on 429/5xx honouring `Retry-After`
- [ ] Merge orders by id and `server_time` without rebuilding the whole list
- [ ] Orders list (new first, highlighted) and the "Decided" section
- [ ] Distance badge from `distance_band` (`in_lot`, `near`, `far`, `unknown`), distance, accuracy, age of the position
- [ ] Small map with the restaurant and the customer (`flutter_map`, OpenStreetMap on staging only)
- [ ] Accept dialog: 5, 10 or 15 minutes; button disabled while sending; never auto-retried
- [ ] Reject dialog: reason (preselect `too_far` on `far`, `location_unclear` on `unknown`), note required for `other`,
      at most 200 characters
- [ ] After a network failure or `409 order_invalid_transition`, refetch the order and show its real state
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

- [ ] Order type (`car`, `dine_in`, `delivery`) on the staff order object, before D3 freezes it
- [ ] Staff token expiry and rotation, per-device staff tokens
- [ ] HttpOnly cookie session for the web once a custom domain exists
- [ ] `min_app_version` in `/config` before any native app ships
