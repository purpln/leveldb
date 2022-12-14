```swift
guard let database = LevelDB(url: url.path) else { return }
let key = Array("key".utf8)
let data = Array("value".utf8)
database.set(key, data)
guard let value = database.get(key) else { return }
```
