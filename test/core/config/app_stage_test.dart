import 'package:flutter_test/flutter_test.dart';
import 'package:wasli_restaurant/core/config/app_stage.dart';

void main() {
  group('AppStage.resolve', () {
    test('APP_ENV production selects production', () {
      expect(AppStage.resolve(appEnv: 'production'), AppStage.production);
    });

    test('APP_ENV staging selects staging', () {
      expect(AppStage.resolve(appEnv: 'staging'), AppStage.staging);
    });

    test('is case and whitespace insensitive', () {
      expect(AppStage.resolve(appEnv: ' Production '), AppStage.production);
    });

    test('APP_ENV wins over the flavor', () {
      expect(AppStage.resolve(appEnv: 'staging', flavor: 'production'), AppStage.staging);
      expect(AppStage.resolve(appEnv: 'production', flavor: 'staging'), AppStage.production);
    });

    test('the flavor decides when APP_ENV is empty or missing', () {
      expect(AppStage.resolve(appEnv: '', flavor: 'production'), AppStage.production);
      expect(AppStage.resolve(flavor: 'production'), AppStage.production);
    });

    test('an unknown value counts as staging, it does not fall through to the flavor', () {
      expect(AppStage.resolve(appEnv: 'prod', flavor: 'production'), AppStage.staging);
    });

    test('no value at all counts as staging', () {
      expect(AppStage.resolve(), AppStage.staging);
      expect(AppStage.resolve(appEnv: '  '), AppStage.staging);
    });
  });
}
