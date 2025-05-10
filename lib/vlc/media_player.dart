import 'package:vlc_player/vlc/lib_vlc.dart';
import 'package:vlc_player/vlc/video_view.dart';
import 'package:vlc_player/vlc_player_platform_interface.dart';

import 'media.dart';

class MediaPlayer {
  static Future<MediaPlayer> create(LibVlc libVlc) async {
    return await VlcPlayerPlatform.instance.createMediaPlayer(libVlc);
  }

  final int mediaPlayerId;

  Media? _media;
  VideoView? _videoView;

  MediaPlayer({required this.mediaPlayerId});

  Future<void> setMedia(Media media) async {
    _media = media;
    await VlcPlayerPlatform.instance.mediaPlayerSetMedia(this, media);
  }

  Future<void> attachVideoView(VideoView videoView) async {
    _videoView = videoView;
    await VlcPlayerPlatform.instance.mediaPlayerAttachVideoView(
      this,
      videoView,
    );
  }

  Future<void> play() async {
    await VlcPlayerPlatform.instance.mediaPlayerPlay(this);
  }

  Future<void> dispose() async {
    await VlcPlayerPlatform.instance.disposeMediaPlayer(this);
  }
}
