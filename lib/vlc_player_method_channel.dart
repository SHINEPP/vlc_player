import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'message/messages.g.dart';
import 'vlc/data_source.dart';
import 'vlc/hw_acc.dart';
import 'vlc/lib_vlc.dart';
import 'vlc/media.dart';
import 'vlc/media_player.dart';
import 'vlc_player_platform_interface.dart';

/// An implementation of [VlcPlayerPlatform] that uses method channels.
class MethodChannelVlcPlayer extends VlcPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('vlc_player');

  final _api = VlcApi();

  @override
  Future<LibVlc> createLibVlc({List<String>? options}) async {
    final output = await _api.createLibVlc(LibVlcInput(options: options));
    return LibVlc(vlcId: output.libVlcId ?? -1);
  }

  @override
  Future<Media> createMedia(
    LibVlc libVlc,
    DataSource dataSource, {
    String? package,
    HwAcc? hwAcc,
    List<String>? options,
  }) async {
    final output = await _api.createMedia(
      MediaInput(
        libVlcId: libVlc.vlcId,
        dataSourceType: dataSource.type.index,
        dataSourceValue: dataSource.value,
        package: package,
        hwAcc: hwAcc?.index,
        options: options,
      ),
    );
    return Media(mediaId: output.mediaId ?? -1);
  }

  @override
  Future<MediaPlayer> createMediaPlayer(LibVlc libVlc) async {
    final output = await _api.createMediaPlayer(
      MediaPlayerInput(libVlcId: libVlc.vlcId),
    );
    return MediaPlayer(mediaPlayerId: output.mediaPlayerId ?? -1);
  }

  @override
  Future<String?> getPlatformVersion() async {
    return await methodChannel.invokeMethod<String>('getPlatformVersion');
  }
}
