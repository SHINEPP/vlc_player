import 'package:flutter_test/flutter_test.dart';
import 'package:vlc_player/vlc_player.dart';
import 'package:vlc_player/vlc_player_platform_interface.dart';
import 'package:vlc_player/vlc_player_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockVlcPlayerPlatform
    with MockPlatformInterfaceMixin
    implements VlcPlayerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final VlcPlayerPlatform initialPlatform = VlcPlayerPlatform.instance;

  test('$MethodChannelVlcPlayer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVlcPlayer>());
  });

  test('getPlatformVersion', () async {
    VlcPlayer vlcPlayerPlugin = VlcPlayer();
    MockVlcPlayerPlatform fakePlatform = MockVlcPlayerPlatform();
    VlcPlayerPlatform.instance = fakePlatform;

    expect(await vlcPlayerPlugin.getPlatformVersion(), '42');
  });
}
