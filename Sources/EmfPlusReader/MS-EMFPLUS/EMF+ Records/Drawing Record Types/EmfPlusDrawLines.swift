//
//  EmfPlusDrawLines.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.4.10 EmfPlusDrawLines Record
/// The EmfPlusDrawlLines record specifies drawing a series of connected lines.
/// See section 2.3.4 for the specification of additional drawing record types.
public struct EmfPlusDrawLines {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let count: UInt32
    public let pointData: PointsData
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusDrawLines from the RecordType
        /// enumeration.
        /// The value MUST be 0x400D.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .drawLines else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        let flags = try Flags(dataStream: &dataStream)
        self.flags = flags
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data.
        /// Value Meaning
        /// 0x00000014 ≤ value If the P bit is set in the Flags field, the minimum Size is computed as follows:
        /// Size = (Count * 0x00000002) + 0x00000010
        /// 0x00000018 ≤ value If the P bit is clear and the C bit is set in the Flags field, Size is computed as follows:
        /// Size = (Count * 0x00000004) + 0x00000010
        /// 0x00000020 ≤ value If the P bit is clear and the C bit is clear in the Flags field, Size is computed as follows:
        /// Size = (Count * 0x00000008) + 0x00000010
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000010 && size % 4 == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of record-specific data that follows.
        /// Value Meaning
        /// 0x00000008 ≤ value If the P bit is set in the Flags field, the minimum DataSize is computed as follows:
        /// DataSize = (Count * 0x00000002) + 0x00000004
        /// 0x0000000C ≤ value If the P bit is clear and the C bit is set in the Flags field, DataSize is computed as follows:
        /// DataSize = (Count * 0x00000004) + 0x00000004
        /// 0x00000014 ≤ value If the P bit is clear and the C bit is clear in the Flags field, DataSize is computed as follows:
        /// DataSize = (Count * 0x00000008) + 0x00000004
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize >= 0x00000004 && dataSize % 4 == 0 && dataSize == size - 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        let dataStartPosition = dataStream.position
        
        /// Count (4 bytes): An unsigned integer that specifies the number of points in the PointData array.
        /// At least 2 points MUST be specified.
        let count: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard count >= 2 &&
                count * (flags.relative ? 0x00000002 : flags.compressed ? 0x00000004 : 0x00000008) + 0x00000010 == size &&
                count * (flags.relative ? 0x00000002 : flags.compressed ? 0x00000004 : 0x00000008) + 0x00000004 == dataSize else {
            throw EmfPlusReadError.corrupted
        }

        self.count = count
        
        /// PointData (variable): An array of Count points that specify the starting and ending points of the lines to be drawn.
        /// The type of data in this array is specified by the Flags field, as follows.
        /// Data Type Meaning
        /// EmfPlusPointR object If the P flag is set in the Flags, the points specify relative locations.
        /// EmfPlusPoint object If the P bit is clear and the C bit is set in the Flags field, the points specify absolute locations with
        /// integer values.
        /// EmfPlusPointF object If the P bit is clear and the C bit is clear in the Flags field, the points specify absolute locations
        /// with floating-point values.
        self.pointData = try PointsData(dataStream: &dataStream, count: count, relative: self.flags.relative, compressed: self.flags.compressed)
        
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
        public let relative: Bool
        public let drawExtraLineBetweenLastAndFirst: Bool
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
            self.reserved1 = UInt8(flags.readBits(count: 3))
            
            /// P (1 bit): This bit indicates whether the PointData field specifies relative or absolute locations.
            /// If set, each element in PointData specifies a location in the coordinate space that is relative to the location specified
            /// by the previous element in the array. In the case of the first element in PointData, a previous location at coordinates
            /// (0,0) is assumed. If clear, PointData specifies absolute locations according to the C flag.
            /// Note: If this flag is set, the C flag (above) is undefined and MUST be ignored.<22>
            self.relative = flags.readBit()
            
            /// L (1 bit): This bit indicates whether to draw an extra line between the last point and the first point, to close the shape.
            self.drawExtraLineBetweenLastAndFirst = flags.readBit()
            
            /// C (1 bit): This bit indicates whether the PointData field specifies compressed data.
            /// If set, PointData specifies absolute locations in the coordinate space with 16-bit integer coordinates. If clear, PointData
            /// specifies absolute locations in the coordinate space with 32-bit floating-point coordinates.
            self.compressed = flags.readBit()
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved2 = flags.readBit()
        }
    }
}
