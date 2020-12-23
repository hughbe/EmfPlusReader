//
//  EmfPlusOffsetClip.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.1.1 EmfPlusOffsetClip Record
/// The EmfPlusOffsetClip record applies a translation transform on the current clipping region for the world space.
/// The new current clipping region is set to the result of the translation transform.
/// See section 2.3.1 for the specification of additional clipping record types.
public struct EmfPlusOffsetClip {
    public let type: RecordType
    public let flags: UInt16
    public let size: UInt32
    public let dataSize: UInt32
    public let dx: Float
    public let dy: Float
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusOffsetClip from the RecordType enumeration.
        /// The value MUST be 0x4035.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .offsetClip else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that is not used. This field SHOULD be set to zero and MUST be ignored upon receipt.
        self.flags = try dataStream.read(endianess: .littleEndian)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data. For this record type, the value MUST be 0x00000014.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000014 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of data in the record-specific
        /// data that follows. For this record type, the value MUST be 0x00000008.
        self.dataSize = try dataStream.read(endianess: .littleEndian)
        guard self.dataSize == 0x00000008 else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataStartPosition = dataStream.position
        
        /// dx (4 bytes): A floating-point value that specifies the horizontal offset for the translation.
        self.dx = try dataStream.readFloat(endianess: .littleEndian)
        
        /// dy (4 bytes): A floating-point value that specifies the vertical offset for the translation.
        self.dy = try dataStream.readFloat(endianess: .littleEndian)
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
