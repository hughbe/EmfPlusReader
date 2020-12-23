//
//  EmfPlusImage.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.1.4 EmfPlusImage Object
/// The EmfPlusImage object specifies a graphics image in the form of a bitmap or metafile.
/// This object is generic and is used to specify different types of image data, including:
///  An EmfPlusBitmap object; and
///  An EmfPlusMetafile object.
/// See section 2.2.1 for the specification of additional graphics objects.
public struct EmfPlusImage {
    public let version: EmfPlusGraphicsVersion
    public let type: ImageDataType
    public let imageData: ImageData
    
    public init(dataStream: inout DataStream, dataSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard dataSize >= 0x00000008 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Version (4 bytes): An EmfPlusGraphicsVersion object that specifies the version of operating system graphics that was used
        /// to create this object.
        self.version = try EmfPlusGraphicsVersion(dataStream: &dataStream)
        
        /// Type (4 bytes): An unsigned integer that specifies the type of data in the ImageData field. This value is defined in the
        /// ImageDataType enumeration.
        self.type = try ImageDataType(dataStream: &dataStream)
        
        /// ImageData (variable): Variable-length data that defines the image data specified in the Type field. The content and format
        /// of the data can be different for every image type.
        switch self.type {
        case .unknown:
            throw EmfPlusReadError.corrupted
        case .bitmap:
            self.imageData = .bitmap(try EmfPlusBitmap(dataStream: &dataStream, size: dataSize - 0x00000008))
        case .metafile:
            self.imageData = .metafile(try EmfPlusMetafile(dataStream: &dataStream, size: dataSize - 0x00000008))
        }
        
        guard dataStream.position - startPosition == dataSize else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    public enum ImageData {
        case bitmap(_: EmfPlusBitmap)
        case metafile(_: EmfPlusMetafile)
    }
}
