import 'package:flutter_test/flutter_test.dart';
import 'package:la_quiete_app/config/app_config.dart';

void main() {
  test('uses a safe local URL as the default configuration', () {
    expect(AppConfig.apiBaseUrl, 'http://127.0.0.1:5000');
  });

  test('does not include system credentials in source code', () {
    expect(AppConfig.systemUser, isEmpty);
    expect(AppConfig.systemPass, isEmpty);
  });
}
