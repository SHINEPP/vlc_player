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

  Future<void> pause() async {
    await VlcPlayerPlatform.instance.mediaPlayerPause(this);
  }

  Future<void> stop() async {
    await VlcPlayerPlatform.instance.mediaPlayerStop(this);
  }

  Future<bool> isPlaying() async {
    return await VlcPlayerPlatform.instance.mediaPlayerIsPlaying(this);
  }

  Future<void> setTime(Duration time, {bool fast = false}) async {
    await VlcPlayerPlatform.instance.mediaPlayerSetTime(this, time, fast);
  }

  Future<Duration> getTime() async {
    return await VlcPlayerPlatform.instance.mediaPlayerGetTime(this);
  }

  Future<void> setPosition(double position, {bool fast = false}) async {
    await VlcPlayerPlatform.instance.mediaPlayerSetPosition(
      this,
      position,
      fast,
    );
  }

  Future<double> getPosition() async {
    return await VlcPlayerPlatform.instance.mediaPlayerGetPosition(this);
  }

  Future<Duration> getLength() async {
    return await VlcPlayerPlatform.instance.mediaPlayerGetLength(this);
  }

  Future<void> setVolume(int volume) async {
    await VlcPlayerPlatform.instance.mediaPlayerSetVolume(this, volume);
  }

  Future<int> getVolume() async {
    return await VlcPlayerPlatform.instance.mediaPlayerGetVolume(this);
  }

  Future<void> setRate(double rate) async {
    await VlcPlayerPlatform.instance.mediaPlayerSetRate(this, rate);
  }

  Future<double> getRate() async {
    return await VlcPlayerPlatform.instance.mediaPlayerGetRate(this);
  }

  Future<void> dispose() async {
    await VlcPlayerPlatform.instance.disposeMediaPlayer(this);
  }
}
