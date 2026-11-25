import 'package:flutter/services.dart' show appFlavor;
import 'package:wasli_restaurant/core/config/app_config_exception.dart';
import 'package:wasli_restaurant/core/config/app_stage.dart';

/// The build-time configuration of the app: the stage and the public URLs.
///
/// It is the only place that reads `APP_ENV`, the flavor and the `--dart-define` values; nothing else looks at flavor
/// names. All values are public (they are compiled into a web app): no secret ever belongs here.
class AppEnvironment {
  const new _({
    required this.stage,
    required this.apiBaseUrl,
    required this.customerSiteUrl,
    required this.restaurantSiteUrl,
  });

  /// Reads the values this build was compiled with.
  ///
  /// Throws [AppConfigException] when `API_BASE_URL` is missing or a URL is invalid, so a wrong build stops at start.
  factory fromBuild() => AppEnvironment.parse(
    appEnv: const String.fromEnvironment('APP_ENV'),
    // Without defines the analyzer reads `appFlavor` as the constant null, the parameter default, and calls the
    // argument redundant. A real build sets it.
    // ignore: avoid_redundant_argument_values
    flavor: appFlavor,
    apiBaseUrl: const String.fromEnvironment('API_BASE_URL'),
    customerSiteUrl: const String.fromEnvironment('CUSTOMER_SITE_URL'),
    restaurantSiteUrl: const String.fromEnvironment('RESTAURANT_SITE_URL'),
  );

  /// Validates raw build-time values and builds the environment.
  ///
  /// [apiBaseUrl] is required and is the address of the server only, such as `https://api.example.test`: no path. The
  /// generated paths already start with `/api/v1`, so a base that held it would send every call to `/api/v1/api/v1/...`;
  /// such a value is refused instead of being guessed at. A trailing slash is dropped. The two site URLs are optional
  /// (only the share dialog uses them); an empty value means "not set". Every URL must be an absolute `http` or `https`
  /// address without a query, a fragment or credentials, and the production stage accepts `https` only.
  ///
  /// Throws [AppConfigException] on the first value that is wrong.
  factory parse({
    required String apiBaseUrl,
    String? appEnv,
    String? flavor,
    String? customerSiteUrl,
    String? restaurantSiteUrl,
  }) {
    final stage = AppStage.resolve(appEnv: appEnv, flavor: flavor);
    final api = _parseUrl('API_BASE_URL', apiBaseUrl, stage);
    if (api == null) {
      throw const AppConfigException('API_BASE_URL is not set.');
    }
    if (api.path.isNotEmpty) {
      throw const AppConfigException(
        'API_BASE_URL must be the address of the server only, with no path. The API paths start with /api/v1.',
      );
    }
    return AppEnvironment._(
      stage: stage,
      apiBaseUrl: api,
      customerSiteUrl: _parseUrl('CUSTOMER_SITE_URL', customerSiteUrl, stage),
      restaurantSiteUrl: _parseUrl('RESTAURANT_SITE_URL', restaurantSiteUrl, stage),
    );
  }

  /// The stage this build targets.
  final AppStage stage;

  /// The address of the API server, for example `https://host`: no path and no trailing slash. Every generated path
  /// starts with `/api/v1` and is joined to it.
  final Uri apiBaseUrl;

  /// The customer site, used for the customer-site QR code. `null` when not set.
  final Uri? customerSiteUrl;

  /// The restaurant site, used for the restaurant-site QR code. `null` when not set.
  final Uri? restaurantSiteUrl;

  /// Whether this is the production stage.
  bool get isProduction => stage == AppStage.production;

  static Uri? _parseUrl(String name, String? raw, AppStage stage) {
    final value = raw?.trim() ?? '';
    if (value.isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(value);
    final scheme = uri?.scheme;
    if (uri == null || !uri.isAbsolute || uri.host.isEmpty || (scheme != 'http' && scheme != 'https')) {
      throw AppConfigException('$name must be an absolute http or https URL.');
    }
    if (uri.hasQuery || uri.hasFragment || uri.userInfo.isNotEmpty) {
      throw AppConfigException('$name must not contain a query, a fragment or credentials.');
    }
    if (stage == AppStage.production && scheme != 'https') {
      throw AppConfigException('$name must use https in production.');
    }
    final path = uri.path.replaceFirst(RegExp(r'/+$'), '');
    return uri.replace(path: path);
  }
}
