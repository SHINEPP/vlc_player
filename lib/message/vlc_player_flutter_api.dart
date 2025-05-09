import 'package:flutter/cupertino.dart';
import 'package:vlc_player/message/messages.g.dart';

class VlcPlayerFlutterApi extends VlcFlutterApi {
  @override
  void onMediaEvent(int event) {
    debugPrint("onMediaEvent()");
  }
}
