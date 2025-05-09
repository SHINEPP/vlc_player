import 'package:vlc_player/vlc/lib_vlc.dart';
import 'package:vlc_player/vlc_player_platform_interface.dart';

class MediaPlayer {
  MediaPlayer({required this.mediaPlayerId});

  final int mediaPlayerId;

  static Future<MediaPlayer> create(LibVlc libVlc) async {
    return await VlcPlayerPlatform.instance.createMediaPlayer(libVlc);
  }

  Future<void> dispose() async {
    await VlcPlayerPlatform.instance.disposeMediaPlayer(this);
  }
}
