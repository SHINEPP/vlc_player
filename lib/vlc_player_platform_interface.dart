import 'dart:ffi';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:vlc_player/vlc/data_source.dart';
import 'package:vlc_player/vlc/hw_acc.dart';
import 'package:vlc_player/vlc/lib_vlc.dart';
import 'package:vlc_player/vlc/media.dart';
import 'package:vlc_player/vlc/media_player.dart';

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

  Future<bool> mediaParseAsync(Media media) async {
    throw UnimplementedError('mediaParseAsync() has not been implemented.');
  }

  Future<bool> disposeMedia(Media media) async {
    throw UnimplementedError('disposeMedia() has not been implemented.');
  }

  /// MediaPlayer
  Future<MediaPlayer> createMediaPlayer(LibVlc libVlc) async {
    throw UnimplementedError('createMediaPlayer() has not been implemented.');
  }

  Future<bool> disposeMediaPlayer(MediaPlayer mediaPlayer) async {
    throw UnimplementedError('disposeMediaPlayer() has not been implemented.');
  }

  Future<String?> getPlatformVersion() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
