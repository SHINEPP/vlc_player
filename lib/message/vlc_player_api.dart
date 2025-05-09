import 'package:pigeon/pigeon.dart';

class LibVlcInput {
  List<String>? options;
}

class LibVlcOutput {
  int? libVlcId;
}

@HostApi()
abstract class LibVlcApi {

  @async
  LibVlcOutput createLibVlc(LibVlcInput input);
}
