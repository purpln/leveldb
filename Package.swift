// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "leveldb",
    products: [.library(name: "leveldb", targets: ["package"])],
    targets: [.systemLibrary(name: "leveldb", pkgConfig: "leveldb"), .target(name: "package", dependencies: ["leveldb"])]
)
