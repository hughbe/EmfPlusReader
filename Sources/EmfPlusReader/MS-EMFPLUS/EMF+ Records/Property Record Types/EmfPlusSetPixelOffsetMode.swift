//
//  EmfPlusSetPixelOffsetMode.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.6.5 EmfPlusSetPixelOffsetMode Record
/// The EmfPlusSetPixelOffsetMode record specifies how pixels are centered with respect to the coordinates of the drawing surface.
/// See section 2.3.6 for the specification of additional property record types.
public struct EmfPlusSetPixelOffsetMode {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusSetPixelOffsetMode from the RecordType
        /// enumeration.
        /// The value MUST be 0x4022.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .setPixelOffsetMode else {
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
        public let pixelOffsetMode: PixelOffsetMode
        public let reserved: UInt8
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// PixelOffsetMode (1 byte): The pixel offset mode value, from the PixelOffsetMode enumeration.
            guard let pixelOffsetMode = PixelOffsetMode(rawValue: UInt8(flags.readBits(count: 8))) else {
                throw EmfPlusReadError.corrupted
            }
            
            self.pixelOffsetMode = pixelOffsetMode
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved = UInt8(flags.readBits(count: 8))
        }
    }
}
