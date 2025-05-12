import 'package:flutter/cupertino.dart';

import '../vlc_player_platform_interface.dart';

class VideoView {
  VideoView({required this.videoViewId, required this.textureId});

  final int videoViewId;
  final int textureId;

  static Future<VideoView> create() async {
    final data = await VlcPlayerPlatform.instance.createVideoView();
    return VideoView(
      videoViewId: data.objectId ?? -1,
      textureId: data.textureId ?? -1,
    );
  }

  Future<void> setDefaultBufferSize(int width, int height) async {
    await VlcPlayerPlatform.instance.videoViewSetDefaultBufferSize(
      this,
      width,
      height,
    );
  }

  Widget buildView() {
    return VlcPlayerPlatform.instance.buildVideoView(this);
  }

  Future<void> dispose() async {
    await VlcPlayerPlatform.instance.disposeVideoView(this);
  }
}
