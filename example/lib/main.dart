import 'package:flutter/material.dart';
import 'package:vlc_player/vlc_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late VlcPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VlcPlayerController.network(
      "https://s3.ap-southeast-2.amazonaws.com/app-4k-wallpaper-list/res/Live/live/1.mp4",
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Vlc Player')),
        body: VlcVideoPlayer(controller: _controller),
      ),
    );
  }
}
