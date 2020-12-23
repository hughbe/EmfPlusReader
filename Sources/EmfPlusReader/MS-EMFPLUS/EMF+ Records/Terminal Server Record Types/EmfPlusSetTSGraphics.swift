//
//  EmfPlusSetTSGraphics.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.8.2 EmfPlusSetTSGraphics Record
/// The EmfPlusSetTSGraphics record specifies the state of a graphics device context for a terminal server. <31>
/// See section 2.3.8 for the specification of additional terminal server record types.
public struct EmfPlusSetTSGraphics {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let antiAliasMode: SmoothingMode
    public let textRenderHint: TextRenderingHint
    public let compositingMode: CompositingMode
    public let compositingQuality: CompositingQuality
    public let renderOriginX: Int16
    public let renderOriginY: Int16
    public let textContrast: UInt16
    public let filterType: FilterType
    public let pixelOffset: PixelOffsetMode
    public let worldToDevice: EmfPlusTransformMatrix
    public let palette: EmfPlusPalette?
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusSetTSGraphics from the RecordType
        /// enumeration.
        /// The value MUST be 0x4039.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .setTSGraphics else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        let flags = try Flags(dataStream: &dataStream)
        self.flags = flags
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data. This value MUST be 0x00000030 plus the size of the Palette field.
        self.size = try dataStream.read(endianess: .littleEndian)
        if self.flags.containsPalette {
            guard self.size >= 0x00000030 else {
                throw EmfPlusReadError.corrupted
            }
        } else {
            guard self.size == 0x00000030 else {
                throw EmfPlusReadError.corrupted
            }
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of record-specific data that follows.
        /// This value MUST be 0x00000024 plus the size of the Palette field.
        self.dataSize = try dataStream.read(endianess: .littleEndian)
        if self.flags.containsPalette {
            guard self.dataSize >= 0x00000024 else {
                throw EmfPlusReadError.corrupted
            }
        } else {
            guard self.dataSize == 0x00000030 else {
                throw EmfPlusReadError.corrupted
            }
        }
        
        let dataStartPosition = dataStream.position
        
        /// AntiAliasMode (1 byte): An unsigned integer that specifies the quality of line rendering, including the type of line
        /// anti-aliasing. It is defined in the SmoothingMode enumeration.
        self.antiAliasMode = try SmoothingMode(dataStream: &dataStream)
        
        /// TextRenderHint (1 byte): An unsigned integer that specifies the quality of text rendering, including the type of text
        /// anti-aliasing. It is defined in the TextRenderingHint enumeration.
        self.textRenderHint = try TextRenderingHint(dataStream: &dataStream)

        /// CompositingMode (1 byte): An unsigned integer that specifies how source colors are combined with background colors.
        /// It MUST be a value in the CompositingMode enumeration.
        self.compositingMode = try CompositingMode(dataStream: &dataStream)

        /// CompositingQuality (1 byte): An unsigned integer that specifies the degree of smoothing to apply to lines, curves and the
        /// edges of filled areas to make them appear more continuous or sharply defined. It MUST be a value in the
        /// CompositingQuality enumeration.
        self.compositingQuality = try CompositingQuality(dataStream: &dataStream)

        /// RenderOriginX (2 bytes): A signed integer, which is the horizontal coordinate of the origin for rendering halftoning and
        /// dithering matrixes.
        self.renderOriginX = try dataStream.read(endianess: .littleEndian)
        
        /// RenderOriginY (2 bytes): A signed integer, which is the vertical coordinate of the origin for rendering halftoning and
        /// dithering matrixes.
        self.renderOriginY = try dataStream.read(endianess: .littleEndian)
        
        /// TextContrast (2 bytes): An unsigned integer that specifies the gamma correction value used for rendering anti-aliased and
        /// ClearType text. This value MUST be in the range 0 to 12, inclusive.
        let textContrast: UInt16 = try dataStream.read(endianess: .littleEndian)
        guard textContrast >= 0 && textContrast <= 12 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.textContrast = textContrast
        
        /// FilterType (1 byte): An unsigned integer that specifies how scaling, including stretching and shrinking, is performed.
        /// It MUST be a value in the FilterType enumeration.
        self.filterType = try FilterType(dataStream: &dataStream)
        
        /// PixelOffset (1 byte): An unsigned integer that specifies the overall quality of the image and textrendering process.
        /// It MUST be a value in the PixelOffsetMode enumeration.
        self.pixelOffset = try PixelOffsetMode(dataStream: &dataStream)
        
        /// WorldToDevice (24 bytes): An 192-bit EmfPlusTransformMatrix object that specifies the world space to device space
        /// transforms.
        self.worldToDevice = try EmfPlusTransformMatrix(dataStream: &dataStream)
        
        if self.flags.containsPalette {
            let remainingSizeForPalette = size - UInt32(dataStream.position - startPosition)
            self.palette = try EmfPlusPalette(dataStream: &dataStream, availableSize: remainingSizeForPalette)
        } else {
            self.palette = nil
        }

        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
    /// structure of the record.
    public struct Flags {
        public let containsPalette: Bool
        public let paletteContainsOnlyVGAColors: Bool
        public let reserved: UInt16
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// T (1 bit): If set, this record contains an EmfPlusPalette object in the Palette field following the graphics state data.
            self.containsPalette = flags.readBit()
            
            /// V (1 bit): If set, the palette contains only the basic VGA colors.
            self.paletteContainsOnlyVGAColors = flags.readBit()
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved = flags.readRemainingBits()
        }
    }
}
