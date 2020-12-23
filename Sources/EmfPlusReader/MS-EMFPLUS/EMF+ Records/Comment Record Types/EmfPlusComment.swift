//
//  EmfPlusComment.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.2.1 EmfPlusComment Record
/// The EmfPlusComment record specifies arbitrary private data.
public struct EmfPlusComment {
    public let type: RecordType
    public let flags: UInt16
    public let size: UInt32
    public let dataSize: UInt32
    public let privateData: [UInt8]
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusComment from the RecordType enumeration.
        /// The value MUST be 0x4003.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .comment else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that is not used. This field SHOULD be set to zero and MUST be ignored upon receipt.<18>
        self.flags = try dataStream.read(endianess: .littleEndian)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit–aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data. For this record type, it MUST be computed as follows:
        /// Size = DataSize + 0x0000000C
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x0000000C && size % 4 == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit–aligned number of bytes of record-specific data that follows.
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize <= Int.max && dataSize % 4 == 0 && dataSize == size - 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        let dataStartPosition = dataStream.position
        
        /// PrivateData (variable): A DataSize-length byte array of private data.
        self.privateData = try dataStream.readBytes(count: Int(self.dataSize))
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
