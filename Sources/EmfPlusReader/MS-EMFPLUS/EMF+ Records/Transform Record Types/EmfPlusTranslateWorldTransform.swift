//
//  EmfPlusTranslateWorldTransform.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.9.7 EmfPlusTranslateWorldTransform Record
/// The EmfPlusTranslateWorldTransform record performs a translation on the current world space transform.
/// See section 2.3.9 for the specification of additional transform record types.
public struct EmfPlusTranslateWorldTransform {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let dx: Float
    public let dy: Float
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusTranslateWorldTransform from the RecordType
        /// enumeration.
        /// The value MUST be 0x402D.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .translateWorldTransform else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        self.flags = try Flags(dataStream: &dataStream)
        
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
        
        /// dx (4 bytes): A floating-point value that defines the horizontal distance. The translation is performed by constructing a
        /// new world transform matrix from the dx and dy fields.
        self.dx = try dataStream.readFloat(endianess: .littleEndian)
        
        /// dy (4 bytes): A floating-point value that defines the vertical distance value.
        self.dy = try dataStream.readFloat(endianess: .littleEndian)
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
    /// structure of the record.
    public struct Flags {
        public let reserved1: UInt16
        public let postMultiplied: Bool
        public let reserved2: UInt8
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved1 = flags.readBits(count: 13)
            
            /// A (1 bit): If set, the transform matrix is post-multiplied. If clear, it is pre-multiplied.
            self.postMultiplied = flags.readBit()
            
            self.reserved2 = UInt8(flags.readRemainingBits())
        }
    }
}
