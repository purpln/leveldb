// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "leveldb",
    products: [.library(name: "leveldb", targets: ["leveldb"])],
    targets: [.systemLibrary(name: "cleveldb", pkgConfig: "cleveldb"), .target(name: "leveldb", dependencies: ["cleveldb"])]
)
