import 'package:vlc_player/vlc/lib_vlc.dart';
import 'package:vlc_player/vlc_player_platform_interface.dart';

import 'data_source.dart';
import 'hw_acc.dart';

class Media {
  Media({required this.mediaId});

  final int mediaId;

  static Future<Media> create(
    LibVlc libVlc,
    DataSource dataSource, {
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

  Future<void> dispose() async {
    await VlcPlayerPlatform.instance.disposeMedia(this);
  }
}
