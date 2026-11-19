# Environments and releases

An app created from the template has two environments. Each one is a Flutter flavor
with its own application ID, so both can be installed on one phone, and each one has
its own signing key, GitHub environment and release.

| | **Staging** | **Production** |
| --- | --- | --- |
| Git branch | `develop` | `main` |
| Flutter flavor, GitHub environment and `APP_ENV` | `staging` | `production` |
| Android application ID | `com.yourcompany.myapp.staging` | `com.yourcompany.myapp` |
| Signing key | the staging key | the production (upload) key |
| GitHub environment | `staging`, meant for `develop` | `production`, meant for `main` |
| Release | the draft "Staging" (tag `staging`) | the draft `v<version>` |

The production ID has no suffix because it is the ID of the app in the stores and
cannot be changed once published. The signing keys are described in
[`android-signing.md`](android-signing.md).

GitHub can restrict an environment to one branch (**Deployment branches and tags**), but
a private repository needs a paid plan for it. Where it is not available, the **Build**
workflow refuses a manual run from the wrong branch (staging only from `develop`,
production only from `main`). That stops a mistake; it is not a security boundary, so
restrict the environments in GitHub as soon as the plan allows it.

The flavors are not in the template (`flutter create` makes the `android/` folder), so
you set them up once, right after `flutter create`: the Gradle file is in
[`android-signing.md`](android-signing.md) section 2, and the rest is below.
Until the flavors exist, the Android jobs of `build.yml` are skipped with a warning
(the web build still runs), so nothing fails in the meantime.

## Set up the flavors

1. In `android/app/build.gradle.kts`, add the flavors and the signing configurations
   from [`android-signing.md`](android-signing.md) section 2. The flavor names must be
   exactly `staging` and `production`, because `build.yml` uses them as the Gradle flavor,
   the GitHub environment and the `APP_ENV` value.
2. In `pubspec.yaml`, set the flavor that a plain `flutter run` uses:

   ```yaml
   flutter:
     default-flavor: staging
   ```

3. Optional but recommended: a small helper that tells the app which environment it
   was built for. It reads `APP_ENV` (`--dart-define`, which CI passes to every build,
   web included) first, then the Flutter flavor, and counts anything unknown as
   staging, so a misconfigured build never counts as production:

   ```dart
   import 'package:flutter/services.dart' show appFlavor;

   enum AppEnvironment {
     staging,
     production;

     /// The environment of this build.
     static final AppEnvironment current = resolve(
       define: const String.fromEnvironment('APP_ENV'),
       flavor: appFlavor,
     );

     static AppEnvironment resolve({
       required String? define,
       required String? flavor,
     }) {
       final name = (define != null && define.isNotEmpty) ? define : flavor;
       return values.firstWhere(
         (environment) => environment.name == name,
         orElse: () => AppEnvironment.staging,
       );
     }

     bool get isProduction => this == AppEnvironment.production;
   }
   ```

   Keep it in your own `lib/` and test `resolve` with a few values; the template ships
   no Dart code.

The web build has no flavors: it uses `--dart-define=APP_ENV=<environment>` only. iOS
needs its own flavors (see "Not set up yet").

## Working with the flavors

A plain `flutter run` starts the staging app. Name the flavor for anything else
(Android only):

```bash
flutter run                          # staging
flutter run --flavor production
flutter build apk --release --flavor production --split-per-abi
flutter build appbundle --release --flavor production
```

## What the build does

The **Build** workflow (`.github/workflows/build.yml`) decides by event. Every build runs
in exactly one place, so a change is never built again after its merge:

| Event | Result |
| --- | --- |
| Pull request into `develop` | The staging web build, kept 14 days. The Android test builds (APK and AAB, debug key, no secrets, kept 14 days) run only when the pull request changes `android/`, `pubspec.yaml`, `pubspec.lock` or the build workflow itself |
| Merge into `develop` | Nothing is built. Start the build by hand when a staging build is wanted (below) |
| Pull request into `main` (the release) | Nothing is built. **CI** checks it; the build runs once, after the merge |
| Merge into `main` | Signed production build; its files go into the draft release `v<version>` |
| Manual run (Actions → Build → Run workflow) | Signed build of the chosen environment: `staging` only from `develop`, `production` only from `main`. Any other branch fails at once with a message |

A draft pull request, and a change that touches only documentation (no file under `lib/`,
`assets/`, `env/`, `android/`, `ios/`, `web/` or `pubspec.*`), builds nothing.

**Why it is split this way.**

- A pull request build answers "does this change still compile?". Dart code is already
  checked by format, analyze (including the lint against web-only libraries), test and
  the web build, and it rarely breaks the Android build, so a pull request that changes
  only Dart code skips the slowest part of the build, the Android test builds. Native
  changes (`android/`, plugins in `pubspec.*`) still get them, and anything the skip
  misses shows in the signed build after the merge into `main` or in a manual staging
  run, before anything is published.
- A signed build is something you ship, so it runs when you ship: after a merge into
  `main`, or when you start it by hand for staging. The merge into `develop` would only
  repeat what the pull request already built.
- The release pull request into `main` adds no build: `develop` is already verified by
  its own pull requests and **CI** runs again on the release pull request, which is the
  first check of the integrated `develop`. The signed production build follows the
  merge. Nothing is published by it (the release stays a draft), so a failed production
  build costs nothing: fix it through a new pull request, or release the previous tag.
- Concurrency: a new push to a pull request cancels its running build; a build on
  `main` or a manual build is never cancelled halfway, because it ends in a release.

**Start a staging build by hand.** Actions → Build → Run workflow, branch `develop`,
environment `staging`; or, from a terminal, `gh workflow run build.yml --ref develop -f
environment=staging`. It refreshes the draft "Staging". To try a branch on a phone before
it is merged, open its pull request: a change to `android/` or `pubspec.*` produces the
Android test APKs, and the web build is always there.

**Releasing, in order.**

1. Merge the feature pull requests into `develop` (each one had **CI** and its build).
2. Optional: run the staging build by hand from `develop` and test the signed files.
3. Raise `version:` in `pubspec.yaml` (a pull request into `develop`).
4. Open the release pull request `develop` → `main`; wait for **CI passed**; merge it
   with **Create a merge commit**.
5. **Build** runs once on `main` and fills the draft `v<version>`; publish it when final.

The checks that show the rules above working on GitHub are listed in `docs/steps.md`
("Checks for the build-once rule"); each one is ticked the first time it is seen.

A signed build produces one APK per CPU type (`arm64-v8a`, `armeabi-v7a`, `x86_64`),
the App Bundle, a checksum file and the web build. It is obfuscated, and the job checks
that every file is signed with the right key. Nothing publishes by itself: the drafts
are created and refreshed, and you publish the production one.

The build reads three facts from the project, so `build.yml` needs no edit:

- the application ID from `applicationId` in `android/app/build.gradle(.kts)` (the
  staging flavor adds `.staging`);
- the file prefix from `name:` in `pubspec.yaml` (underscores become hyphens), so the
  files are called `<name>-<version>-<abi>.apk` (production) or
  `<name>-staging-<version>-<abi>.apk`;
- whether the app uses Firebase, from the Google services plugin in the Gradle file.

If the plugin is applied, a test build gets a placeholder `google-services.json` with
invented values (ignored by Git; it reaches no Firebase project), and a signed build
writes the real file from the environment secret `GOOGLE_SERVICES_JSON_BASE64` into
`android/app/src/<environment>/google-services.json`. It fails if that file is not for
the environment's application ID, so a swapped secret is caught. Without the plugin
neither step runs. To build a flavor on your own machine, download its file from the
Firebase console (Project settings → General → Your apps) into the same place; without
it the Google services plugin stops the build.

**Build number.** Signed builds use the run number of the workflow as the Android
version code, so it only ever increases and nobody edits `+N` in `pubspec.yaml` for CI
builds. The release name comes from the version in `pubspec.yaml` without the build
number, and the release notes show the build number and the commit.

**Staging release.** One draft called "Staging" (tag `staging`) holds the files of the
latest manual staging build on `develop`. Every manual staging build replaces its files
and notes. Never publish it:
a published release is immutable, and the build would then leave it alone. GitHub
renames the tag of a draft once the draft has been updated (to `untagged-…`), so the
build finds a draft by its tag or by its title. If more than one release matches, the
build uses the newest and warns; delete the others on the Releases page. The tag
`staging` does not clash with the `tags-protect` ruleset, which covers `v*` tags only.

**Production release.** The draft `v1.0.0` belongs to version `1.0.0` (any build
number). A new build of the same version replaces its files and notes. When the version
is final, publish the draft on the Releases page: that is the only manual step. A
published release is immutable (repository setting and the `tags-protect` ruleset), so
the build only warns about it; to release again, raise the version in `pubspec.yaml`
and merge into `main`. A version with a suffix (`2.0.0-beta.1`) makes a pre-release.
Drafts are visible to people with write access to the repository only. The notes are
generated from the pull-request labels ([`.github/release.yml`](../.github/release.yml)).

## Not set up yet

These are per-project decisions the template does not make for you:

- **iOS flavors.** Flutter needs Xcode schemes named `staging` and `production`, build
  configurations and a bundle identifier per flavor
  ([Flutter guide](https://docs.flutter.dev/deployment/flavors-ios)); that needs a Mac.
  Until then `default-flavor` makes an iOS build fail, so the opt-in iOS job of
  `build.yml` (repository variable `BUILD_IOS`) waits for it. Use the same bundle IDs as
  the Android IDs.
- **Store upload.** A merge into `main` can later also upload the App Bundle (first to
  an internal or closed track); see the end of [`android-signing.md`](android-signing.md).
- **Firebase.** One Firebase project per environment, each registered with the
  application ID above, is the usual layout. Decide what the app uses it for first;
  the build already handles the configuration files (see "What the build does").
