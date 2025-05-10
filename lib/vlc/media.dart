import 'dart:async';

import 'package:vlc_player/vlc/lib_vlc.dart';
import 'package:vlc_player/vlc_player_platform_interface.dart';

import 'data_source.dart';
import 'hw_acc.dart';

enum MediaEvent {
  metaChanged,
  subItemAdded,
  durationChanged,
  parsedChanged,
  subItemTreeAdded,
}

class VideoTrack {
  VideoTrack({
    required this.duration,
    required this.height,
    required this.width,
    required this.sarNum,
    required this.sarDen,
    required this.frameRateNum,
    required this.frameRateDen,
    required this.orientation,
    required this.projection,
  });

  final int duration;
  final int height;
  final int width;
  final int sarNum;
  final int sarDen;
  final int frameRateNum;
  final int frameRateDen;
  final int orientation;
  final int projection;
}

class AudioTrack {
  final int channels;
  final int rate;
  final String description;

  AudioTrack({
    required this.channels,
    required this.rate,
    required this.description,
  });
}

class SubtitleTrack {
  final String encoding;
  final String description;

  SubtitleTrack({required this.encoding, required this.description});
}

class Media {
  static final _medias = <int, Media>{};

  static void onMediaEvent(int mediaId, int eventIndex) {
    _medias[mediaId]?._onMediaEvent(eventIndex);
  }

  static Future<Media> create({
    required LibVlc libVlc,
    required DataSource dataSource,
    String? package,
    HwAcc? hwAcc,
    List<String>? options,
  }) async {
    return await VlcPlayerPlatform.instance.createMedia(
      libVlc,
      dataSource,
      packageName: package,
      hwAcc: hwAcc,
      options: options,
    );
  }

  Media({required this.mediaId}) {
    _medias[mediaId] = this;
    VlcPlayerPlatform.instance.setMediaEventListener(this);
  }

  final int mediaId;
  final _parsedCompleter = Completer<bool>();

  void setEventListener() {}

  Future<bool> parseAsync() async {
    await VlcPlayerPlatform.instance.mediaParseAsync(this);
    return _parsedCompleter.future;
  }

  Future<VideoTrack> getVideoTrack() async {
    final track = await VlcPlayerPlatform.instance.mediaGetVideoTrack(this);
    return VideoTrack(
      duration: track.duration ?? 0,
      height: track.height ?? 0,
      width: track.width ?? 0,
      sarNum: track.sarNum ?? 0,
      sarDen: track.sarDen ?? 0,
      frameRateNum: track.frameRateNum ?? 0,
      frameRateDen: track.frameRateDen ?? 0,
      orientation: track.orientation ?? 0,
      projection: track.projection ?? 0,
    );
  }

  Future<List<AudioTrack>> getAudioTrack() async {
    final tracks = await VlcPlayerPlatform.instance.mediaGetAudioTrack(this);
    return tracks.map((track) {
      return AudioTrack(
        channels: track.channels ?? 0,
        rate: track.rate ?? 1,
        description: track.description ?? '',
      );
    }).toList();
  }

  Future<List<SubtitleTrack>> getSubtitleTrack() async {
    final tracks = await VlcPlayerPlatform.instance.mediaGetSubtitleTrack(this);
    return tracks.map((track) {
      return SubtitleTrack(
        encoding: track.encoding ?? '',
        description: track.description ?? '',
      );
    }).toList();
  }

  void _onMediaEvent(int eventIndex) {
    final event = MediaEvent.values[eventIndex];
    switch (event) {
      case MediaEvent.metaChanged:
        break;
      case MediaEvent.subItemAdded:
        break;
      case MediaEvent.durationChanged:
        break;
      case MediaEvent.parsedChanged:
        _parsedCompleter.complete(true);
        break;
      case MediaEvent.subItemTreeAdded:
        break;
    }
  }

  Future<void> dispose() async {
    _medias.remove(mediaId);
    await VlcPlayerPlatform.instance.disposeMedia(this);
  }
}
