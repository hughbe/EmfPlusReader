//
//  EmfPlusDrawPie.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.4.12 EmfPlusDrawPie Record
/// The EmfPlusDrawPie record specifies drawing a section of the interior of an ellipse.
/// See section 2.3.4 for the specification of additional drawing record types.
public struct EmfPlusDrawPie {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let startAngle: Float
    public let sweepAngle: Float
    public let rectData: RectData
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusDrawPie from the RecordType
        /// enumeration.
        /// The value MUST be 0x4011.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .drawPie else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        self.flags = try Flags(dataStream: &dataStream)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data. For this record type, the value MUST be one of the following:
        /// Value Meaning
        /// 0x0000001C If the C bit is set in the Flags field.
        /// 0x00000024 If the C bit is clear in the Flags field.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == (self.flags.compressed ? 0x0000001C : 0x00000024) else {
            throw EmfPlusReadError.corrupted
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of data in the record-specific
        /// data that follows. For this record type, the value MUST be one of the following:
        /// Value Meaning
        /// 0x00000010 If the C bit is set in the Flags field.
        /// 0x00000018 If the C bit is clear in the Flags field.
        self.dataSize = try dataStream.read(endianess: .littleEndian)
        guard self.dataSize == (self.flags.compressed ? 0x00000010 : 0x00000018) else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataStartPosition = dataStream.position
        
        /// StartAngle (4 bytes): A non-negative floating-point value that specifies the angle between the xaxis and the starting point
        /// of the pie wedge. Any value is acceptable, but it MUST be interpreted modulo 360, with the result that is used being in
        /// the range 0.0 inclusive to 360.0 exclusive.
        self.startAngle = try dataStream.readFloat(endianess: .littleEndian)
        
        /// SweepAngle (4 bytes): A floating-point value that specifies the extent of the arc that defines the pie wedge to draw, as an
        /// angle in degrees measured from the starting point defined by the StartAngle value. Any value is acceptable, but it MUST
        /// be clamped to -360.0 to 360.0 inclusive. A positive value indicates that the sweep is defined in a clockwise direction, and
        /// a negative value indicates that the sweep is defined in a counter-clockwise direction.
        self.sweepAngle = try dataStream.readFloat(endianess: .littleEndian)
        
        /// RectData (variable): Either an EmfPlusRect or EmfPlusRectF object that defines the bounding box of the ellipse that
        /// contains the pie wedge. This rectangle defines the position, size, and shape of the pie. The type of object in this field
        /// is specified by the value of the Flags field.
        if self.flags.compressed {
            self.rectData = .compressed(try EmfPlusRect(dataStream: &dataStream))
        } else {
            self.rectData = .uncompressed(try EmfPlusRectF(dataStream: &dataStream))
        }
        
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
            
            /// ObjectID (1 byte): The index of an EmfPlusPen object in the EMF+ Object Table to draw the pie.
            /// The value MUST be zero to 63, inclusive.
            let objectID = UInt8(flags.readBits(count: 8))
            guard objectID >= 0 && objectID <= 63 else {
                throw EmfPlusReadError.corrupted
            }
            
            self.objectID = objectID
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved1 = UInt8(flags.readBits(count: 6))
            
            /// C (1 bit): This bit indicates whether the data in the RectData field is compressed.
            /// If set, RectData contains an EmfPlusRect object. If clear, RectData contains an EmfPlusRectF object.
            self.compressed = flags.readBit()
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved2 = flags.readBit()
        }
    }
}
