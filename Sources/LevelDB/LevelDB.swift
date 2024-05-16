import CLevelDB

public class LevelDB {
    private let database: OpaquePointer

    public init?(url: String) {
        let options = leveldb_options_create()
        defer { leveldb_options_destroy(options) }
        var errorPtr: UnsafeMutablePointer<Int8>? = nil
        
        leveldb_options_set_create_if_missing(options, 1)

        guard let database = leveldb_open(options, url, &errorPtr) else {
            if let validErrorPtr = errorPtr {
                print("leveldb:", String(cString: validErrorPtr))
            }
            return nil
        }
        self.database = database
    }

    deinit {
        leveldb_close(database)
    }
}

extension LevelDB {
    public subscript(key: [UInt8]) -> [UInt8]? {
        get { get(key) }
        set { set(key, newValue) }
    }
    
    public func get(_ key: [UInt8]) -> [UInt8]? {
        let options = leveldb_readoptions_create()
        defer { leveldb_readoptions_destroy(options) }
        var errorPtr: UnsafeMutablePointer<Int8>? = nil

        var length: Int = 0

        if let valueBytes = leveldb_get(database, options, key.map { Int8(bitPattern: $0) }, key.count, &length, &errorPtr) {
            let valueRawPtr = UnsafeRawPointer(valueBytes)
            let buffer = UnsafeBufferPointer(start: valueRawPtr.assumingMemoryBound(to: Int8.self), count: length)
            return Array(buffer.map { UInt8(bitPattern: $0) })
        } else {
            return nil
        }
    }

    public func set(_ key: [UInt8], _ data: [UInt8]?) {
        if let data = data {
            update(key, data)
        } else {
            delete(key)
        }
    }

    private func update(_ key: [UInt8], _ data: [UInt8]) {
        let options = leveldb_writeoptions_create()
        defer { leveldb_writeoptions_destroy(options) }
        var errorPtr: UnsafeMutablePointer<Int8>? = nil

        leveldb_put(database, options, key.map { Int8(bitPattern: $0) }, key.count, data.map { Int8(bitPattern: $0) }, data.count, &errorPtr)
    }

    private func delete(_ key: [UInt8]) {
        let options = leveldb_writeoptions_create()
        defer { leveldb_writeoptions_destroy(options) }
        var errorPtr: UnsafeMutablePointer<Int8>? = nil

        leveldb_delete(database, options, key.map { Int8(bitPattern: $0) }, key.count, &errorPtr)
    }
}

extension LevelDB {
    public func enumerated(with keyPrefix: [UInt8]? = nil) -> [(key: [UInt8], value: [UInt8])] {
        let options = leveldb_readoptions_create()
        let iterator = leveldb_create_iterator(database, options)
        defer {
            leveldb_iter_destroy(iterator)
            leveldb_readoptions_destroy(options)
        }

        func seekToBegining() {
            guard let keyPrefix = keyPrefix else {
                leveldb_iter_seek_to_first(iterator)
                return
            }

            leveldb_iter_seek(iterator, keyPrefix.map { Int8(bitPattern: $0) }, keyPrefix.count)
        }

        var isValid: Bool {
            let valid = leveldb_iter_valid(iterator) != 0
            guard valid else { return false }

            guard let keyPrefix = keyPrefix else { return valid }

            var length = 0
            guard let keyPtr = leveldb_iter_key(iterator, &length) else { return false }

            let keyRawPtr = UnsafeRawPointer(keyPtr)
            let buffer = UnsafeBufferPointer(start: keyRawPtr.assumingMemoryBound(to: Int8.self), count: length)
            let key = Array(buffer.map { UInt8(bitPattern: $0) })
            return Set(keyPrefix).isSubset(of: Set(key))
        }

        seekToBegining()
        var array: [(key: [UInt8], value: [UInt8])] = []
        while isValid {
            defer { leveldb_iter_next(iterator) }

            var keyLength = 0
            var valueLength = 0
            guard let keyPointer = leveldb_iter_key(iterator, &keyLength),
                  let valuePointer = leveldb_iter_value(iterator, &valueLength) else { continue }

            let keyRawPointer = UnsafeRawPointer(keyPointer)
            let keyBuffer = UnsafeBufferPointer(start: keyRawPointer.assumingMemoryBound(to: Int8.self), count: keyLength)
            let key = Array(keyBuffer.map { UInt8(bitPattern: $0) })

            let valueRawPointer = UnsafeRawPointer(valuePointer)
            let valueBuffer = UnsafeBufferPointer(start: valueRawPointer.assumingMemoryBound(to: Int8.self), count: valueLength)
            let value = Array(valueBuffer.map { UInt8(bitPattern: $0) })

            array.append((key, value))
        }
        return array
    }
}

extension LevelDB {
    public static var version: String {
        let majorVersion = leveldb_major_version()
        let minorVersion = leveldb_minor_version()
        return "\(majorVersion).\(minorVersion)"
    }
}
