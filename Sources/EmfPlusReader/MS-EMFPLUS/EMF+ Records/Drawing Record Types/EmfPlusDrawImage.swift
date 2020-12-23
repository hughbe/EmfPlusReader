//
//  EmfPlusDrawImage.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.4.8 EmfPlusDrawImage Record
/// The EmfPlusDrawImage record specifies drawing a scaled image.
/// An EmfPlusImage object can specify either a bitmap or a metafile.
/// Colors in an image can be manipulated during rendering. They can be corrected, darkened, lightened, and removed.
/// See section 2.3.4 for the specification of additional drawing record types.
public struct EmfPlusDrawImage {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let imageAttributesID: UInt32
    public let srcUnit: UnitType
    public let srcRect: EmfPlusRectF
    public let rectData: RectData
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusDrawImage from the RecordType
        /// enumeration.
        /// The value MUST be 0x401A.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .drawImage else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        self.flags = try Flags(dataStream: &dataStream)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data. For this record type, the value MUST be one of the following:
        /// Value Meaning
        /// 0x0000002C If the C bit is set in the Flags field.
        /// 0x00000034 If the C bit is clear in the Flags field.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == (self.flags.compressed ? 0x0000002C : 0x00000034) else {
            throw EmfPlusReadError.corrupted
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of data in the record-specific
        /// data that follows. For this record type, the value MUST be one of the following:
        /// Value Meaning
        /// 0x00000020 If the C bit is set in the Flags field.
        /// 0x00000028 If the C bit is clear in the Flags field.
        self.dataSize = try dataStream.read(endianess: .littleEndian)
        guard self.dataSize == (self.flags.compressed ? 0x00000020 : 0x00000028) else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataStartPosition = dataStream.position
        
        /// ImageAttributesID (4 bytes): An unsigned integer that specifies the index of an optional EmfPlusImageAttributes object in
        /// the EMF+ Object Table.
        let imageAttributesID: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard imageAttributesID >= 0 && imageAttributesID <= 63 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.imageAttributesID = imageAttributesID
        
        /// SrcUnit (4 bytes): A signed integer that specifies the units of the SrcRect field. It MUST be the UnitTypePixel member of
        /// the UnitType enumeration.
        let srcUnitRaw: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard let srcUnit = UnitType(rawValue: UInt8(srcUnitRaw)) else {
            throw EmfPlusReadError.corrupted
        }
        
        self.srcUnit = srcUnit
        
        /// SrcRect (16 bytes): An EmfPlusRectF object that specifies a portion of the image to be rendered.
        /// The portion of the image specified by this rectangle is scaled to fit the destination rectangle specified by the RectData field.
        self.srcRect = try EmfPlusRectF(dataStream: &dataStream)
        
        /// RectData (variable): Either an EmfPlusRect or EmfPlusRectF object that defines the bounding box of the image.
        /// The portion of the image specified by the SrcRect field is scaled to fit this rectangle.
        self.rectData = try RectData(dataStream: &dataStream, compressed: self.flags.compressed)
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
    /// structure of the record.
    public struct Flags {
        public let objectId: UInt8
        public let reserved1: UInt8
        public let compressed: Bool
        public let reserved2: Bool
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// ObjectID (1 byte): The index of an EmfPlusImage object in the EMF+ Object Table, which specifies the image to render.
            /// The value MUST be zero to 63, inclusive.
            let objectId = UInt8(flags.readBits(count: 8))
            guard objectId >= 0 && objectId <= 63 else {
                throw EmfPlusReadError.corrupted
            }
            
            self.objectId = objectId
            
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
