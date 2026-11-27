import 'package:dio/dio.dart' show Dio;
import 'package:wasli_restaurant/api/api.dart';
import 'package:wasli_restaurant/core/error/failure.dart';
import 'package:wasli_restaurant/core/network/dio_failure_mapper.dart';
import 'package:wasli_restaurant/core/storage/token_store.dart';
import 'package:wasli_restaurant/features/auth/data/staff_session_mapper.dart';
import 'package:wasli_restaurant/features/auth/domain/auth_repository.dart';
import 'package:wasli_restaurant/features/auth/domain/staff_session.dart';

/// Signs staff in and out with `POST /auth/login` and `POST /auth/logout`, finds out who they are with
/// `GET /staff/me`, and keeps the token in the [TokenStore].
class AuthRepositoryImpl implements AuthRepository {
  /// Creates the repository on the generated clients.
  const new({required this._auth, required this._staff, required this._tokens});

  /// Creates the repository on the app's [dio] client.
  new fromDio(Dio dio, TokenStore tokens) : this(auth: Api(dio).auth, staff: Api(dio).staff, tokens: tokens);

  final AuthClient _auth;
  final StaffClient _staff;
  final TokenStore _tokens;

  @override
  Future<StaffSession> signIn({required String username, required String password}) async {
    final login = await guardRequest(
      () => _auth.staffLogin(
        body: StaffLoginRequest$Request(username: username, password: password),
      ),
    );
    await _tokens.write(login.token);
    try {
      return staffSessionFromDto(await guardRequest(_staff.staffMe));
    } on Object {
      // Not signed in after all (for example an account without a restaurant): keep nothing.
      await _tokens.clear();
      rethrow;
    }
  }

  @override
  Future<StaffSession?> restore() async {
    final token = await _tokens.read();
    if (token == null) return null;
    try {
      return staffSessionFromDto(await guardRequest(_staff.staffMe));
    } on UnauthenticatedFailure {
      await _tokens.clear();
      return null;
    } on PermissionDeniedFailure {
      // The account has no restaurant any more.
      await _tokens.clear();
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await guardRequest(_auth.staffLogout);
    } on Failure {
      // The server could not be told. The token is removed here anyway, so this device is signed out.
    } finally {
      await _tokens.clear();
    }
  }
}
