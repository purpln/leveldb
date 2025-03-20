// swift-tools-version: 5.7

import PackageDescription

let apple: [Platform] = [.macOS, .macCatalyst, .iOS, .tvOS, .watchOS, .visionOS]
let posix: [Platform] = [.android, .linux] + apple

let windows: Bool = Context.environment["OS"] == "Windows_NT"

let env = windows ? ["util/env_posix.cc"] : ["util/env_windows.cc"]

let package = Package(name: "leveldb", products: [
    .library(name: "leveldb", targets: ["leveldb"]),
], targets: [
    .target(name: "leveldb", exclude: [
        "db/leveldbutil.cc",
        "db/autocompact_test.cc",
        "db/corruption_test.cc",
        "db/db_test.cc",
        "db/dbformat_test.cc",
        "db/fault_injection_test.cc",
        "db/filename_test.cc",
        "db/log_test.cc",
        "db/recovery_test.cc",
        "db/skiplist_test.cc",
        "db/version_edit_test.cc",
        "db/version_set_test.cc",
        "db/write_batch_test.cc",
        "issues/issue178_test.cc",
        "issues/issue200_test.cc",
        "issues/issue320_test.cc",
        "table/filter_block_test.cc",
        "table/table_test.cc",
        "util/arena_test.cc",
        "util/bloom_test.cc",
        "util/cache_test.cc",
        "util/coding_test.cc",
        "util/crc32c_test.cc",
        "util/env_posix_test.cc",
        "util/env_test.cc",
        "util/env_windows_test.cc",
        "util/hash_test.cc",
        "util/logging_test.cc",
        "util/no_destructor_test.cc",
        "util/status_test.cc",
        "util/testutil.cc",
        "db/c_test.c",
        "port/README.md",
        "port/port_config.h.in",
    ] + env, sources: [
        "db",
        "port",
        "table",
        "util",
        "include",
    ], cxxSettings: [
        .define("LEVELDB_PLATFORM_WINDOWS", .when(platforms: [.windows])),
        .define("LEVELDB_PLATFORM_POSIX", .when(platforms: posix)),
        .define("HAVE_FULLFSYNC", .when(platforms: apple)),
        .headerSearchPath("."),
        .headerSearchPath("include"),
        .define("NDEBUG", .when(configuration: .release)),
    ]),
], cxxLanguageStandard: .cxx17)
