package com.shinezzl.vlc_player

import java.util.concurrent.atomic.AtomicLong


class ObjectHelper {
    companion object {
        private val vlcId = AtomicLong(0)
    }

    private val vlcObjects = HashMap<Long, Any>()

    fun putObject(vlcObject: Any): Long {
        val id = vlcId.addAndGet(1)
        vlcObjects[id] = vlcObject
        return id
    }

    @Suppress("UNCHECKED_CAST")
    fun <T> getObject(id: Long): T? {
        return vlcObjects[id] as T?
    }
}