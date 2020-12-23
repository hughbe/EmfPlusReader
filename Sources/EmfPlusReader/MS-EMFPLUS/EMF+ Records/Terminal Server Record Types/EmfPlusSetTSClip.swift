//
//  EmfPlusSetTSClip.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.8.1 EmfPlusSetTSClip Record
/// The EmfPlusSetTSClip record specifies clipping areas in the graphics device context for a terminal server.<30>
/// The compression scheme for data in this record uses the following algorithm. Each point of each rectangle is encoded in either a
/// single byte or 2 bytes. If the point is encoded in a single byte, the high bit (0x80) of the byte MUST be set, and the value is a signed
/// number represented by the lower 7 bits. If the high bit is not set, then the value is encoded in 2 bytes, with the high-order byte encoded
/// in the 7 lower bits of the first byte, and the low-order byte value encoded in the second byte.
/// Each point is encoded as the difference between the point in the current rectangle and the point in the previous rectangle. The bottom
/// point of the rectangle is encoded as the difference between the bottom coordinate and the top coordinate on the current rectangle.
/// See section 2.3.8 for the specification of additional terminal server record types.
public struct EmfPlusSetTSClip {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let rectData: RectsData
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusSetTSClip from the RecordType
        /// enumeration.
        /// The value MUST be 0x403A.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .setTSClip else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        let flags = try Flags(dataStream: &dataStream)
        self.flags = flags
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data. The computation of this value is determined by the C bit in the Flags field,
        /// as shown in the following table.
        /// C bit value Meaning
        /// 0 NumRects rectangles, consisting of 8 bytes each, are defined in the Rects field, and Size is computed as follows:
        /// Size = (NumRects * 0x00000008) + 0x0000000C
        /// 1 NumRects rectangles, consisting of 4 bytes each, are defined in the Rects field, and Size is computed as follows:
        /// Size = (NumRects * 0x00000004) + 0x0000000C
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.flags.numRects * (self.flags.compressed ? 0x00000004 : 0x00000008) + 0x0000000C == self.size else {
            throw EmfPlusReadError.corrupted
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of record-specific data that follows.
        /// The computation of this value is determined by the C bit in the Flags field, as shown in the following table.
        /// C bit value Meaning
        /// 0 NumRects rectangles, consisting of 8 bytes each, are defined in the Rects field, and DataSize is computed as follows:
        /// DataSize = NumRects * 0x00000008
        /// 1 NumRects rectangles, consisting of 4 bytes each, are defined in the Rects field, and DataSize is computed as follows:
        /// DataSize = NumRects * 0x00000004
        self.dataSize = try dataStream.read(endianess: .littleEndian)
        guard self.flags.numRects * (self.flags.compressed ? 0x00000004 : 0x00000008) == self.dataSize else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataStartPosition = dataStream.position
        
        /// Rects (variable): An array of NumRects rectangles that define clipping areas. The format of this data is determined by
        /// the C bit in the Flags field.
        self.rectData = try RectsData(dataStream: &dataStream, count: self.flags.numRects, compressed: self.flags.compressed)

        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
    /// structure of the record.
    public struct Flags {
        public let numRects: UInt16
        public let compressed: Bool
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// NumRects (15 bits): The number of rectangles that are defined in the Rect field.
            self.numRects = flags.readBits(count: 15)
            
            /// C (1 bit): The format of the rectangle data in the Rects field. If set, each rectangle is defined in 4 bytes.
            /// If clear, each rectangle is defined in 8 bytes.
            self.compressed = flags.readBit()
        }
    }
    
    /// Rects (variable): An array of NumRects rectangles that define clipping areas. The format of this data is determined by
    /// the C bit in the Flags field.
    public enum RectsData {
        case compressed(_: [CompressedRect])
        case uncompressed(_: [UncompressedRect])
        
        public init(dataStream: inout DataStream, count: UInt16, compressed: Bool) throws {
            if compressed {
                var values: [CompressedRect] = []
                values.reserveCapacity(Int(count))
                for _ in 0..<count {
                    values.append(try CompressedRect(dataStream: &dataStream))
                }
                
                self = .compressed(values)
            } else {
                var values: [UncompressedRect] = []
                values.reserveCapacity(Int(count))
                for _ in 0..<count {
                    values.append(try UncompressedRect(dataStream: &dataStream))
                }
                
                self = .uncompressed(values)
            }
        }
    }
    
    public struct CompressedRect {
        public let x1: UInt8
        public let y1: UInt8
        public let x2: UInt8
        public let y2: UInt8
        
        public init(dataStream: inout DataStream) throws {
            self.x1 = try dataStream.read()
            self.y1 = try dataStream.read()
            self.x2 = try dataStream.read()
            self.y2 = try dataStream.read()
        }
    }
    
    public struct UncompressedRect {
        public let x1: UInt16
        public let y1: UInt16
        public let x2: UInt16
        public let y2: UInt16
        
        public init(dataStream: inout DataStream) throws {
            self.x1 = try dataStream.read(endianess: .littleEndian)
            self.y1 = try dataStream.read(endianess: .littleEndian)
            self.x2 = try dataStream.read(endianess: .littleEndian)
            self.y2 = try dataStream.read(endianess: .littleEndian)
        }
    }
}
