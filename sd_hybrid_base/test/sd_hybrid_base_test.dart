import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sd_hybrid_base/sd_hybrid_base.dart';

void main() {
  const MethodChannel channel = MethodChannel('sd_hybrid_base');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SdHybridBase.platformVersion, '42');
  });
}
