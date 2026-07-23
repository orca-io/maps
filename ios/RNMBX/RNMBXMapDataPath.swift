import Foundation

private let RNMBXMapDataPathErrorDomain = "RNMBXMapDataPath"

func RNMBXApplicationSupportDirectory() throws -> URL {
  guard let appSupport = FileManager.default.urls(
    for: .applicationSupportDirectory,
    in: .userDomainMask
  ).first else {
    throw NSError(
      domain: RNMBXMapDataPathErrorDomain,
      code: 1,
      userInfo: [NSLocalizedDescriptionKey: "Application Support directory unavailable"]
    )
  }

  return appSupport
}

func RNMBXMapDataPath() throws -> URL {
  let fileManager = FileManager.default
  let appSupport = try RNMBXApplicationSupportDirectory()
  let defaultDataPath = appSupport.appendingPathComponent(".mapbox/map_data", isDirectory: true)
  let customRoot = appSupport.appendingPathComponent(".mapbox_custom", isDirectory: true)

  guard fileManager.fileExists(atPath: customRoot.path),
    let entries = try? fileManager.contentsOfDirectory(
      at: customRoot,
      includingPropertiesForKeys: [.isDirectoryKey],
      options: []
    ) else {
    return defaultDataPath
  }

  for entry in entries {
    if let isDir = try? entry.resourceValues(forKeys: [.isDirectoryKey]).isDirectory,
      isDir == true {
      let candidateMapData = entry.appendingPathComponent("map_data", isDirectory: true)
      let candidateDb = candidateMapData.appendingPathComponent("map_data.db")

      if fileManager.fileExists(atPath: candidateDb.path) {
        return candidateMapData
      }
    }
  }

  return defaultDataPath
}

func RNMBXNewMapDataPath() throws -> URL {
  let appSupport = try RNMBXApplicationSupportDirectory()
  return appSupport.appendingPathComponent(
    ".mapbox_custom/\(UUID().uuidString)/map_data",
    isDirectory: true
  )
}
