// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "LevelDB",
    platforms: [.iOS(.v11), .macOS(.v10_13)],
    products: [
        .library(name: "LevelDB", targets: ["LevelDB-swift"])
    ],
    targets: [
        .target(name: "LevelDB-swift", dependencies: ["LevelDB-wrapper"]),
        .target(name: "LevelDB-wrapper", dependencies: ["leveldb"]),
        .binaryTarget(name: "leveldb", path: "leveldb.xcframework")
    ],
    cxxLanguageStandard: .gnucxx14
)
