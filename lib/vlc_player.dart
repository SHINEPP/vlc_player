
import 'vlc_player_platform_interface.dart';

class VlcPlayer {
  Future<String?> getPlatformVersion() {
    return VlcPlayerPlatform.instance.getPlatformVersion();
  }
}
