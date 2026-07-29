import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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
      return ByteData.sublistView(Uint8List.fromList([123, 125])); // "{}" in UTF-8
    }
    if (key == 'AssetManifest.bin') {
      // StandardMessageCodec encoded empty map (13 = map type, 0 = length)
      return ByteData.sublistView(Uint8List.fromList([13, 0]));
    }
    return ByteData(0);
  }
}

void main() {
  testWidgets('PngSeriesAnimator widget builds successfully', (WidgetTester tester) async {
    final imagePaths = ['assets/1/10001.png', 'assets/1/10002.png'];
    final testBundle = TestAssetBundle();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DefaultAssetBundle(
            bundle: testBundle,
            child: PngSeriesAnimator(
              imagePaths: imagePaths,
              isPlaying: false,
            ),
          ),
        ),
      ),
    );

    // Pump to let precaching finish
    await tester.pump();

    // Verify widget is present in the tree
    expect(find.byType(PngSeriesAnimator), findsOneWidget);
  });
}
