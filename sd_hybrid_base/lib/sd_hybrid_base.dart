

export 'SDNavigator.dart';
export 'SDPageLifecycler.dart';

import 'dart:async';

import 'package:flutter/services.dart';

class SdHybridBase {
  static const MethodChannel _channel = MethodChannel('sd_hybrid_base');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
