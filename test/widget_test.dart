import 'package:belajar_yuk/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('theme catalog keeps only default and night themes', () {
    expect(appThemes.map((e) => e.id), ['default', 'malam']);
  });
}
