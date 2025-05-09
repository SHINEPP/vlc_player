import 'package:vlc_player/vlc_player_platform_interface.dart';

class LibVlc {
  LibVlc({required this.vlcId});

  final int vlcId;

  static Future<LibVlc> create({List<String>? options}) async {
    return await VlcPlayerPlatform.instance.createLibVlc(options: options);
  }

  Future<void> dispose() async {
    await VlcPlayerPlatform.instance.disposeLibVlc(this);
  }
}
