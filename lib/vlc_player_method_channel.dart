import 'message/messages.g.dart';
import 'message/vlc_player_flutter_api.dart';
import 'vlc/data_source.dart';
import 'vlc/hw_acc.dart';
import 'vlc/lib_vlc.dart';
import 'vlc/media.dart';
import 'vlc/media_player.dart';
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
}
