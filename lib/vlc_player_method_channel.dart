import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'vlc/lib_vlc.dart';
import 'vlc_player_platform_interface.dart';

/// An implementation of [VlcPlayerPlatform] that uses method channels.
class MethodChannelVlcPlayer extends VlcPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('vlc_player');

  @override
  Future<LibVlc> createLibVlc({List<String>? options}) {
    // TODO: implement createLibVlc
    return super.createLibVlc(options: options);
  }

  @override
  Future<String?> getPlatformVersion() async {
    return await methodChannel.invokeMethod<String>('getPlatformVersion');
  }
}
