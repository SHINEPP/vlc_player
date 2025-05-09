import 'package:flutter/cupertino.dart';
import 'package:vlc_player/message/messages.g.dart';
import 'package:vlc_player/vlc/media.dart';

class VlcPlayerFlutterApi extends VlcFlutterApi {
  @override
  bool onMediaEvent(int mediaId, int eventIndex) {
    debugPrint("onMediaEvent(), mediaId = $mediaId, eventIndex = $eventIndex");
    Media.onMediaEvent(mediaId, eventIndex);
    return true;
  }
}
