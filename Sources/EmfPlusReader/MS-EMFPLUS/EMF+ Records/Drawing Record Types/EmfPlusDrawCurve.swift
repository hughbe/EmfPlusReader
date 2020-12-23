//
//  EmfPlusDrawCurve.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.4.5 EmfPlusDrawCurve Record
/// The EmfPlusDrawCurve record specifies drawing a cardinal spline.
/// See section 2.3.4 for the specification of additional drawing record types.
public struct EmfPlusDrawCurve {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let tension: Float
    public let offset: UInt32
    public let numSegments: UInt32
    public let count: UInt32
    public let pointData: PointsData
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusDrawCurve from the RecordType
        /// enumeration.
        /// The value MUST be 0x4018.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .drawCurve else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        let flags = try Flags(dataStream: &dataStream)
        self.flags = flags
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data.
        /// At least 2 PointData elements MUST be specified in this record.
        /// Value Meaning
        /// 0x00000024 ≤ value If the C bit is set in the Flags field, Count points with values of 16-bit signed integers are defined in
        /// the PointData field. In this case, Size MUST be computed as follows:
        /// Size = (Count * 0x00000004) + 0x0000001C
        /// 0x0000002C ≤ value If the C bit is clear in the Flags field, Count points with values of 32-bit floating-point numbers are
        /// defined in the PointData field. In this case, Size MUST be computed as follows:
        /// Size = (Count * 0x00000008) + 0x0000001C
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x0000001C && size % 4 == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of record-specific data that follows.
        /// At least 2 PointData elements MUST be specified in this record.
        /// Value Meaning
        /// 0x00000018 ≤ value If the C bit is set in the Flags field, Count points with values of 16-bit signed integers are defined in
        /// the PointData field. In this case, DataSize MUST be computed as follows:
        /// DataSize = (Count * 0x00000004) + 0x00000010
        /// 0x00000020 ≤ value If the C bit is clear in the Flags field, Count points with values of 32-bit floating-point numbers are
        /// defined in the PointData field. In this case, DataSize MUST be computed as follows:
        /// DataSize = (Count * 0x00000008) + 0x00000010
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize >= 0x00000010 && dataSize % 4 == 0 && dataSize == size - 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        let dataStartPosition = dataStream.position
        
        /// Tension (4 bytes): A floating-point value that specifies how tightly the spline bends as it passes through the points.
        /// A value of 0 specifies that the spline is a sequence of straight lines. As the value increases, the curve becomes more
        /// rounded. For more information, see [SPLINE77] and [PETZOLD].
        self.tension = try dataStream.readFloat(endianess: .littleEndian)
        
        /// Offset (4 bytes): An unsigned integer that specifies the element in the PointData array that defines the starting point of
        /// the spline.
        self.offset = try dataStream.read(endianess: .littleEndian)
        
        /// NumSegments (4 bytes): An unsigned integer that specifies the number of line segments making up the spline.
        self.numSegments = try dataStream.read(endianess: .littleEndian)
        
        /// Count (4 bytes): An unsigned integer that specifies the number of points in the PointData array.
        /// The minimum number of points for drawing a curve is 2—the starting and ending points.
        let count: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard count >= 2 &&
                count * (flags.compressed ? 0x00000004 : 0x00000008) + 0x0000001C == size &&
                count * (flags.compressed ? 0x00000004 : 0x00000008) + 0x00000010 == dataSize else {
            throw EmfPlusReadError.corrupted
        }
        
        self.count = count

        /// PointData (variable): An array of either 32-bit signed integers or 32-bit floating-point numbers of
        /// Count length that defines coordinate values of the endpoints of the lines to be stroked.
        self.pointData = try PointsData(dataStream: &dataStream, count: count, relative: false, compressed: self.flags.compressed)

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
            
            /// ObjectID (1 byte): The index of an EmfPlusPen object in the EMF+ Object Table to draw the curve.
            /// The value MUST be zero to 63, inclusive.
            let objectID = UInt8(flags.readBits(count: 8))
            guard objectID >= 0 && objectID <= 63 else {
                throw EmfPlusReadError.corrupted
            }
            
            self.objectID = objectID
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved1 = UInt8(flags.readBits(count: 6))
            
            /// C (1 bit): This bit indicates whether the data in the PointData field is compressed.
            /// If set, PointData contains an array of EmfPlusPoint objects. If clear, PointData contains an array of EmfPlusPointF
            /// objects.
            self.compressed = flags.readBit()
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved2 = flags.readBit()
        }
    }
}
