//
//  EmfPlusSetTextRenderingHint.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.6.8 EmfPlusSetTextRenderingHint Record
/// The EmfPlusSetTextRenderingHint record specifies the quality of text rendering, including the type of anti-aliasing.
/// See section 2.3.6 for the specification of additional property record types.
public struct EmfPlusSetTextRenderingHint {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusSetTextRenderingHint from the RecordType
        /// enumeration.
        /// The value MUST be 0x401F.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .setTextRenderingHint else {
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
        public let textRenderingHint: TextRenderingHint
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// TextRenderingHint (1 byte): The text rendering hint value, from the TextRenderingHint enumeration, which specifies
            /// the quality to use in subsequent text rendering.
            guard let textRenderingHint = TextRenderingHint(rawValue: UInt8(flags.readBits(count: 8))) else {
                throw EmfPlusReadError.corrupted
            }
            
            self.textRenderingHint = textRenderingHint
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved = UInt8(flags.readBits(count: 8))
        }
    }
}
