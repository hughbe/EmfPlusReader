//
//  EmfPlusDrawImagePoints.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.4.9 EmfPlusDrawImagePoints Record
/// The EmfPlusDrawImagePoints record specifies drawing a scaled image inside a parallelogram.
/// An EmfPlusImage can specify either a bitmap or metafile.
/// Colors in an image can be manipulated during rendering. They can be corrected, darkened, lightened, and removed.
/// See section 2.3.4 for the specification of additional drawing record types.
public struct EmfPlusDrawImagePoints {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let imageAttributesID: UInt32
    public let srcUnit: UnitType
    public let srcRect: EmfPlusRectF
    public let count: UInt32
    public let pointData: PointsData
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusDrawImagePoints from the RecordType
        /// enumeration.
        /// The value MUST be 0x401B.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .drawImagePoints else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        let flags = try Flags(dataStream: &dataStream)
        self.flags = flags
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record. For this record
        /// type, the value MUST be one of the following.
        /// Value Meaning
        /// 0x00000030 If the P bit is set in the Flags field.
        /// 0x00000034 If the P bit is clear and the C bit is set in the Flags field.
        /// 0x00000040 If the P bit is clear and the C bit is clear in the Flags field.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size == (flags.relative ? 0x00000030 : (flags.compressed ? 0x00000034 : 0x00000040)) else {
            throw EmfPlusReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of record-specific data that follows.
        /// For this record type, the value MUST be one of the following.
        /// Value Meaning
        /// 0x00000024 If the P bit is set in the Flags field.
        /// 0x00000028 If the P bit is clear and the C bit is set in the Flags field.
        /// 0x00000034 If the P bit is clear and the C bit is clear in the Flags field.
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize == (flags.relative ? 0x00000024 : (flags.compressed ? 0x00000028 : 0x00000034)) else {
            throw EmfPlusReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        let dataStartPosition = dataStream.position
        
        /// ImageAttributesID (4 bytes): An unsigned integer that contains the index of the optional EmfPlusImageAttributes object in
        /// the EMF+ Object Table.
        self.imageAttributesID = try dataStream.read(endianess: .littleEndian)
        
        /// SrcUnit (4 bytes): A signed integer that defines the units of the SrcRect field. It MUST be the UnitPixel value of the
        /// UnitType enumeration.
        let srcUnitRaw: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard let srcUnit = UnitType(rawValue: UInt8(srcUnitRaw)) else {
            throw EmfPlusReadError.corrupted
        }
        
        self.srcUnit = srcUnit
        
        /// SrcRect (16 bytes): An EmfPlusRectF object that defines a portion of the image to be rendered.
        self.srcRect = try EmfPlusRectF(dataStream: &dataStream)
        
        /// Count (4 bytes): An unsigned integer that specifies the number of points in the PointData array.
        /// Exactly 3 points MUST be specified.
        self.count = try dataStream.read(endianess: .littleEndian)
        guard self.count == 3 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// PointData (variable): An array of Count points that specify three points of a parallelogram. The three points represent the
        /// upper-left, upper-right, and lower-left corners of the parallelogram. The fourth point of the parallelogram is extrapolated from the
        /// first three. The portion of the image specified by the SrcRect field SHOULD have scaling and shearing transforms applied if
        /// necessary to fit inside the parallelogram.
        /// The type of data in this array is specified by the Flags field, as follows.
        /// Data Type Meaning
        /// EmfPlusPointR object If the P flag is set in the Flags, the points specify relative locations.
        /// EmfPlusPoint object If the P bit is clear and the C bit is set in the Flags field, the points specify absolute locations with
        /// integer values.
        /// EmfPlusPointF object If the P bit is clear and the C bit is clear in the Flags field, the points specify absolute locations with
        /// floating-point values.
        self.pointData = try PointsData(dataStream: &dataStream, count: self.count, relative: self.flags.relative, compressed: self.flags.compressed)
        
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
        public let reserved2: Bool
        public let applyEffect: Bool
        public let compressed: Bool
        public let reserved3: Bool
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// ObjectID (1 byte): The index of an EmfPlusImage object in the EMF+ Object Table, which specifies the image to render.
            /// The value MUST be zero to 63, inclusive.
            let objectID = UInt8(flags.readBits(count: 8))
            guard objectID >= 0 && objectID <= 63 else {
                throw EmfPlusReadError.corrupted
            }
            
            self.objectID = objectID
            
            self.reserved1 = UInt8(flags.readBits(count: 3))
            
            /// P (1 bit): This bit indicates whether the PointData field specifies relative or absolute locations.
            /// If set, each element in PointData specifies a location in the coordinate space that is relative to the location specified
            /// by the previous element in the array. In the case of the first element in PointData, a previous location at coordinates
            /// (0,0) is assumed. If clear, PointData specifies absolute locations according to the C flag.
            /// Note: If this flag is set, the C flag (above) is undefined and MUST be ignored.<21>
            self.relative = flags.readBit()
            
            self.reserved2 = flags.readBit()
            
            /// E (1 bit): This bit indicates that the rendering of the image includes applying an effect.
            /// If set, an object of the Effect class MUST have been specified in an earlier EmfPlusSerializableObject record.
            self.applyEffect = flags.readBit()
            
            /// C (1 bit): This bit indicates whether the PointData field specifies compressed data.
            /// If set, PointData specifies absolute locations in the coordinate space with 16-bit integer coordinates. If clear,
            /// PointData specifies absolute locations in the coordinate space with 32-bit floating-point coordinates.
            /// Note: If the P flag (below) is set, this flag is undefined and MUST be ignored.
            self.compressed = flags.readBit()
            
            self.reserved3 = flags.readBit()
        }
    }
}
