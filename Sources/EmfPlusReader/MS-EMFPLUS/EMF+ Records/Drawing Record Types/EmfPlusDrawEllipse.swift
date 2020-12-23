//
//  EmfPlusDrawEllipse.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.4.7 EmfPlusDrawEllipse Record
/// The EmfPlusDrawEllipse record specifies drawing an ellipse.
/// See section 2.3.4 for the specification of additional drawing record types.
public struct EmfPlusDrawEllipse {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let rectData: RectData
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusDrawEllipse from the RecordType
        /// enumeration.
        /// The value MUST be 0x400F.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .drawEllipse else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        self.flags = try Flags(dataStream: &dataStream)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data. For this record type, the value MUST be one of the following:
        /// Value Meaning
        /// 0x00000014 If the C bit is set in the Flags field.
        /// 0x0000001C If the C bit is clear in the Flags field.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == (self.flags.compressed ? 0x00000014 : 0x0000001C) else {
            throw EmfPlusReadError.corrupted
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of data in the record-specific
        /// data that follows. For this record type, the value MUST be one of the following:
        /// Value Meaning
        /// 0x00000008 If the C bit is set in the Flags field.
        /// 0x00000010 If the C bit is clear in the Flags field.
        self.dataSize = try dataStream.read(endianess: .littleEndian)
        guard self.dataSize == (self.flags.compressed ? 0x00000008 : 0x00000010) else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataStartPosition = dataStream.position
        
        /// RectData (variable): Either an EmfPlusRect or EmfPlusRectF object that defines the bounding box of the ellipse.
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
            
            /// ObjectID (1 byte): The index of an EmfPlusPen object in the EMF+ Object Table to draw the ellipse.
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
