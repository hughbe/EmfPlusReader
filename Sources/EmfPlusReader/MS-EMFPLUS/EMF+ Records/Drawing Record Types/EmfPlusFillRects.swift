//
//  EmfPlusFillRects.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.4.20 EmfPlusFillRects Record
/// The EmfPlusFillRects record specifies filling the interiors of a series of rectangles.
/// See section 2.3.4 for the specification of additional drawing record types.
public struct EmfPlusFillRects {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let brushId: BrushId
    public let count: UInt32
    public let rectData: RectsData
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusFillRects from the RecordType
        /// enumeration.
        /// The value MUST be 0x401E.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .fillRects else {
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
        /// 0x0000001C ≤ value If the C bit is set in the Flags field, Size MUST be computed as follows:
        /// Size = (Count * 0x00000008) + 0x00000014
        /// 0x00000024 ≤ value If the C bit is clear in the Flags field, Size MUST be computed as follows:
        /// Size = (Count * 0x00000010) + 0x00000014
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000014 && size % 4 == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of record-specific data that follows.
        /// At least 1 RectData array element MUST be specified in this record.
        /// Value Meaning
        /// 0x00000010 ≤ value If the C bit is set in the Flags field, DataSize MUST be computed as follows:
        /// DataSize = (Count * 0x00000008) + 0x00000008
        /// 0x00000018 ≤ value If the C bit is clear in the Flags field, DataSize MUST be computed as follows:
        /// DataSize = (Count * 0x00000010) + 0x00000008
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize >= 0x00000008 && dataSize % 4 == 0 && dataSize == size - 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        let dataStartPosition = dataStream.position
        
        /// BrushId (4 bytes): An unsigned integer that defines the brush, the content of which is determined by the S bit in the
        /// Flags field.
        self.brushId = try BrushId(dataStream: &dataStream, brushIdIsColor: self.flags.brushIdIsColor)
        
        /// Count (4 bytes): An unsigned integer that specifies the number of rectangles in the RectData field.
        let count: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard count >= 1 &&
                count * (flags.compressed ? 0x00000008 : 0x00000010) + 0x00000014 == size &&
                count * (flags.compressed ? 0x00000008 : 0x00000010) + 0x00000008 == dataSize else {
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
        public let reserved: UInt16
        public let compressed: Bool
        public let brushIdIsColor: Bool
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved = flags.readBits(count: 14)
            
            /// C (1 bit): This bit indicates whether the data in the RectData field is compressed.
            /// If set, RectData contains an EmfPlusRect object. If clear, RectData contains an EmfPlusRectF object.
            self.compressed = flags.readBit()
            
            /// S (1 bit): This bit specifies the type of data in the BrushId field.
            /// If set, BrushId specifies a color as an EmfPlusARGB object. If clear, BrushId contains the index of an EmfPlusBrush
            /// object in the EMF+ Object Table.
            self.brushIdIsColor = flags.readBit()
        }
    }
}
