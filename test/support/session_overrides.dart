import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:wasli_restaurant/features/auth/application/auth_providers.dart';

import 'fake_auth_repository.dart';

/// Starts the app with a member already signed in, so a test of the whole app lands on the first screen.
final Override signedIn = authRepositoryProvider.overrideWithValue(FakeAuthRepository(restored: testSession));

/// Starts the app with nobody signed in, so a test of the whole app lands on the sign-in screen.
final Override signedOut = authRepositoryProvider.overrideWithValue(FakeAuthRepository());
