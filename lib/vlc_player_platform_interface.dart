import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vlc_player/vlc/video_view.dart';

import 'message/messages.g.dart';
import 'vlc/data_source.dart';
import 'vlc/hw_acc.dart';
import 'vlc/lib_vlc.dart';
import 'vlc/media.dart';
import 'vlc/media_player.dart';
import 'vlc_player_method_channel.dart';

abstract class VlcPlayerPlatform extends PlatformInterface {
  /// Constructs a VlcPlayerPlatform.
  VlcPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static VlcPlayerPlatform _instance = MethodChannelVlcPlayer();

  /// The default instance of [VlcPlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelVlcPlayer].
  static VlcPlayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VlcPlayerPlatform] when
  /// they register themselves.
  static set instance(VlcPlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// LibVLC
  Future<LibVlc> createLibVlc({List<String>? options}) async {
    throw UnimplementedError('createLibVlc() has not been implemented.');
  }

  Future<bool> disposeLibVlc(LibVlc libVlc) async {
    throw UnimplementedError('disposeLibVlc() has not been implemented.');
  }

  /// Media
  Future<Media> createMedia(
    LibVlc libVlc,
    DataSource dataSource, {
    String? packageName,
    HwAcc? hwAcc,
    List<String>? options,
  }) async {
    throw UnimplementedError('createMedia() has not been implemented.');
  }

  Future<void> setMediaEventListener(Media media) async {
    throw UnimplementedError(
      'setMediaEventListener() has not been implemented.',
    );
  }

  Future<bool> mediaParseAsync(Media media) async {
    throw UnimplementedError('mediaParseAsync() has not been implemented.');
  }

  Future<MediaVideoTrack> mediaGetVideoTrack(Media media) async {
    throw UnimplementedError('mediaGetVideoTrack() has not been implemented.');
  }

  Future<bool> disposeMedia(Media media) async {
    throw UnimplementedError('disposeMedia() has not been implemented.');
  }

  /// MediaPlayer
  Future<MediaPlayer> createMediaPlayer(LibVlc libVlc) async {
    throw UnimplementedError('createMediaPlayer() has not been implemented.');
  }

  Future<bool> mediaPlayerSetMedia(MediaPlayer mediaPlayer, Media media) async {
    throw UnimplementedError('mediaPlayerSetMedia() has not been implemented.');
  }

  Future<bool> mediaPlayerAttachVideoView(
    MediaPlayer mediaPlayer,
    VideoView videoView,
  ) {
    throw UnimplementedError(
      'mediaPlayerAttachVideoView() has not been implemented.',
    );
  }

  Future<bool> mediaPlayerPlay(MediaPlayer mediaPlayer) {
    throw UnimplementedError('mediaPlayerPlay() has not been implemented.');
  }

  Future<bool> disposeMediaPlayer(MediaPlayer mediaPlayer) async {
    throw UnimplementedError('disposeMediaPlayer() has not been implemented.');
  }

  /// Video View
  Future<VideoViewOutput> createVideoView() async {
    throw UnimplementedError('createVideoView() has not been implemented.');
  }

  Future<bool> videoViewSetDefaultBufferSize(
    VideoView videoView,
    int width,
    int height,
  ) async {
    throw UnimplementedError(
      'videoViewSetDefaultBufferSize() has not been implemented.',
    );
  }

  Widget buildVideoView(VideoView videoView) {
    throw UnimplementedError('buildVideoView() has not been implemented.');
  }

  Future<bool> disposeVideoView(VideoView videoView) async {
    throw UnimplementedError('disposeVideoView() has not been implemented.');
  }
}
