import 'package:flutter_test/flutter_test.dart';
import 'package:vlc_player/vlc_player_method_channel.dart';
import 'package:vlc_player/vlc_player_platform_interface.dart';

void main() {
  final VlcPlayerPlatform initialPlatform = VlcPlayerPlatform.instance;

  test('$MethodChannelVlcPlayer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVlcPlayer>());
  });

  test('getPlatformVersion', () async {});
}
