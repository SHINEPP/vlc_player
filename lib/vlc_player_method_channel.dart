import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'message/messages.g.dart';
import 'message/vlc_player_flutter_api.dart';
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
  final _flutterApi = VlcPlayerFlutterApi();

  MethodChannelVlcPlayer() {
    VlcFlutterApi.setUp(_flutterApi);
  }

  /// LibVLC
  @override
  Future<LibVlc> createLibVlc({List<String>? options}) async {
    final output = await _api.createLibVlc(LibVlcInput(options: options));
    return LibVlc(vlcId: output.libVlcId ?? -1);
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
    final output = await _api.createMedia(
      MediaInput(
        libVlcId: libVlc.vlcId,
        dataSourceType: dataSource.type.index,
        dataSourceValue: dataSource.value,
        packageName: packageName,
        hwAcc: hwAcc?.index,
        options: options,
      ),
    );
    return Media(mediaId: output.mediaId ?? -1);
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
  Future<bool> disposeMedia(Media media) async {
    return await _api.disposeMedia(media.mediaId);
  }

  /// MediaPlayer
  @override
  Future<MediaPlayer> createMediaPlayer(LibVlc libVlc) async {
    final output = await _api.createMediaPlayer(
      MediaPlayerInput(libVlcId: libVlc.vlcId),
    );
    return MediaPlayer(mediaPlayerId: output.mediaPlayerId ?? -1);
  }

  @override
  Future<bool> disposeMediaPlayer(MediaPlayer mediaPlayer) async {
    return await _api.disposeMediaPlayer(mediaPlayer.mediaPlayerId);
  }

  /// Video View
  @override
  Future<VideoViewOutput> createVideoView() async {
    return await _api.createVideoView();
  }

  @override
  Future<bool> disposeVideoView(VideoView videoView) async {
    return await _api.disposeVideoView(videoView.videoViewId);
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
}
