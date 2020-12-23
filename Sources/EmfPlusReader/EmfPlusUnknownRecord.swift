//
//  EmfPlusUnknownRecord.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

public struct EmfPlusUnknownRecord {
    public let type: UInt16
    public let flags: UInt16
    public let size: UInt32
    public let dataSize: UInt32
    public let data: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type from the RecordType enumeration.
        self.type = try dataStream.read(endianess: .littleEndian)
        
        /// Flags (2 bytes): An unsigned integer that is not used. This field SHOULD be set to zero and MUST be ignored upon receipt.
        self.flags = try dataStream.read(endianess: .littleEndian)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x0000000C && size % 4 == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of data in the record-specific
        /// data that follows. For this record type, the value MUST be 0x00000008.
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize % 4 == 0 && dataSize == size - 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        let dataStartPosition = dataStream.position
        
        self.data = try dataStream.readBytes(count: Int(dataSize))
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
