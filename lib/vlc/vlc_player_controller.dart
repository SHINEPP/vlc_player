import 'package:vlc_player/vlc/data_source.dart';
import 'package:vlc_player/vlc/lib_vlc.dart';
import 'package:vlc_player/vlc/media.dart';
import 'package:vlc_player/vlc/media_player.dart';

class VlcPlayerController {
  Future<void> init() async {
    final url =
        "http://192.168.111.27:9000/video/功夫熊猫(1-4)/功夫熊猫.Kung.Fu.Panda.2008.BD1080P.X264.AC3.Mandarin&English.CHS-ENG.Adans.mkv";
    final libVlc = await LibVlc.create();
    final media = await Media.create(
      libVlc: libVlc,
      dataSource: DataSource(type: DataSourceType.network, value: url),
    );
    media.setEventListener();
    await media.parseAsync();


    final mediaPlayer = await MediaPlayer.create(libVlc);

    //await mediaPlayer.dispose();
    //await media.dispose();
    //await libVlc.dispose();
  }

  Future<void> dispose() async {

  }
}
