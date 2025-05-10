package com.shinezzl.vlc_player.vlc

import io.flutter.view.TextureRegistry.TextureEntry

class VideoView(private val textureView: TextureEntry) {

    fun release() {
        textureView.release()
    }
}