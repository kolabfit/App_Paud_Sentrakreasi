import 'package:belajar_yuk/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Belajar Yuk app boots', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: BelajarYukApp()));
    expect(find.text('Belajar Yuk!'), findsNothing);
  });
}
