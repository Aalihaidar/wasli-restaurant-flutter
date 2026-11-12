import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/config/app_config_exception.dart';
import 'package:wasli_restaurant/core/config/app_environment.dart';
import 'package:wasli_restaurant/core/config/app_stage.dart';

void main() {
  group('AppEnvironment.parse', () {
    test('reads the stage and the URLs', () {
      final environment = AppEnvironment.parse(
        appEnv: 'staging',
        apiBaseUrl: 'https://api.example.test/api/v1',
        customerSiteUrl: 'https://customer.example.test',
        restaurantSiteUrl: 'https://restaurant.example.test',
      );

      expect(environment.stage, AppStage.staging);
      expect(environment.isProduction, isFalse);
      expect(environment.apiBaseUrl, Uri.parse('https://api.example.test/api/v1'));
      expect(environment.customerSiteUrl, Uri.parse('https://customer.example.test'));
      expect(environment.restaurantSiteUrl, Uri.parse('https://restaurant.example.test'));
    });

    test('drops trailing slashes from the API base URL', () {
      final environment = AppEnvironment.parse(apiBaseUrl: 'https://api.example.test/api/v1//');

      expect(environment.apiBaseUrl.toString(), 'https://api.example.test/api/v1');
    });

    test('the site URLs are optional', () {
      final environment = AppEnvironment.parse(apiBaseUrl: 'https://api.example.test/api/v1');

      expect(environment.customerSiteUrl, isNull);
      expect(environment.restaurantSiteUrl, isNull);
    });

    test('allows http outside production, for a local backend', () {
      final environment = AppEnvironment.parse(apiBaseUrl: 'http://10.0.2.2:8000/api/v1');

      expect(environment.apiBaseUrl.port, 8000);
      expect(environment.stage, AppStage.staging);
    });

    test('production is selected by APP_ENV or by the flavor', () {
      final byEnv = AppEnvironment.parse(appEnv: 'production', apiBaseUrl: 'https://api.example.test/api/v1');
      final byFlavor = AppEnvironment.parse(flavor: 'production', apiBaseUrl: 'https://api.example.test/api/v1');

      expect(byEnv.isProduction, isTrue);
      expect(byFlavor.isProduction, isTrue);
    });

    test('production refuses http for every URL', () {
      expect(
        () => AppEnvironment.parse(appEnv: 'production', apiBaseUrl: 'http://api.example.test/api/v1'),
        throwsA(isA<AppConfigException>()),
      );
      expect(
        () => AppEnvironment.parse(
          appEnv: 'production',
          apiBaseUrl: 'https://api.example.test/api/v1',
          restaurantSiteUrl: 'http://restaurant.example.test',
        ),
        throwsA(isA<AppConfigException>()),
      );
    });

    test('a missing API base URL is an error that names it', () {
      expect(
        () => AppEnvironment.parse(apiBaseUrl: ''),
        throwsA(isA<AppConfigException>().having((e) => e.message, 'message', contains('API_BASE_URL'))),
      );
    });

    test('rejects values that are not absolute http or https URLs', () {
      for (final bad in ['not a url', '/api/v1', 'ftp://api.example.test', 'https://', 'localhost:8000/api']) {
        expect(() => AppEnvironment.parse(apiBaseUrl: bad), throwsA(isA<AppConfigException>()), reason: bad);
      }
    });

    test('rejects a query, a fragment or credentials', () {
      for (final bad in [
        'https://api.example.test/api/v1?key=1',
        'https://api.example.test/api/v1#top',
        'https://user:pass@api.example.test/api/v1',
      ]) {
        expect(() => AppEnvironment.parse(apiBaseUrl: bad), throwsA(isA<AppConfigException>()), reason: bad);
      }
    });

    test('the error message never repeats the value', () {
      try {
        AppEnvironment.parse(apiBaseUrl: 'https://user:secret@api.example.test/api/v1');
        fail('expected an AppConfigException');
      } on AppConfigException catch (error) {
        expect(error.toString(), isNot(contains('secret')));
      }
    });
  });
}
