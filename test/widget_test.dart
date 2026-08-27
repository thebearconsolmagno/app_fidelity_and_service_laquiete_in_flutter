import 'package:flutter_test/flutter_test.dart';
import 'package:la_quiete_app/config/app_config.dart';

void main() {
  test('usa uma URL local segura como configuração padrão', () {
    expect(AppConfig.apiBaseUrl, 'http://127.0.0.1:5000');
  });

  test('não inclui credenciais do sistema no código-fonte', () {
    expect(AppConfig.systemUser, isEmpty);
    expect(AppConfig.systemPass, isEmpty);
  });
}
