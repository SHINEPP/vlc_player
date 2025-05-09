package com.shinezzl.vlc_player

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** VlcPlayerPlugin */
class VlcPlayerPlugin : FlutterPlugin {

    private lateinit var vlcPlayerApi: VlcPlayerApi

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        vlcPlayerApi = VlcPlayerApi(flutterPluginBinding)
        vlcPlayerApi.startListening()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        vlcPlayerApi.stopListening()
    }
}
