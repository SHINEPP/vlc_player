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

  VideoTrack? _videoTrack;

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
    _media = await Media.create(libVlc: _libVlc, dataSource: dataSource);
    await _media.parseAsync();
    final videoTrack = await _media.getVideoTrack();
    _videoTrack = videoTrack;
    
    final width = videoTrack.width > 0 ? videoTrack.width : 1920;
    final height = videoTrack.height > 0 ? videoTrack.height : 1080;
    _videoView = await VideoView.create();
    _videoView.setDefaultBufferSize(width, height);

    _mediaPlayer = await MediaPlayer.create(_libVlc);
    await _mediaPlayer.attachVideoView(_videoView);
    await _mediaPlayer.setMedia(_media);
    _initCompleter.complete(true);

    if (autoPlay) {
      _mediaPlayer.play();
    }
  }

  Future<bool> prepared() async => _initCompleter.future;

  bool isPrepared() => _initCompleter.isCompleted;

  double aspectRatio() {
    final w = _videoTrack?.width ?? 0;
    final h = _videoTrack?.height ?? 0;
    if (w < 0 || h < 0) {
      return 1.9;
    }
    return w / h;
  }

  Widget buildView() => _videoView.buildView();

  Future<void> play() async {
    await prepared();
    await _mediaPlayer.play();
  }

  Future<void> pause() async {
    await prepared();
    await _mediaPlayer.pause();
  }

  Future<void> stop() async {
    await prepared();
    await _mediaPlayer.stop();
  }

  Future<bool> isPlaying() async {
    await prepared();
    return await _mediaPlayer.isPlaying();
  }

  Future<void> setTime(Duration time, {bool fast = false}) async {
    await prepared();
    await _mediaPlayer.setTime(time, fast: fast);
  }

  Future<Duration> getTime() async {
    await prepared();
    return await _mediaPlayer.getTime();
  }

  Future<void> setPosition(double position, {bool fast = false}) async {
    await prepared();
    await _mediaPlayer.setPosition(position, fast: fast);
  }

  Future<double> getPosition() async {
    await prepared();
    return await _mediaPlayer.getPosition();
  }

  Future<Duration> getLength() async {
    await prepared();
    return await _mediaPlayer.getLength();
  }

  Future<void> setVolume(int volume) async {
    await prepared();
    await _mediaPlayer.setVolume(volume);
  }

  Future<int> getVolume() async {
    await prepared();
    return await _mediaPlayer.getVolume();
  }

  Future<void> setRate(double rate) async {
    await prepared();
    await _mediaPlayer.setRate(rate);
  }

  Future<double> getRate() async {
    await prepared();
    return await _mediaPlayer.getRate();
  }

  Future<void> dispose() async {
    await prepared();
    await _mediaPlayer.dispose();
    await _media.dispose();
    await _libVlc.dispose();
    await _videoView.dispose();
  }
}
