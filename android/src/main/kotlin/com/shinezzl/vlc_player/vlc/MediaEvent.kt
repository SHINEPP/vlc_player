package com.shinezzl.vlc_player.vlc

enum class MediaEvent(val index: Long) {
    META_CHANGED(0),
    SUB_ITEM_ADDED(1),
    DURATION_CHANGED(2),
    PARSED_CHANGED(3),
    SUB_ITEM_TREE_ADDED(4)
}