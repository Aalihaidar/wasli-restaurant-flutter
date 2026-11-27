import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/error/failure.dart';
import 'package:wasli_restaurant/core/network/auth_interceptor.dart';
import 'package:wasli_restaurant/core/network/dio_factory.dart';
import 'package:wasli_restaurant/core/storage/memory_token_store.dart';
import 'package:wasli_restaurant/features/auth/data/auth_repository_impl.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_role.dart';

import '../../../support/api_fixtures.dart';
import '../../../support/fake_http_adapter.dart';

late MemoryTokenStore _tokens;

/// The repository over a Dio client that adds the token like the app does, so a call made before the token is stored
/// shows up as a missing header.
AuthRepositoryImpl _repository(FakeHttpAdapter adapter) {
  final dio = createDio(
    baseUrl: Uri.parse('https://api.example.test'),
    adapter: adapter,
    interceptors: [AuthInterceptor(readToken: _tokens.read, onUnauthenticated: () {})],
  );
  return AuthRepositoryImpl.fromDio(dio, _tokens);
}

FakeResponder _loginOk() => jsonResponder(readApiFixture('auth_login_200'));
FakeResponder _meOk() => jsonResponder(readApiFixture('staff_me_200'));
FakeResponder _error(String fixture, int status) => jsonResponder(readApiFixture('errors/$fixture'), status: status);

void main() {
  setUp(() => _tokens = MemoryTokenStore());

  group('signIn', () {
    test('logs in, keeps the token and returns the session of GET /staff/me', () async {
      final adapter = FakeHttpAdapter([_loginOk(), _meOk()]);

      final session = await _repository(adapter).signIn(username: 'sara.cashier', password: 'pw-1');

      expect(session.fullName, 'Sara Tester');
      expect(session.role, StaffRole.cashier);
      expect(await _tokens.read(), 'invented-staff-token-0001');
      final [login, me] = adapter.requests;
      expect(login.method, 'POST');
      expect(login.uri.path, '/api/v1/auth/login');
      expect(login.data, {'username': 'sara.cashier', 'password': 'pw-1'});
      expect(login.headers['Authorization'], isNull);
      expect(me.method, 'GET');
      expect(me.uri.path, '/api/v1/staff/me');
      expect(me.headers['Authorization'], 'Token invented-staff-token-0001');
    });

    test('a wrong username or password is an UnauthenticatedFailure and keeps nothing', () async {
      final adapter = FakeHttpAdapter([_error('authentication_failed_401', 401)]);

      await expectLater(
        _repository(adapter).signIn(username: 'sara.cashier', password: 'wrong'),
        throwsA(isA<UnauthenticatedFailure>().having((f) => f.hasCode('authentication_failed'), 'code', isTrue)),
      );

      expect(await _tokens.read(), isNull);
      expect(adapter.requests, hasLength(1));
    });

    test('an account without a restaurant (403 on the profile) is refused and the token is removed again', () async {
      final adapter = FakeHttpAdapter([_loginOk(), _error('permission_denied_403', 403)]);

      await expectLater(
        _repository(adapter).signIn(username: 'sara.cashier', password: 'pw-1'),
        throwsA(isA<PermissionDeniedFailure>()),
      );

      expect(await _tokens.read(), isNull);
    });

    test('a connection that drops after the login removes the token again', () async {
      final adapter = FakeHttpAdapter([_loginOk(), failingResponder(DioExceptionType.connectionError)]);

      await expectLater(
        _repository(adapter).signIn(username: 'sara.cashier', password: 'pw-1'),
        throwsA(isA<NetworkFailure>()),
      );

      expect(await _tokens.read(), isNull);
    });

    test('a login that got no answer is a NetworkFailure and keeps nothing', () async {
      final adapter = FakeHttpAdapter([failingResponder(DioExceptionType.connectionTimeout)]);

      await expectLater(
        _repository(adapter).signIn(username: 'sara.cashier', password: 'pw-1'),
        throwsA(isA<NetworkFailure>()),
      );

      expect(await _tokens.read(), isNull);
    });
  });

  group('restore', () {
    test('with no stored token it is nobody and asks nothing', () async {
      final adapter = FakeHttpAdapter([_meOk()]);

      expect(await _repository(adapter).restore(), isNull);
      expect(adapter.requests, isEmpty);
    });

    test('with a stored token it gives the session of GET /staff/me, sent with that token', () async {
      await _tokens.write('stored-token');
      final adapter = FakeHttpAdapter([_meOk()]);

      final session = await _repository(adapter).restore();

      expect(session?.username, 'sara.cashier');
      expect(adapter.requests.single.headers['Authorization'], 'Token stored-token');
      expect(await _tokens.read(), 'stored-token');
    });

    test('a token the server refuses (401) is removed and it is nobody', () async {
      await _tokens.write('stale-token');
      final adapter = FakeHttpAdapter([_error('authentication_failed_401', 401)]);

      expect(await _repository(adapter).restore(), isNull);
      expect(await _tokens.read(), isNull);
    });

    test('an account that lost its restaurant (403) is removed and it is nobody', () async {
      await _tokens.write('old-token');
      final adapter = FakeHttpAdapter([_error('permission_denied_403', 403)]);

      expect(await _repository(adapter).restore(), isNull);
      expect(await _tokens.read(), isNull);
    });

    test('a server that cannot be reached throws and keeps the token, so the app can try again', () async {
      await _tokens.write('stored-token');
      final adapter = FakeHttpAdapter([failingResponder(DioExceptionType.connectionError)]);

      await expectLater(_repository(adapter).restore(), throwsA(isA<NetworkFailure>()));

      expect(await _tokens.read(), 'stored-token');
    });
  });

  group('signOut', () {
    test('tells the server with the token, then removes it', () async {
      await _tokens.write('stored-token');
      final adapter = FakeHttpAdapter([textResponder('', status: 204)]);

      await _repository(adapter).signOut();

      final request = adapter.requests.single;
      expect(request.method, 'POST');
      expect(request.uri.path, '/api/v1/auth/logout');
      expect(request.headers['Authorization'], 'Token stored-token');
      expect(await _tokens.read(), isNull);
    });

    test('removes the token even when the server cannot be told, and does not throw', () async {
      await _tokens.write('stored-token');
      final adapter = FakeHttpAdapter([failingResponder(DioExceptionType.connectionError)]);

      await _repository(adapter).signOut();

      expect(await _tokens.read(), isNull);
    });

    test('removes the token when the server says the session was over already (401)', () async {
      await _tokens.write('stored-token');
      final adapter = FakeHttpAdapter([_error('authentication_failed_401', 401)]);

      await _repository(adapter).signOut();

      expect(await _tokens.read(), isNull);
    });
  });
}
