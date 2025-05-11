import 'package:pigeon/pigeon.dart';

/// dart run pigeon --input lib/message/messages.dart

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/message/messages.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/src/main/kotlin/com/shinezzl/vlc_player/Messages.g.kt',
    kotlinOptions: KotlinOptions(),
    swiftOut: 'ios/Classes/Messages.g.swift',
    swiftOptions: SwiftOptions(),
    objcHeaderOut: 'macos/Runner/messages.g.h',
    objcSourceOut: 'macos/Runner/messages.g.m',
    // Set this to a unique prefix for your plugin or application, per Objective-C naming conventions.
    objcOptions: ObjcOptions(prefix: 'VLC_PLAYER'),
    dartPackageName: 'com.shinezzl.vlc_player',
  ),
)
// Media
class MediaCreateInput {
  int? libVlcId;
  int? dataSourceType;
  String? dataSourceValue;
  String? packageName;
  int? hwAcc;
  List<String>? options;
}

class MediaVideoTrack {
  int? duration;
  int? height;
  int? width;
  int? sarNum;
  int? sarDen;
  int? frameRateNum;
  int? frameRateDen;
  int? orientation;
  int? projection;
}

class MediaAudioTrack {
  int? trackId;
  int? channels;
  int? rate;
  String? description;
}

class MediaSubtitleTrack {
  int? trackId;
  String? encoding;
  String? description;
}

// Video View
class VideoViewCreateResult {
  int? objectId;
  int? textureId;
}

@HostApi()
abstract class VlcApi {
  /// LibVLC
  @async
  int createLibVlc(List<String>? options);

  @async
  bool disposeLibVlc(int libVlcId);

  /// Media
  @async
  int createMedia(MediaCreateInput input);

  @async
  bool setMediaEventListener(int mediaId);

  @async
  bool mediaParseAsync(int mediaId);

  @async
  MediaVideoTrack mediaGetVideoTrack(int mediaId);

  @async
  List<MediaAudioTrack> mediaGetAudioTrack(int mediaId);

  @async
  List<MediaSubtitleTrack> mediaGetSubtitleTrack(int mediaId);

  @async
  bool disposeMedia(int mediaId);

  /// MediaPlayer
  @async
  int createMediaPlayer(int libVlcId);

  @async
  bool mediaPlayerSetMedia(int mediaPlayerId, int mediaId);

  @async
  bool mediaPlayerAttachVideoView(int mediaPlayerId, int videoViewId);

  @async
  bool mediaPlayerPlay(int mediaPlayerId);

  @async
  void mediaPlayerPause(int mediaPlayerId);

  @async
  void mediaPlayerStop(int mediaPlayerId);

  @async
  bool mediaPlayerIsPlaying(int mediaPlayerId);

  @async
  void mediaPlayerSetTime(int mediaPlayerId, int time, bool fast);

  @async
  int mediaPlayerGetTime(int mediaPlayerId);

  @async
  void mediaPlayerSetPosition(int mediaPlayerId, double position, bool fast);

  @async
  double mediaPlayerGetPosition(int mediaPlayerId);

  @async
  int mediaPlayerGetLength(int mediaPlayerId);

  @async
  void mediaPlayerSetVolume(int mediaPlayerId, int volume);

  @async
  int mediaPlayerGetVolume(int mediaPlayerId);

  @async
  void mediaPlayerSetRate(int mediaPlayerId, double rate);

  @async
  double mediaPlayerGetRate(int mediaPlayerId);

  @async
  bool disposeMediaPlayer(int mediaPlayerId);

  /// Video View
  @async
  VideoViewCreateResult createVideoView();

  @async
  bool videoViewSetDefaultBufferSize(int videoViewId, int width, int height);

  @async
  bool disposeVideoView(int videoViewId);
}

@FlutterApi()
abstract class VlcFlutterApi {
  bool onMediaEvent(int mediaId, int event);
}
