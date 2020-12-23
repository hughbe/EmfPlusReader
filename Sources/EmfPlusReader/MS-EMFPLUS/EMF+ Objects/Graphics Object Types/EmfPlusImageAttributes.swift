//
//  EmfPlusImageAttributes.swift
//  
//
//  Created by Hugh Bellamy on 20/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.1.5 EmfPlusImageAttributes Object
/// The EmfPlusImageAttributes object specifies how bitmap image colors are manipulated during rendering.
public struct EmfPlusImageAttributes {
    public let version: EmfPlusGraphicsVersion
    public let reserved1: UInt32
    public let wrapMode: WrapMode
    public let clampColor: EmfPlusARGB
    public let objectClamp: ObjectClamp
    public let reserved2: UInt32
    
    public init(dataStream: inout DataStream, dataSize: UInt32) throws {
        guard dataSize == 24 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Version (4 bytes): An EmfPlusGraphicsVersion object that specifies the version of operating system graphics that was used
        /// to create this object.
        self.version = try EmfPlusGraphicsVersion(dataStream: &dataStream)

        /// Reserved1 (4 bytes): A field that is not used and MUST be ignored.
        self.reserved1 = try dataStream.read(endianess: .littleEndian)

        /// WrapMode (4 bytes): An unsigned integer that specifies how to handle edge conditions with a value from the WrapMode
        /// enumeration.
        self.wrapMode = try WrapMode(dataStream: &dataStream)

        /// ClampColor (4 bytes): An EmfPlusARGB object that specifies the edge color to use when the WrapMode value is
        /// WrapModeClamp. This color is visible when the source rectangle processed by an EmfPlusDrawImage record is larger than
        /// the image itself.
        self.clampColor = try EmfPlusARGB(dataStream: &dataStream)
        
        /// ObjectClamp (4 bytes): A signed integer that specifies the object clamping behavior. It is not used until this object is applied
        /// to an image being drawn. This value MUST be one of the values defined in the following table.
        self.objectClamp = try ObjectClamp(dataStream: &dataStream)
        
        /// Reserved2 (4 bytes): A value that SHOULD be set to zero and MUST be ignored upon receipt.
        self.reserved2 = try dataStream.read(endianess: .littleEndian)
    }
    
    /// ObjectClamp (4 bytes): A signed integer that specifies the object clamping behavior. It is not used until this object is applied to
    /// an image being drawn. This value MUST be one of the values defined in the following table.
    public enum ObjectClamp: Int32, DataStreamCreatable {
        /// RectClamp 0x00000000
        /// The object is clamped to a rectangle.
        case rect = 0x00000000
        
        /// BitmapClamp 0x00000001
        /// The object is clamped to a bitmap.
        case bitmap = 0x00000001
    }
}
