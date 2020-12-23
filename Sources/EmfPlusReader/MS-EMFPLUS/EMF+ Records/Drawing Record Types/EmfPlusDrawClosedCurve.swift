//
//  EmfPlusDrawClosedCurve.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.4.4 EmfPlusDrawClosedCurve Record
/// The EmfPlusDrawClosedCurve record specifies drawing a closed cardinal spline.
/// See section 2.3.4 for the specification of additional drawing record types.
public struct EmfPlusDrawClosedCurve {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let tension: Float
    public let count: UInt32
    public let pointData: PointsData
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusDrawClosedCurve from the RecordType
        /// enumeration.
        /// The value MUST be 0x4017.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .drawClosedCurve else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        let flags = try Flags(dataStream: &dataStream)
        self.flags = flags
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record.
        /// At least 3 points MUST be specified.
        /// Value Meaning
        /// 0x0000001C ≤ value If the P bit is set in the Flags field, the minimum Size is computed as follows:
        /// Size = ((((Count * 0x00000002) + 0x00000014 + 0x00000003) / 4) * 4)
        /// 0x00000020 ≤ value If the P bit is clear and the C bit is set in the Flags field, Size is computed as follows:
        /// Size = (Count * 0x00000004) + 0x00000014
        /// 0x0000002C ≤ value If the P bit is clear and the C bit is clear in the Flags field, Size is computed as follows:
        /// Size = (Count * 0x00000008) + 0x00000014
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000014 && size % 4 == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record.
        /// At least 3 points MUST be specified.
        /// Value Meaning
        /// 0x00000010 ≤ value If the P bit is set in the Flags field, the minimum DataSize is computed as follows:
        /// DataSize = ((((Count * 0x00000002) + 0x0000008 + 0x00000003) / 4) * 4)
        /// 0x00000014 ≤ value If the P bit is clear and the C bit is set in the Flags field, DataSize is computed as follows:
        /// DataSize = (Count * 0x00000004) + 0x00000008
        /// 0x00000020 ≤ value If the P bit is clear and the C bit is clear in the Flags field, DataSize is computed as follows:
        /// DataSize = (Count * 0x00000008) + 0x00000008
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize >= 0x0000008 && dataSize % 4 == 0 && dataSize == size - 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        let dataStartPosition = dataStream.position
        
        /// Tension (4 bytes): A floating point number that specifies how tightly the spline bends as it passes through the points.
        /// A value of 0 specifies that the spline is a sequence of straight lines. As the value increases, the curve becomes more
        /// rounded. For more information, see [SPLINE77] and [PETZOLD].
        self.tension = try dataStream.readFloat(endianess: .littleEndian)
        
        /// Count (4 bytes): An unsigned integer that specifies the number of points in the PointData field.
        /// At least 3 points MUST be specified.
        let count: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard count >= 3 &&
                count * (flags.relative ? 0x00000002 : flags.compressed ? 0x00000004 : 0x00000008) + 0x00000014 == size &&
                count * (flags.relative ? 0x00000002 : flags.compressed ? 0x00000004 : 0x00000008) + 0x00000008 == dataSize else {
            throw EmfPlusReadError.corrupted
        }
        
        self.count = count

        /// PointData (variable): An array of Count points that specify the endpoints of the lines that define the spline.
        /// In a closed cardinal spline, the curve continues through the last point in the PointData array and connects with the first
        /// point in the array.
        /// The type of data in this array is specified by the Flags field, as follows:
        /// Data Type Meaning
        /// EmfPlusPointR object If the P bit is set in the Flags field, the points specify relative locations.
        /// EmfPlusPoint object If the P bit is clear and the C bit is set in the Flags field, the points specify absolute locations with
        /// 16-bit coordinates.
        /// EmfPlusPointF object If the P and C bits are clear in the Flags field, the points specify absolute locations with 32-bit
        /// coordinates.
        self.pointData = try PointsData(dataStream: &dataStream, count: count, relative: self.flags.relative, compressed: self.flags.compressed)
        
        /// AlignmentPadding (variable): An optional array of up to 3 bytes that pads the record so that its total size is a multiple of
        /// 4 bytes. This field MUST be ignored.
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
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
        public let reserved2: UInt8
        public let compressed: Bool
        public let reserved3: Bool
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// ObjectID (1 byte): The index of an EmfPlusPen object in the EMF+ Object Table to draw the closed curve.
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
            /// Note: If this flag is set, the C flag (above) is undefined and MUST be ignored.<20>
            self.relative = flags.readBit()
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved2 = UInt8(flags.readBits(count: 2))

            /// C (1 bit): This bit indicates whether the PointData field specifies compressed data.
            /// If set, PointData specifies locations in the coordinate space with 16-bit integer coordinates. If clear, PointData specifies
            /// locations in the coordinate space with 32-bit floating-point coordinates.
            /// Note: If the P flag (below) is set, this flag is undefined and MUST be ignored.
            self.compressed = flags.readBit()
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved3 = flags.readBit()
        }
    }
}
