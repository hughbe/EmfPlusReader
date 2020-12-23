//
//  EmfPlusStringFormat.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.1.9 EmfPlusStringFormat Object
/// The EmfPlusStringFormat object specifies text layout, display manipulations, and language identification.
/// See section 2.2.1 for the specification of additional graphics objects.
public struct EmfPlusStringFormat {
    public let version: EmfPlusGraphicsVersion
    public let stringFormatFlags: StringFormatFlags
    public let language: EmfPlusLanguageIdentifier
    public let stringAlignment: StringAlignment
    public let lineAlign: StringAlignment
    public let digitSubstitution: StringDigitSubstitution
    public let digitLanguage: EmfPlusLanguageIdentifier
    public let firstTabOffset: Float
    public let hotkeyPrefix: HotkeyPrefix
    public let leadingMargin: Float
    public let trailingMargin: Float
    public let tracking: Float
    public let trimming: StringTrimming
    public let tabStopCount: Int32
    public let rangeCount: Int32
    public let stringFormatData: EmfPlusStringFormatData
    
    public init(dataStream: inout DataStream, dataSize: UInt32) throws {
        guard dataSize >= 0x0000003C else {
            throw EmfPlusReadError.corrupted
        }
        
        let startPosition = dataStream.position
        
        /// Version (4 bytes): An EmfPlusGraphicsVersion object that specifies the version of operating system graphics that was used
        /// to create this object.
        self.version = try EmfPlusGraphicsVersion(dataStream: &dataStream)
        
        /// StringFormatFlags (4 bytes): An unsigned integer that specifies text layout options for formatting, clipping and font handling.
        /// This value is composed of StringFormat flags.
        self.stringFormatFlags = try StringFormatFlags(dataStream: &dataStream)
        
        /// Language (4 bytes): An EmfPlusLanguageIdentifier object that specifies the language to use for the string.
        self.language = try EmfPlusLanguageIdentifier(dataStream: &dataStream)
        
        /// StringAlignment (4 bytes): An unsigned integer that specifies how to align the string horizontally in the layout rectangle.
        /// This value is defined in the StringAlignment enumeration.
        self.stringAlignment = try StringAlignment(dataStream: &dataStream)
        
        /// LineAlign (4 bytes): An unsigned integer that specifies how to align the string vertically in the layout rectangle. This value is
        /// defined in the StringAlignment enumeration.
        self.lineAlign = try StringAlignment(dataStream: &dataStream)

        /// DigitSubstitution (4 bytes): An unsigned integer that specifies how to substitute numeric digits in the string according to a
        /// locale or language. This value is defined in the StringDigitSubstitution enumeration.
        self.digitSubstitution = try StringDigitSubstitution(dataStream: &dataStream)
        
        /// DigitLanguage (4 bytes): An EmfPlusLanguageIdentifier object that specifies the language to use for numeric digits in the
        /// string. For example, if this string contains Arabic digits, this field MUST contain a language identifier that specifies an
        /// Arabic language.
        self.digitLanguage = try EmfPlusLanguageIdentifier(dataStream: &dataStream)

        /// FirstTabOffset (4 bytes): A floating-point value that specifies the number of spaces between the beginning of a text line and
        /// the first tab stop.
        self.firstTabOffset = try dataStream.readFloat(endianess: .littleEndian)
        
        /// HotkeyPrefix (4 bytes): A signed integer that specifies the type of processing that is performed on a string when a keyboard
        /// shortcut prefix (that is, an ampersand) is encountered. Basically, this field specifies whether to display keyboard shortcut
        /// prefixes that relate to text. The value is defined in the HotkeyPrefix enumeration.
        self.hotkeyPrefix = try HotkeyPrefix(dataStream: &dataStream)
        
        /// LeadingMargin (4 bytes): A floating-point value that specifies the length of the space to add to the starting position of a
        /// string. The default is 1/6 inch; for typographic fonts, the default value is 0.
        self.leadingMargin = try dataStream.readFloat(endianess: .littleEndian)

        /// TrailingMargin (4 bytes): A floating-point value that specifies the length of the space to leave following a string.
        /// The default is 1/6 inch; for typographic fonts, the default value is 0.
        self.trailingMargin = try dataStream.readFloat(endianess: .littleEndian)

        /// Tracking (4 bytes): A floating-point value that specifies the ratio of the horizontal space allotted to each character in a
        /// specified string to the font-defined width of the character. Large values for this property specify ample space between
        /// characters; values less than 1 can produce character overlap. The default is 1.03; for typographic fonts, the default
        /// value is 1.00.
        self.tracking = try dataStream.readFloat(endianess: .littleEndian)

        /// Trimming (4 bytes): Specifies how to trim characters from a string that is too large to fit into a layout rectangle.
        /// This value is defined in the StringTrimming enumeration.
        self.trimming = try StringTrimming(dataStream: &dataStream)
        
        /// TabStopCount (4 bytes): A signed integer that specifies the number of tab stops defined in the StringFormatData field.
        let tabStopCount: Int32 = try dataStream.read(endianess: .littleEndian)
        guard tabStopCount >= 0 && 0x0000003C + tabStopCount * 4 <= dataSize else {
            throw EmfPlusReadError.corrupted
        }
        
        self.tabStopCount = tabStopCount
        
        /// RangeCount (4 bytes): A signed integer that specifies the number of EmfPlusCharacterRange object defined in the
        /// StringFormatData field.
        let rangeCount: Int32 = try dataStream.read(endianess: .littleEndian)
        guard rangeCount >= 0 && 0x0000003C + tabStopCount * 4 + rangeCount * 8 == dataSize else {
            throw EmfPlusReadError.corrupted
        }
        
        self.rangeCount = rangeCount
        
        /// StringFormatData (variable): An EmfPlusStringFormatData object that specifies optional text layout data.
        self.stringFormatData = try EmfPlusStringFormatData(dataStream: &dataStream,
                                                            tabStopCount: self.tabStopCount,
                                                            rangeCount: self.rangeCount,
                                                            size: dataSize - 0x0000003C)
        
        guard dataStream.position - startPosition == dataSize else {
            throw EmfPlusReadError.corrupted
        }
    }
}
