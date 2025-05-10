import 'package:flutter/material.dart';
import 'package:vlc_player/vlc/vlc_player_controller.dart';

class VlcVideoPlayer extends StatefulWidget {
  const VlcVideoPlayer({super.key, required this.controller});

  final VlcPlayerController controller;

  @override
  State<VlcVideoPlayer> createState() => _VlcVideoPlayerState();
}

class _VlcVideoPlayerState extends State<VlcVideoPlayer> {
  late VlcPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _init();
  }

  Future<void> _init() async {
    await _controller.prepared();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isPrepared()) {
      return Container();
    }
    return Container(
      color: Colors.black,
      child: AspectRatio(
        aspectRatio: 1.9,
        child: Stack(fit: StackFit.expand, children: [_controller.buildView()]),
      ),
    );
  }
}
