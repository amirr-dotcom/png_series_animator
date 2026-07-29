import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';
import 'package:png_series_animator/png_series_animator.dart';

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    if (key.endsWith('.png')) {
      return ByteData.sublistView(Uint8List.fromList([
        137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82,
        0, 0, 0, 1, 0, 0, 0, 1, 8, 6, 0, 0, 0, 31, 21, 196, 137,
        0, 0, 0, 13, 73, 68, 65, 84, 120, 156, 99, 96, 0, 0, 0,
        5, 0, 1, 13, 10, 45, 180, 0, 0, 0, 0, 73, 69, 78, 68,
        174, 66, 96, 130
      ]));
    }
    if (key == 'AssetManifest.json') {
      return ByteData.sublistView(Uint8List.fromList([123, 125]));
    }
    if (key == 'AssetManifest.bin') {
      return ByteData.sublistView(Uint8List.fromList([13, 0]));
    }
    return ByteData(0);
  }
}

void main() {
  testWidgets('Showcase app builds successfully', (WidgetTester tester) async {
    final testBundle = TestAssetBundle();

    await tester.pumpWidget(
      DefaultAssetBundle(
        bundle: testBundle,
        child: const MyApp(),
      ),
    );

    // Pump to complete precaching and build
    await tester.pump();

    // Verify showcase screen components are loaded
    expect(find.text('PNG Series Animator'), findsOneWidget);
    expect(find.byType(PngSeriesAnimator), findsOneWidget);
  });
}
