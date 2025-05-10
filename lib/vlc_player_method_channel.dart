import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'message/messages.g.dart';
import 'message/messages_flutter_api.dart';
import 'vlc/data_source.dart';
import 'vlc/hw_acc.dart';
import 'vlc/lib_vlc.dart';
import 'vlc/media.dart';
import 'vlc/media_player.dart';
import 'vlc/video_view.dart';
import 'vlc_player_platform_interface.dart';

/// An implementation of [VlcPlayerPlatform] that uses method channels.
class MethodChannelVlcPlayer extends VlcPlayerPlatform {
  final _api = VlcApi();
  final _flutterApi = MessagesFlutterApi();

  MethodChannelVlcPlayer() {
    VlcFlutterApi.setUp(_flutterApi);
  }

  /// LibVLC
  @override
  Future<LibVlc> createLibVlc({List<String>? options}) async {
    return LibVlc(vlcId: await _api.createLibVlc(options));
  }

  @override
  Future<bool> disposeLibVlc(LibVlc libVlc) async {
    return await _api.disposeLibVlc(libVlc.vlcId);
  }

  /// Media
  @override
  Future<Media> createMedia(
    LibVlc libVlc,
    DataSource dataSource, {
    String? packageName,
    HwAcc? hwAcc,
    List<String>? options,
  }) async {
    final mediaId = await _api.createMedia(
      MediaCreateInput(
        libVlcId: libVlc.vlcId,
        dataSourceType: dataSource.type.index,
        dataSourceValue: dataSource.value,
        packageName: packageName,
        hwAcc: hwAcc?.index,
        options: options,
      ),
    );
    return Media(mediaId: mediaId);
  }

  @override
  Future<void> setMediaEventListener(Media media) async {
    await _api.setMediaEventListener(media.mediaId);
  }

  @override
  Future<bool> mediaParseAsync(Media media) async {
    return await _api.mediaParseAsync(media.mediaId);
  }

  @override
  Future<MediaVideoTrack> mediaGetVideoTrack(Media media) async {
    return await _api.mediaGetVideoTrack(media.mediaId);
  }

  @override
  Future<List<MediaAudioTrack>> mediaGetAudioTrack(Media media) async {
    return await _api.mediaGetAudioTrack(media.mediaId);
  }

  @override
  Future<List<MediaSubtitleTrack>> mediaGetSubtitleTrack(Media media) async {
    return await _api.mediaGetSubtitleTrack(media.mediaId);
  }

  @override
  Future<bool> disposeMedia(Media media) async {
    return await _api.disposeMedia(media.mediaId);
  }

  /// MediaPlayer
  @override
  Future<MediaPlayer> createMediaPlayer(LibVlc libVlc) async {
    return MediaPlayer(
      mediaPlayerId: await _api.createMediaPlayer(libVlc.vlcId),
    );
  }

  @override
  Future<bool> mediaPlayerSetMedia(MediaPlayer mediaPlayer, Media media) async {
    return await _api.mediaPlayerSetMedia(
      mediaPlayer.mediaPlayerId,
      media.mediaId,
    );
  }

  @override
  Future<bool> mediaPlayerAttachVideoView(
    MediaPlayer mediaPlayer,
    VideoView videoView,
  ) async {
    return await _api.mediaPlayerAttachVideoView(
      mediaPlayer.mediaPlayerId,
      videoView.videoViewId,
    );
  }

  @override
  Future<bool> mediaPlayerPlay(MediaPlayer mediaPlayer) async {
    return await _api.mediaPlayerPlay(mediaPlayer.mediaPlayerId);
  }

  @override
  Future<void> mediaPlayerPause(MediaPlayer mediaPlayer) async {
    await _api.mediaPlayerPause(mediaPlayer.mediaPlayerId);
  }

  @override
  Future<void> mediaPlayerStop(MediaPlayer mediaPlayer) async {
    await _api.mediaPlayerStop(mediaPlayer.mediaPlayerId);
  }

  @override
  Future<bool> mediaPlayerIsPlaying(MediaPlayer mediaPlayer) async {
    return await _api.mediaPlayerIsPlaying(mediaPlayer.mediaPlayerId);
  }

  @override
  Future<void> mediaPlayerSetTime(
    MediaPlayer mediaPlayer,
    Duration time,
    bool fast,
  ) async {
    await _api.mediaPlayerSetTime(
      mediaPlayer.mediaPlayerId,
      time.inMilliseconds,
      fast,
    );
  }

  @override
  Future<Duration> mediaPlayerGetTime(MediaPlayer mediaPlayer) async {
    final time = await _api.mediaPlayerGetTime(mediaPlayer.mediaPlayerId);
    return Duration(milliseconds: time);
  }

  @override
  Future<void> mediaPlayerSetPosition(
    MediaPlayer mediaPlayer,
    double position,
    bool fast,
  ) async {
    await _api.mediaPlayerSetPosition(
      mediaPlayer.mediaPlayerId,
      position,
      fast,
    );
  }

  @override
  Future<double> mediaPlayerGetPosition(MediaPlayer mediaPlayer) async {
    return await _api.mediaPlayerGetPosition(mediaPlayer.mediaPlayerId);
  }

  @override
  Future<Duration> mediaPlayerGetLength(MediaPlayer mediaPlayer) async {
    final milliseconds = await _api.mediaPlayerGetLength(
      mediaPlayer.mediaPlayerId,
    );
    return Duration(milliseconds: milliseconds);
  }

  @override
  Future<void> mediaPlayerSetVolume(MediaPlayer mediaPlayer, int volume) async {
    await _api.mediaPlayerSetVolume(mediaPlayer.mediaPlayerId, volume);
  }

  @override
  Future<int> mediaPlayerGetVolume(MediaPlayer mediaPlayer) async {
    return await _api.mediaPlayerGetVolume(mediaPlayer.mediaPlayerId);
  }

  @override
  Future<void> mediaPlayerSetRate(MediaPlayer mediaPlayer, double rate) async {
    await _api.mediaPlayerSetRate(mediaPlayer.mediaPlayerId, rate);
  }

  @override
  Future<double> mediaPlayerGetRate(MediaPlayer mediaPlayer) async {
    return await _api.mediaPlayerGetRate(mediaPlayer.mediaPlayerId);
  }

  @override
  Future<bool> disposeMediaPlayer(MediaPlayer mediaPlayer) async {
    return await _api.disposeMediaPlayer(mediaPlayer.mediaPlayerId);
  }

  /// Video View
  @override
  Future<VideoViewCreateResult> createVideoView() async {
    return await _api.createVideoView();
  }

  @override
  Future<bool> videoViewSetDefaultBufferSize(
    VideoView videoView,
    int width,
    int height,
  ) async {
    return await _api.videoViewSetDefaultBufferSize(
      videoView.videoViewId,
      width,
      height,
    );
  }

  @override
  Widget buildVideoView(VideoView videoView) {
    if (Platform.isAndroid) {
      return Texture(textureId: videoView.textureId);
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: 'vlc_player_plugin/buildVideoView',
        hitTestBehavior: PlatformViewHitTestBehavior.transparent,
        creationParamsCodec: const StandardMessageCodec(),
        creationParams: {'videoViewId': videoView.videoViewId},
      );
    } else if (Platform.isMacOS) {
      return AppKitView(
        viewType: 'vlc_player_plugin/buildVideoView',
        hitTestBehavior: PlatformViewHitTestBehavior.transparent,
        creationParamsCodec: const StandardMessageCodec(),
        creationParams: {'videoViewId': videoView.videoViewId},
      );
    }
    return Container();
  }

  @override
  Future<bool> disposeVideoView(VideoView videoView) async {
    return await _api.disposeVideoView(videoView.videoViewId);
  }
}
