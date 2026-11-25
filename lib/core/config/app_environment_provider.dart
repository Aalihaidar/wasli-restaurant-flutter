import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wasli_restaurant/core/config/app_environment.dart';

/// The build-time configuration of this run.
///
/// The value is read once at start-up (`AppEnvironment.fromBuild`) and given to the `ProviderScope` as an override, so
/// nothing else reads `--dart-define` values and tests give their own. Reading it without an override is a programming
/// mistake.
final appEnvironmentProvider = Provider<AppEnvironment>(
  (ref) => throw StateError('appEnvironmentProvider must be overridden with the environment read at start-up.'),
  name: 'appEnvironment',
);
