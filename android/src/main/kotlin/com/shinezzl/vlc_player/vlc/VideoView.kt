package com.shinezzl.vlc_player.vlc

import io.flutter.view.TextureRegistry.SurfaceTextureEntry

class VideoView(val textureView: SurfaceTextureEntry) {

    fun release() {
        textureView.release()
    }
}