# EmfPlusReader

Swift definitions for structures, enumerations and functions defined in [MS-EMFPLUS](https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-emfplus/)

## Example Usage

Add the following line to your project's SwiftPM dependencies:
```swift
.package(url: "https://github.com/hughbe/EmfPlusReader", from: "1.0.0"),
```

```swift
import EmfReader
import EmfPlusReader

let data = Data(contentsOfFile: "<path-to-file>.emf")!
let file = try EmfFile(data: data)
var emfPlusData = Data()
try file.enumerateRecords { record in
    guard case let .comment(comment) = record,
          case let .commentEmfPlus(emfPlusComment) = comment else {
        return .continue
    }

    emfPlusData += emfPlusComment.emfPlusRecords
    return .continue
}

let emfPlusFile = try EmfPlusFile(data: emfPlusData)
try emfPlusFile.enumerateRecords { record in
    if case let .object(object) = record {
        if case .continues = object.objectData {
            return .continue
        }
    }

    print(record)
    return .continue
}
```
