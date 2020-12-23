//
//  EmfPlusSetCompositingQuality.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.6.3 EmfPlusSetCompositingQuality Record
/// The EmfPlusSetCompositingQuality record specifies the desired level of quality for creating composite images from multiple objects.
/// See section 2.3.6 for the specification of additional property record types.
public struct EmfPlusSetCompositingQuality {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusSetCompositingQuality from the RecordType
        /// enumeration.
        /// The value MUST be 0x4024.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .setCompositingQuality else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        self.flags = try Flags(dataStream: &dataStream)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data. For this record type, the value MUST be 0x0000000C.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of data in the record-specific
        /// data that follows. For this record type, the value MUST be 0x00000000.
        self.dataSize = try dataStream.read(endianess: .littleEndian)
        guard self.dataSize == 0x00000000 else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataStartPosition = dataStream.position
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
    /// structure of the record.
    public struct Flags {
        public let reserved: UInt8
        public let compositingQuality: CompositingQuality
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// CompositingQuality (1 byte): The compositing quality value, from the CompositingQuality enumeration.
            let compositingQualityRaw = UInt8(flags.readBits(count: 8))
            if let compositingQuality = CompositingQuality(rawValue: compositingQualityRaw) {
                self.compositingQuality = compositingQuality
            } else {
                self.compositingQuality = .default
            }
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved = UInt8(flags.readBits(count: 8))
        }
    }
}
