//
//  EmfPlusDrawString.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.4.14 EmfPlusDrawString Record
/// The EmfPlusDrawString record specifies text output with string formatting.
/// See section 2.3.4 for the specification of additional drawing record types.
public struct EmfPlusDrawString {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let brushId: BrushId
    public let formatID: UInt32
    public let length: UInt32
    public let layoutRect: EmfPlusRectF
    public let stringData: String
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusDrawString from the RecordType
        /// enumeration.
        /// The value MUST be 0x401C.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .drawString else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        self.flags = try Flags(dataStream: &dataStream)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header, record-specific data, and any extra alignment padding.
        /// Value Meaning
        /// 0x0000002A ≤ value The size of the record is computed as follows:
        /// Size = (Length * 0x00000002) + 0x00000028 (+ AlignmentPaddingSize where AlignmentPaddingSize is the number of
        /// bytes in AlignmentPadding)
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000028 && size % 4 == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of record-specific
        /// data and any extra alignment padding that follows.
        /// Value Meaning
        /// 0x0000001E ≤ value The size of the data is computed as follows:
        /// DataSize = (Length * 0x00000002) + 0x0000001C (+ AlignmentPaddingSize where AlignmentPaddingSize is the number of
        /// bytes in AlignmentPadding)
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize >= 0x0000001C && dataSize % 4 == 0 && dataSize == size - 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        let dataStartPosition = dataStream.position
        
        /// BrushId (4 bytes): An unsigned integer that specifies the brush, the content of which is determined by the S bit in the
        /// Flags field. This definition is used to paint the foreground text color; that is, just the glyphs themselves.
        self.brushId = try BrushId(dataStream: &dataStream, brushIdIsColor: self.flags.brushIdIsColor)
        
        /// FormatID (4 bytes): An unsigned integer that specifies the index of an optional EmfPlusStringFormat object in the
        /// EMF+ Object Table. This object specifies text layout information and display manipulations to be applied to a string.
        self.formatID = try dataStream.read(endianess: .littleEndian)
        
        /// Length (4 bytes): An unsigned integer that specifies the number of characters in the string.
        let length: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard length * 0x00000002 + 0x00000028 <= size &&
                length * 0x00000002 + 0x0000001C <= dataSize else {
            throw EmfPlusReadError.corrupted
        }
        
        self.length = length
        
        /// LayoutRect (16 bytes): An EmfPlusRectF object that defines the bounding area of the destination that will receive the string.
        self.layoutRect = try EmfPlusRectF(dataStream: &dataStream)
        
        /// StringData (variable): An array of 16-bit Unicode characters that specifies the string to be drawn.
        self.stringData = try dataStream.readString(count: Int(self.length) * 2, encoding: .utf16LittleEndian)!
        
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
