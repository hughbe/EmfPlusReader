//
//  EmfPlusFillClosedCurve.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.4.15 EmfPlusFillClosedCurve Record
/// The EmfPlusFillClosedCurve record specifies filling the interior of a closed cardinal spline.
/// An "alternate" fill operation fills areas according to the "even-odd parity" rule. According to this rule, a test point can be determined to
/// be inside or outside a closed curve as follows: Draw a line from the test point to a point that is distant from the curve. If that line
/// crosses the curve an odd number of times, the test point is inside the curve; otherwise, the test point is outside the curve.
/// A "winding" fill operation fills areas according to the "non-zero" rule. According to this rule, a test point can be determined to be
/// inside or outside a closed curve as follows: Draw a line from a test point to a point that is distant from the curve. Count the number
/// of times the curve crosses the test line from left to right, and count the number of times the curve crosses the test line from right to left.
/// If those two numbers are the same, the test point is outside the curve; otherwise, the test point is inside the curve.
/// See section 2.3.4 for the specification of additional drawing record types.
public struct EmfPlusFillClosedCurve {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let brushId: BrushId
    public let tension: Float
    public let count: UInt32
    public let pointData: PointsData
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusFillClosedCurve from the RecordType
        /// enumeration.
        /// The value MUST be 0x4016.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .fillClosedCurve else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        let flags = try Flags(dataStream: &dataStream)
        self.flags = flags
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record.
        /// At least 3 points MUST be specified.
        /// Value Meaning
        /// 0x00000020 ≤ value If the P bit is set in the Flags field, the minimum Size is computed as follows:
        /// Size = ((((Count * 0x00000002) + 0x00000018 + 0x00000003) / 4) * 4)
        /// 0x00000024 ≤ value If the P bit is clear and the C bit is set in the Flags field, Size is computed as follows:
        /// Size = (Count * 0x00000004) + 0x00000018
        /// 0x00000030 ≤ value If the P bit is clear and the C bit is clear in the Flags field, Size is computed as follows:
        /// Size = (Count * 0x00000008) + 0x00000018
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000018 && size % 4 == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record.
        /// At least 3 points MUST be specified.
        /// Value Meaning
        /// 0x00000014 ≤ value If the P bit is set in the Flags field, the minimum DataSize is computed as follows:
        /// DataSize = ((((Count * 0x00000002) + 0x0000000C + 0x00000003) / 4) * 4)
        /// 0x00000018 ≤ value If the P bit is clear and the C bit is set in the Flags field, DataSize is computed as follows:
        /// DataSize = (Count * 0x00000004) + 0x0000000C
        /// 0x00000024 ≤ value If the P bit is clear and the C bit is clear in the Flags field, DataSize is computed as follows:
        /// DataSize = (Count * 0x00000008) + 0x0000000C
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize >= 0x0000000C && dataSize % 4 == 0 && dataSize == size - 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        let dataStartPosition = dataStream.position
        
        /// BrushId (4 bytes): An unsigned integer that specifies the EmfPlusBrush, the content of which is determined by the S bit in
        /// the Flags field. This brush is used to fill the interior of the closed cardinal spline.
        self.brushId = try BrushId(dataStream: &dataStream, brushIdIsColor: self.flags.brushIdIsColor)
        
        /// Tension (4 bytes): A floating point value that specifies how tightly the spline bends as it passes through the points.
        /// A value of 0.0 specifies that the spline is a sequence of straight lines. As the value increases, the curve becomes more
        /// rounded. For more information, see [SPLINE77] and [PETZOLD].
        self.tension = try dataStream.readFloat(endianess: .littleEndian)
        
        /// Count (4 bytes): An unsigned integer that specifies the number of points in the PointData field.
        /// At least 3 points MUST be specified.
        let count: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard count >= 3 &&
                count * (flags.relative ? 0x00000002 : flags.compressed ? 0x00000004 : 0x00000008) + 0x00000018 == size &&
                count * (flags.relative ? 0x00000002 : flags.compressed ? 0x00000004 : 0x00000008) + 0x0000000C == dataSize else {
            throw EmfPlusReadError.corrupted
        }
        
        self.count = count

        /// PointData (variable): An array of Count points that specify the endpoints of the lines that define the spline.
        /// In a closed cardinal spline, the curve continues through the last point in the PointData array and connects with the first
        /// point in the array.
        /// The type of data in this array is specified by the Flags field, as follows:
        /// Data Type Meaning
        /// EmfPlusPointR object If the P flag is set in the Flags, the points specify relative locations.
        /// EmfPlusPoint object If the P bit is clear and the C bit is set in the Flags field, the points specify absolute locations with
        /// integer values.
        /// EmfPlusPointF object If the P bit is clear and the C bit is clear in the Flags field, the points specify absolute locations with
        /// floating-point values.
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
        public let reserved1: UInt16
        public let relative: Bool
        public let reserved2: Bool
        public let compressed: Bool
        public let windingFill: Bool
        public let brushIdIsColor: Bool
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved1 = flags.readBits(count: 11)
            
            /// P (1 bit): This bit indicates whether the PointData field specifies relative or absolute locations.
            /// If set, each element in PointData specifies a location in the coordinate space that is relative to the location specified
            /// by the previous element in the array. In the case of the first element in PointData, a previous location at coordinates
            /// (0,0) is assumed. If clear, PointData specifies absolute locations according to the C flag.
            /// Note: If this flag is set, the C flag (above) is undefined and MUST be ignored.<23>
            self.relative = flags.readBit()
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved2 = flags.readBit()
            
            /// W (1 bit): This bit indicates how to perform the fill operation.
            /// If set, the fill is a "winding" fill. If clear, the fill is an "alternate" fill.
            self.windingFill = flags.readBit()
            
            /// C (1 bit): This bit indicates whether the PointData field specifies compressed data.
            /// If set, PointData specifies absolute locations in the coordinate space with 16-bit integer coordinates. If clear,
            /// PointData specifies absolute locations in the coordinate space with 32-bit floating-point coordinates.
            /// Note: If the P flag (below) is set, this flag is undefined and MUST be ignored.
            self.compressed = flags.readBit()
            
            /// S (1 bit): This bit indicates the type of data in the BrushId field.
            /// If set, BrushId specifies a color as an EmfPlusARGB object. If clear, BrushId contains the index of an EmfPlusBrush
            /// object in the EMF+ Object Table.
            self.brushIdIsColor = flags.readBit()
        }
    }
}
