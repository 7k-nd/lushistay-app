import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:elxau/main.dart';
import 'package:elxau/brand_config.dart';

void main() {
  testWidgets('App démarre avec CupertinoApp', (WidgetTester tester) async {
    await tester.pumpWidget(const ElxauApp());
    expect(find.byType(CupertinoApp), findsOneWidget);
    expect(find.text(BrandConfig.tagline), findsOneWidget);
  });
}
