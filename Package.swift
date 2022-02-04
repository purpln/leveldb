// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "leveldb",
    products: [.library(name: "leveldb", targets: ["LevelDB"])],
    targets: [.systemLibrary(name: "cleveldb", pkgConfig: "leveldb"), .target(name: "LevelDB", dependencies: ["cleveldb"])]
)
