import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:epson_epos/epson_epos.dart';

void main() {
  const MethodChannel channel = MethodChannel('epson_epos');

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
    expect(await EpsonEpos.platformVersion, '42');
  });
}
