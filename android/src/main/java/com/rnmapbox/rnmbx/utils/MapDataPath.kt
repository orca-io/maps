package com.rnmapbox.rnmbx.utils

import java.io.File
import java.util.UUID

fun resolveMapDataPath(filesDir: File): File {
    val defaultMapDataDir = File(filesDir, ".mapbox/map_data")
    val customRoot = File(filesDir, ".mapbox_custom")

    if (customRoot.exists()) {
        customRoot.listFiles { entry -> entry.isDirectory }?.forEach { entry ->
            val candidateMapData = File(entry, "map_data")
            val candidateDb = File(candidateMapData, "map_data.db")

            if (candidateDb.exists()) {
                return candidateMapData
            }
        }
    }

    return defaultMapDataDir
}

fun newMapDataPath(filesDir: File): File {
    return File(filesDir, ".mapbox_custom/${UUID.randomUUID()}/map_data")
}
