import 'package:vlc_player/vlc/lib_vlc.dart';
import 'package:vlc_player/vlc_player_platform_interface.dart';

import 'data_source.dart';
import 'hw_acc.dart';

enum MediaEvent {
  metaChanged,
  subItemAdded,
  durationChanged,
  parsedChanged,
  subItemTreeAdded,
}

class Media {
  Media({required this.mediaId});

  final int mediaId;

  static Future<Media> create({
    required LibVlc libVlc,
    required DataSource dataSource,
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

  Future<bool> parseAsync() async {
    return await VlcPlayerPlatform.instance.mediaParseAsync(this);
  }

  Future<void> dispose() async {
    await VlcPlayerPlatform.instance.disposeMedia(this);
  }
}
