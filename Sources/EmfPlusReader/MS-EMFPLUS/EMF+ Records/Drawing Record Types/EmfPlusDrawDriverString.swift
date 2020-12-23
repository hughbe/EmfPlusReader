//
//  EmfPlusDrawDriverString.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.4.6 EmfPlusDrawDriverString Record
/// The EmfPlusDrawDriverString record specifies text output with character positions.
/// See section 2.3.4 for the specification of additional drawing record types.
public struct EmfPlusDrawDriverString {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let brushId: BrushId
    public let driverStringOptionsFlags: DriverStringOptionsFlags
    public let matrixPresent: Bool
    public let glyphCount: UInt32
    public let glyphs: [UInt16]
    public let glyphPos: [EmfPlusPointF]
    public let transformMatrix: EmfPlusTransformMatrix?
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusDrawDriverString from the RecordType
        /// enumeration.
        /// The value MUST be 0x4036.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .drawDriverString else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        self.flags = try Flags(dataStream: &dataStream)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header, record-specific data, and any extra alignment padding.
        /// Value Meaning
        /// 0x0000001C ≤ value When glyphs are provided, but no transform matrix is specified in the
        /// TransformMatrix field, the size of the record is computed as follows:
        /// Size = (GlyphCount * 0x0000000A) + 0x0000001C
        /// 0x00000034 ≤ value When glyphs are provided, and a transform matrix is specified in the
        /// TransformMatrix field, the size of the record is computed as follows:
        /// Size = (GlyphCount * 0x0000000A) + 0x00000034
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x0000001C && size % 4 == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of record-specific
        /// data and any extra alignment padding that follows.
        /// Value Meaning
        /// 0x00000010 ≤ value When glyphs are provided, but no transform matrix is specified in the
        /// TransformMatrix field, the size of the data is computed as follows:
        /// DataSize = (GlyphCount * 0x0000000A) + 0x00000010
        /// 0x00000028 ≤ value When glyphs are provided, and a transform matrix is specified in the
        /// TransformMatrix field, the size of the data is computed as follows:
        /// DataSize = (GlyphCount * 0x0000000A) + 0x00000028
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize >= 0x00000010 && dataSize % 4 == 0 && dataSize == size - 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        let dataStartPosition = dataStream.position
        
        /// BrushId (4 bytes): An unsigned integer that specifies either the foreground color of the text or a graphics brush, depending
        /// on the value of the S flag in the Flags.
        self.brushId = try BrushId(dataStream: &dataStream, brushIdIsColor: self.flags.brushIdIsColor)
        
        /// DriverStringOptionsFlags (4 bytes): An unsigned integer that specifies the spacing, orientation, and quality of rendering
        /// for the string. This value MUST be composed of DriverStringOptions flags.
        self.driverStringOptionsFlags = try DriverStringOptionsFlags(dataStream: &dataStream)
        
        /// MatrixPresent (4 bytes): An unsigned integer that specifies whether a transform matrix is present in the TransformMatrix field.
        /// Value Meaning
        /// 0x00000000 The transform matrix is not present in the record.
        /// 0x00000001 The transform matrix is present in the record.
        let matrixPresent = (try dataStream.read(endianess: .littleEndian) as UInt32) != 0x00000000
        guard size >= (matrixPresent ? 0x00000034 : 0x0000001C) &&
                dataSize >= (matrixPresent ? 0x00000028 : 0x00000010) else {
            throw EmfPlusReadError.corrupted
        }
        
        self.matrixPresent = matrixPresent

        /// GlyphCount (4 bytes): An unsigned integer that specifies number of glyphs in the string.
        let glyphCount: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard glyphCount * 0x0000000A + (matrixPresent ? 0x00000034 : 0x0000001C) <= size &&
                glyphCount * 0x0000000A + (matrixPresent ? 0x00000028 : 0x00000010) <= dataSize else {
            throw EmfPlusReadError.corrupted
        }
        
        self.glyphCount = glyphCount
        
        /// Glyphs (variable): An array of 16-bit values that define the text string to draw.
        /// If the DriverStringOptionsCmapLookup flag in the DriverStringOptionsFlags field is set, each value in this array specifies
        /// a Unicode character. Otherwise, each value specifies an index to a character glyph in the EmfPlusFont object specified
        /// by the ObjectId value in Flags field.
        var glyphs: [UInt16] = []
        glyphs.reserveCapacity(Int(self.glyphCount))
        for _ in 0..<self.glyphCount {
            glyphs.append(try dataStream.read(endianess: .littleEndian))
        }
        
        self.glyphs = glyphs
        
        /// GlyphPos (variable): An array of EmfPlusPointF objects that specify the output position of each character glyph.
        /// There MUST be GlyphCount elements, which have a one-to-one correspondence with the elements in the Glyphs array.
        /// Glyph positions are calculated from the position of the first glyph if the DriverStringOptionsRealizedAdvance flag in
        /// DriverStringOptions flags is set. In this case, GlyphPos specifies the position of the first glyph only.
        var glyphPos: [EmfPlusPointF] = []
        glyphPos.reserveCapacity(Int(self.glyphCount))
        for _ in 0..<self.glyphCount {
            glyphPos.append(try EmfPlusPointF(dataStream: &dataStream))
        }
        
        self.glyphPos = glyphPos
        
        /// TransformMatrix (24 bytes): An optional EmfPlusTransformMatrix object that specifies the transformation to apply to each
        /// value in the text array. The presence of this data is determined from the MatrixPresent field.
        if self.matrixPresent {
            self.transformMatrix = try EmfPlusTransformMatrix(dataStream: &dataStream)
        } else {
            self.transformMatrix = nil
        }
        
        /// AlignmentPadding (variable): An optional array of up to 3 bytes that pads the record-specific data so that DataSize is a
        /// multiple of 4 bytes. This field MUST be ignored.
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
        public let reserved: UInt8
        public let brushIdIsColor: Bool
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// ObjectID (1 byte): The index of an EmfPlusFont object in the EMF+ Object Table to render the text.
            /// The value MUST be zero to 63, inclusive.
            let objectID = UInt8(flags.readBits(count: 8))
            guard objectID >= 0 && objectID <= 63 else {
                throw EmfPlusReadError.corrupted
            }
            
            self.objectID = objectID
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved = UInt8(flags.readBits(count: 7))
            
            /// S (1 bit): This bit indicates the type of data in the BrushId field.
            /// If set, BrushId specifies a color as an EmfPlusARGB object. If clear, BrushId contains the index of an EmfPlusBrush
            /// object in the EMF+ Object Table.
            self.brushIdIsColor = flags.readBit()
        }
    }
}
