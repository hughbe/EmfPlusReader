//
//  EmfPlusCustomLineCap.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.1.2 EmfPlusCustomLineCap Object
/// The EmfPlusCustomLineCap object specifies the shape to use at the ends of a line drawn by a graphics pen.
/// This object is generic and is used to specify different types of custom line cap data, including:
///  An EmfPlusCustomLineCapArrowData object; and
///  An EmfPlusCustomLineCapData object.
/// See section 2.2.1 for the specification of additional graphics objects.
public struct EmfPlusCustomLineCap {
    public let version: EmfPlusGraphicsVersion
    public let type: CustomLineCapDataType
    public let customLineCapData: CustomLineCapData
    
    public init(dataStream: inout DataStream, dataSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard dataSize >= 0x00000008 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Version (4 bytes): An EmfPlusGraphicsVersion object that specifies the version of operating system graphics that was used
        /// to create this object.
        self.version = try EmfPlusGraphicsVersion(dataStream: &dataStream)
        
        /// Type (4 bytes): A signed integer that specifies the type of custom line cap object, which determines the contents of the
        /// CustomLineCapData field. This value is defined in the CustomLineCapDataType enumeration.
        self.type = try CustomLineCapDataType(dataStream: &dataStream)
        
        /// CustomLineCapData (variable): Variable-length data that defines the custom line cap data object specified in the Type
        /// field. The content and format of the data can be different for every custom line cap type.
        switch self.type {
        case .adjustableArrow:
            guard dataSize == 60 else {
                throw EmfPlusReadError.corrupted
            }

            self.customLineCapData = .adjustableArrow(try EmfPlusCustomLineCapArrowData(dataStream: &dataStream, size: dataSize - 0x00000008))
        case .default:
            self.customLineCapData = .default(try EmfPlusCustomLineCapData(dataStream: &dataStream, size: dataSize - 0x00000008))
        }
        
        guard dataStream.position - startPosition == dataSize else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// CustomLineCapData (variable): Variable-length data that defines the custom line cap data object specified in the Type
    /// field. The content and format of the data can be different for every custom line cap type.
    public enum CustomLineCapData {
        case adjustableArrow(_: EmfPlusCustomLineCapArrowData)
        case `default`(_: EmfPlusCustomLineCapData)
    }
}
