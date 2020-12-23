//
//  EmfPlusMetafile.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.27 EmfPlusMetafile Object
/// The EmfPlusMetafileData object specifies a metafile that contains a graphics image.
/// Graphics images are specified by EmfPlusImage objects. An EmfPlusMetafile object MUST be present in the ImageData field of an
/// EmfPlusImage object if ImageTypeMetafile is specified in its Type field.
/// This object is generic and is used for different types of data, including:
///  A WMF metafile [MS-WMF];
///  A WMF metafile which can be placed;
///  An EMF metafile [MS-EMF];
///  An EMF+ metafile that specifies graphics operations with EMF+ records only; and
///  An EMF+ metafile that specifies graphics operations with both EMF+ and EMF records ([MS-EMF] section 2.3).
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusMetafile {
    public let type: MetafileDataType
    public let metafileDataSize: UInt32
    public let metafileData: [UInt8]
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size >= 0x00000008 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Type (4 bytes): An unsigned integer that specifies the type of metafile that is embedded in the MetafileData field. This value
        /// is defined in the MetafileDataType enumeration.
        self.type = try MetafileDataType(dataStream: &dataStream)
        
        /// MetafileDataSize (4 bytes): An unsigned integer that specifies the size in bytes of the metafile data in the MetafileData field.
        self.metafileDataSize = try dataStream.read(endianess: .littleEndian)
        guard 0x00000008 + self.metafileDataSize <= size else {
            throw EmfPlusReadError.corrupted
        }
        
        /// MetafileData (variable): Variable-length data that specifies the embedded metafile. The content and format of the data can
        /// be different for each metafile type.
        self.metafileData = try dataStream.readBytes(count: Int(self.metafileDataSize))
        
        /// Seen padding.
        let remainingCount = Int(size) - (dataStream.position - startPosition)
        if remainingCount > 0 {
            guard dataStream.position + remainingCount <= dataStream.count else {
                throw EmfPlusReadError.corrupted
            }
            
            dataStream.position += remainingCount
        }
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
