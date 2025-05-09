import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/message/messages.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/src/main/kotlin/com/shinezzl/vlc_player/Messages.g.kt',
    kotlinOptions: KotlinOptions(),
    swiftOut: 'ios/Runner/Messages.g.swift',
    swiftOptions: SwiftOptions(),
    objcHeaderOut: 'macos/Runner/messages.g.h',
    objcSourceOut: 'macos/Runner/messages.g.m',
    // Set this to a unique prefix for your plugin or application, per Objective-C naming conventions.
    objcOptions: ObjcOptions(prefix: 'VLC_PLAYER'),
    dartPackageName: 'com.shinezzl.vlc_player',
  ),
)
// LibVlc
class LibVlcInput {
  List<String>? options;
}

class LibVlcOutput {
  int? libVlcId;
}

// Media
class MediaInput {
  int? libVlcId;
  int? dataSourceType;
  String? dataSourceValue;
  String? packageName;
  int? hwAcc;
  List<String>? options;
}

class MediaOutput {
  int? mediaId;
}

// Media Player
class MediaPlayerInput {
  int? libVlcId;
}

class MediaPlayerOutput {
  int? mediaPlayerId;
}

@HostApi()
abstract class VlcApi {
  /// LibVLC
  @async
  LibVlcOutput createLibVlc(LibVlcInput input);

  @async
  bool disposeLibVlc(int libVlcId);

  /// Media
  @async
  MediaOutput createMedia(MediaInput input);

  @async
  bool mediaParseAsync(int mediaId);

  @async
  bool disposeMedia(int mediaId);

  /// MediaPlayer
  @async
  MediaPlayerOutput createMediaPlayer(MediaPlayerInput input);

  @async
  bool disposeMediaPlayer(int mediaPlayerId);
}

@FlutterApi()
abstract class VlcFlutterApi {
  void onMediaEvent(int event);
}
