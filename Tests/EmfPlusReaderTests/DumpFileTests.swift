import XCTest
import DataStream
import Foundation
import EmfReader
import WmfReader
@testable import EmfPlusReader

final class DumpFileTests: XCTestCase {
    func testDumpEmfPlus() throws {
        var files: [(String, String)] = []
        files.append(("aspose_missing-font", "emf"))
        files.append(("aspose_Picture1", "emf"))
        files.append(("aspose_Picture2", "emf"))
        files.append(("LibreOffice_1", "emf"))
        files.append(("LibreOffice_60638_shape2", "emf"))
        files.append(("LibreOffice_DrawLineWithTexture", "emf"))
        files.append(("LibreOffice_TextureBrush", "emf"))
        files.append(("LibreOffice_TileImage", "emf"))
        files.append(("LibreOffice_bug3", "emf"))
        files.append(("LibreOffice_bug3a", "EMF"))
        files.append(("LibreOffice_bug3d", "EMF"))
        files.append(("LibreOffice_image1 (1)", "emf"))
        files.append(("LibreOffice_image1", "emf"))
        files.append(("LibreOffice_image15", "emf"))
        files.append(("LibreOffice_image21", "emf"))
        files.append(("LibreOffice_image3", "emf"))
        files.append(("LibreOffice_test", "emf"))
        files.append(("LibreOffice_test_libuemf_p_ref", "emf"))
        files.append(("LibreOffice_TestDrawLine", "emf"))
        files.append(("LibreOffice_TestDrawString", "emf"))
        files.append(("LibreOffice_TestDrawStringTransparent", "emf"))
        files.append(("LibreOffice_TestLinearGradient", "emf"))
        files.append(("image-type_test-emf-plus", "emf"))
        files.append(("test-000", "emf"))
        files.append(("test-038", "emf"))
        files.append(("test-068", "emf"))
        files.append(("test-075", "emf"))
        files.append(("test-109", "emf"))
        files.append(("test-120", "emf"))
        files.append(("test-155", "emf"))
        files.append(("test-160", "emf"))
        files.append(("test-161", "emf"))
        files.append(("test-162", "emf"))
        files.append(("test-163", "emf"))
        files.append(("test-179", "emf"))
        files.append(("test-180", "emf"))
        files.append(("test-182", "emf"))
        files.append(("test-183", "emf"))
        files.append(("test-184", "emf"))
        files.append(("test-185", "emf"))
        files.append(("hughbe", "emf"))
        for (name, fileExtension) in files {
            let data = try getData(name: name, fileExtension: fileExtension)
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
                    if case let .image(image) = object.objectData,
                       case let .metafile(metafile) = image.imageData {
                        switch metafile.type {
                        case .wmf, .wmfPlaceable:
                            let file = try WmfFile(data: Data(metafile.metafileData))
                            try file.enumerateRecords { record in
                                print(record)
                                return .continue
                            }
                        case .emf, .emfPlusDual, .emfPlusOnly:
                            let file = try EmfFile(data: Data(metafile.metafileData))
                            var emfPlusData = Data()
                            try file.enumerateRecords { record in
                                print(record)
                                guard case let .comment(comment) = record,
                                      case let .commentEmfPlus(emfPlusComment) = comment else {
                                    return .continue
                                }

                                emfPlusData += emfPlusComment.emfPlusRecords
                                return .continue
                            }
                            
                            if emfPlusData.count > 0 {
                                let emfPlusFile = try EmfPlusFile(data: emfPlusData)
                                try emfPlusFile.enumerateRecords { record in
                                    print(record)
                                    return .continue
                                }
                            }
                        }
                    }
                }

                print(record)
                return .continue
            }
        }
    }

    static var allTests = [
        ("testDumpEmfPlus", testDumpEmfPlus),
    ]
}
