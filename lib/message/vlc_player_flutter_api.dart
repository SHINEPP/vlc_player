import 'package:flutter/cupertino.dart';
import 'package:vlc_player/message/messages.g.dart';

class VlcPlayerFlutterApi extends VlcFlutterApi {
  @override
  bool onMediaEvent(int mediaId, int event) {
    debugPrint("onMediaEvent(), mediaId = $mediaId, event = $event");
    return true;
  }
}
