//
//  EmfPlusSetWorldTransform.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.9.6 EmfPlusSetWorldTransform Record
/// The EmfPlusSetWorldTransform record sets the world transform according to the values in a specified transform matrix.
/// See section 2.3.9 for the specification of additional transform record types.
public struct EmfPlusSetWorldTransform {
    public let type: RecordType
    public let flags: UInt16
    public let size: UInt32
    public let dataSize: UInt32
    public let matrixData: EmfPlusTransformMatrix
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusSetWorldTransform from the RecordType
        /// enumeration.
        /// The value MUST be 0x402A.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .setWorldTransform else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that is not used. This field SHOULD be set to zero and MUST be ignored upon receipt.
        self.flags = try dataStream.read(endianess: .littleEndian)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data. For this record type, the value MUST be 0x00000024.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000024 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of data in the record-specific
        /// data that follows. For this record type, the value MUST be 0x00000018.
        self.dataSize = try dataStream.read(endianess: .littleEndian)
        guard self.dataSize == 0x00000018 else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataStartPosition = dataStream.position
        
        /// MatrixData (24 bytes): An EmfPlusTransformMatrix object that defines the new current world transform.
        self.matrixData = try EmfPlusTransformMatrix(dataStream: &dataStream)
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
