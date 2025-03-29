// swift-tools-version: 5.7

import PackageDescription

let apple: [Platform] = [.macOS, .macCatalyst, .iOS, .tvOS, .watchOS, .visionOS]
let posix: [Platform] = [.android, .linux] + apple

let windows: Bool = Context.environment["OS"] == "Windows_NT"

let env = windows ? ["leveldb/util/env_posix.cc"] : ["leveldb/util/env_windows.cc"]

let package = Package(name: "leveldb", products: [
    .library(name: "leveldb", targets: ["leveldb"]),
], targets: [
    .target(name: "leveldb", exclude: [
        "leveldb/db/leveldbutil.cc",
        "leveldb/db/autocompact_test.cc",
        "leveldb/db/corruption_test.cc",
        "leveldb/db/db_test.cc",
        "leveldb/db/dbformat_test.cc",
        "leveldb/db/fault_injection_test.cc",
        "leveldb/db/filename_test.cc",
        "leveldb/db/log_test.cc",
        "leveldb/db/recovery_test.cc",
        "leveldb/db/skiplist_test.cc",
        "leveldb/db/version_edit_test.cc",
        "leveldb/db/version_set_test.cc",
        "leveldb/db/write_batch_test.cc",
        "leveldb/issues/issue178_test.cc",
        "leveldb/issues/issue200_test.cc",
        "leveldb/issues/issue320_test.cc",
        "leveldb/table/filter_block_test.cc",
        "leveldb/table/table_test.cc",
        "leveldb/util/arena_test.cc",
        "leveldb/util/bloom_test.cc",
        "leveldb/util/cache_test.cc",
        "leveldb/util/coding_test.cc",
        "leveldb/util/crc32c_test.cc",
        "leveldb/util/env_posix_test.cc",
        "leveldb/util/env_test.cc",
        "leveldb/util/env_windows_test.cc",
        "leveldb/util/hash_test.cc",
        "leveldb/util/logging_test.cc",
        "leveldb/util/no_destructor_test.cc",
        "leveldb/util/status_test.cc",
        "leveldb/util/testutil.cc",
        "leveldb/db/c_test.c",
        "leveldb/port/README.md",
        "leveldb/port/port_config.h.in",
    ] + env, sources: [
        "leveldb/db",
        "leveldb/port",
        "leveldb/table",
        "leveldb/util",
        //"leveldb/include",
    ], cxxSettings: [
        .define("_ALLOW_COMPILER_AND_STL_VERSION_MISMATCH", .when(platforms: [.windows])),
        .define("LEVELDB_PLATFORM_WINDOWS", .when(platforms: [.windows])),
        .define("LEVELDB_PLATFORM_POSIX", .when(platforms: posix)),
        .define("HAVE_FULLFSYNC", .when(platforms: apple)),
        .headerSearchPath("leveldb"),
        .headerSearchPath("leveldb/include"),
        .define("NDEBUG", .when(configuration: .release)),
    ]),
], cxxLanguageStandard: .cxx17)
