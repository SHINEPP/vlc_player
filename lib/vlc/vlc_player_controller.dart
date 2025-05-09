import 'package:flutter/foundation.dart';
import 'package:vlc_player/vlc/data_source.dart';
import 'package:vlc_player/vlc/lib_vlc.dart';
import 'package:vlc_player/vlc/media.dart';
import 'package:vlc_player/vlc/media_player.dart';

class VlcPlayerController {
  Future<void> init() async {
    final url =
        "http://192.168.1.18:9000/video/落凡尘-2024_HD国语中字/落凡尘-2024_HD国语中字.mp4";
    final libVlc = await LibVlc.create();
    final media = await Media.create(
      libVlc: libVlc,
      dataSource: DataSource(type: DataSourceType.network, value: url),
    );
    media.setEventListener();
    await media.parseAsync();
    final videoTrack = await media.getVideoTrack();
    debugPrint("VideoTrack, width = ${videoTrack.width}");
    debugPrint("VideoTrack, height = ${videoTrack.height}");
    debugPrint("VideoTrack, sarDen = ${videoTrack.sarDen}");
    debugPrint("VideoTrack, sarNum = ${videoTrack.sarNum}");
    debugPrint("VideoTrack, frameRateDen = ${videoTrack.frameRateDen}");
    debugPrint("VideoTrack, frameRateNum = ${videoTrack.frameRateNum}");
    debugPrint("VideoTrack, orientation = ${videoTrack.orientation}");
    debugPrint("VideoTrack, projection = ${videoTrack.projection}");

    final mediaPlayer = await MediaPlayer.create(libVlc);

    //await mediaPlayer.dispose();
    //await media.dispose();
    //await libVlc.dispose();
  }

  Future<void> dispose() async {}
}
