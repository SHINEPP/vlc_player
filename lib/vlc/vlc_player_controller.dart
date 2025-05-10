import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:vlc_player/vlc/data_source.dart';
import 'package:vlc_player/vlc/lib_vlc.dart';
import 'package:vlc_player/vlc/media.dart';
import 'package:vlc_player/vlc/media_player.dart';
import 'package:vlc_player/vlc/video_view.dart';

import 'hw_acc.dart';

class VlcPlayerController {
  static const _maxVolume = 100;

  /// The URI to the video file. This will be in different formats depending on
  /// the [DataSourceType] of the original video.
  final DataSource dataSource;

  /// Set hardware acceleration for player. Default is Automatic.
  final HwAcc hwAcc;

  /// Adds options to vlc. For more [https://wiki.videolan.org/VLC_command-line_help] If nothing is provided,
  /// vlc will run without any options set.
  final List<String>? options;

  /// The video should be played automatically.
  final bool autoPlay;

  /// Set keep playing video in background, when app goes in background.
  /// The default value is false.
  final bool allowBackgroundPlayback;

  /// Only set for [asset] videos. The package that the asset was loaded from.
  String? packageName;

  /// Video Play
  late LibVlc _libVlc;
  late MediaPlayer _mediaPlayer;
  late Media _media;
  late VideoView _videoView;

  final _initCompleter = Completer<bool>();

  VlcPlayerController({
    required this.dataSource,
    this.allowBackgroundPlayback = false,
    this.packageName,
    this.hwAcc = HwAcc.auto,
    this.autoPlay = true,
    this.options,
  }) {
    _init();
  }

  factory VlcPlayerController.asset(
    String assetName, {
    bool allowBackgroundPlayback = false,
    String? packageName,
    HwAcc hwAcc = HwAcc.auto,
    bool autoPlay = true,
    List<String>? options,
  }) => VlcPlayerController(
    dataSource: DataSource(type: DataSourceType.asset, value: assetName),
    allowBackgroundPlayback: allowBackgroundPlayback,
    packageName: packageName,
    hwAcc: hwAcc,
    autoPlay: autoPlay,
    options: options,
  );

  factory VlcPlayerController.network(
    String url, {
    bool allowBackgroundPlayback = false,
    String? packageName,
    HwAcc hwAcc = HwAcc.auto,
    bool autoPlay = true,
    List<String>? options,
  }) => VlcPlayerController(
    dataSource: DataSource(type: DataSourceType.network, value: url),
    allowBackgroundPlayback: allowBackgroundPlayback,
    packageName: packageName,
    hwAcc: hwAcc,
    autoPlay: autoPlay,
    options: options,
  );

  factory VlcPlayerController.file(
    File file, {
    bool allowBackgroundPlayback = true,
    String? packageName,
    HwAcc hwAcc = HwAcc.auto,
    bool autoPlay = true,
    List<String>? options,
  }) => VlcPlayerController(
    dataSource: DataSource(
      type: DataSourceType.file,
      value: 'file://${file.path}',
    ),
    allowBackgroundPlayback: allowBackgroundPlayback,
    packageName: packageName,
    hwAcc: hwAcc,
    autoPlay: autoPlay,
    options: options,
  );

  Future<void> _init() async {
    _libVlc = await LibVlc.create();
    _mediaPlayer = await MediaPlayer.create(_libVlc);
    _media = await Media.create(libVlc: _libVlc, dataSource: dataSource);
    _videoView = await VideoView.create();
    await _media.parseAsync();
    _initCompleter.complete(true);
  }

  Future<bool> prepared() async => _initCompleter.future;

  bool isPrepared() => _initCompleter.isCompleted;

  Widget buildView() => _videoView.buildView();

  Future<void> dispose() async {
    await _mediaPlayer.dispose();
    await _media.dispose();
    await _libVlc.dispose();
    await _videoView.dispose();
  }
}
