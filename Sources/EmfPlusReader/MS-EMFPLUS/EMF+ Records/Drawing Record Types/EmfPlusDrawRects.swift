//
//  EmfPlusDrawRects.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.4.13 EmfPlusDrawRects Record
/// The EmfPlusDrawRects record specifies drawing a series of rectangles.
/// See section 2.3.4 for the specification of additional drawing record types.
public struct EmfPlusDrawRects {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let count: UInt32
    public let rectData: RectsData
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusDrawRects from the RecordType
        /// enumeration.
        /// The value MUST be 0x400B.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .drawRects else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        let flags = try Flags(dataStream: &dataStream)
        self.flags = flags
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data.
        /// At least 1 RectData array element MUST be specified in this record.
        /// Value Meaning
        /// 0x00000018 ≤ value If the C bit is set in the Flags field, Size MUST be computed as follows:
        /// Size = (Count * 0x00000008) + 0x00000010
        /// 0x00000020 ≤ value If the C bit is clear in the Flags field, Size MUST be computed as follows:
        /// Size = (Count * 0x00000010) + 0x00000010
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000010 && size % 4 == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of record-specific data that follows.
        /// At least 1 RectData array element MUST be specified in this record.
        /// Value Meaning
        /// 0x0000000C ≤ value If the C bit is set in the Flags field, DataSize MUST be computed as follows:
        /// DataSize = (Count * 0x00000008) + 0x00000004
        /// 0x00000014 ≤ value If the C bit is clear in the Flags field, DataSize MUST be computed as follows:
        /// DataSize = (Count * 0x00000010) + 0x00000004
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize >= 0x00000004 && dataSize % 4 == 0 && dataSize == size - 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        let dataStartPosition = dataStream.position
        
        /// Count (4 bytes): An unsigned integer that specifies the number of rectangles in the RectData member.
        let count: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard count >= 1 &&
                count * (flags.compressed ? 0x00000008 : 0x00000010) + 0x00000010 == size &&
                count * (flags.compressed ? 0x00000008 : 0x00000010) + 0x00000004 == dataSize else {
            throw EmfPlusReadError.corrupted
        }

        self.count = count
        
        /// RectData (variable): An array of either an EmfPlusRect or EmfPlusRectF objects of Count length that defines the rectangle
        /// data.
        self.rectData = try RectsData(dataStream: &dataStream, count: count, compressed: flags.compressed)
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
    /// structure of the record.
    public struct Flags {
        public let objectID: UInt8
        public let reserved1: UInt8
        public let compressed: Bool
        public let reserved2: Bool
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// ObjectID (1 byte): The index of an EmfPlusPen object in the EMF+ Object Table to draw the rectangles.
            /// The value MUST be zero to 63, inclusive.
            let objectID = UInt8(flags.readBits(count: 8))
            guard objectID >= 0 && objectID <= 63 else {
                throw EmfPlusReadError.corrupted
            }

            self.objectID = objectID
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved1 = UInt8(flags.readBits(count: 6))
            
            /// C (1 bit): This bit indicates whether the data in the RectData field is compressed.
            self.compressed = flags.readBit()
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved2 = flags.readBit()
        }
    }
}
