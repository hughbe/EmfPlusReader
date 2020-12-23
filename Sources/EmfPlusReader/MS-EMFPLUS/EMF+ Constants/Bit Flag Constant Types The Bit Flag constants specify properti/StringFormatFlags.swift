//
//  StringFormatFlags.swift
//
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.1.2.8 StringFormat Flags
/// The StringFormat flags specify options for graphics text layout, including direction, clipping and font handling.
/// These flags can be combined to specify multiple options.
/// Graphics text layout is specified by EmfPlusStringFormat objects.
/// See section 2.1.2 for the specification of additional bit flags.
public struct StringFormatFlags: OptionSet {
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public init(dataStream: inout DataStream) throws {
        self.rawValue = try dataStream.read(endianess: .littleEndian)
    }
    
    /// StringFormatDirectionRightToLeft 0x00000001
    /// If set, the reading order of the string SHOULD be right to left. For horizontal text, this means that characters are read from right
    /// to left. For vertical text, this means that columns are read from right to left.
    /// If clear, horizontal or vertical text SHOULD be read from left to right.
    public static let directionRightToLeft = StringFormatFlags(rawValue: 0x00000001)
    
    /// StringFormatDirectionVertical 0x00000002
    /// If set, individual lines of text SHOULD be drawn vertically on the display device.
    /// If clear, individual lines of text SHOULD be drawn horizontally, with each new line below the previous line.
    public static let directionVertical = StringFormatFlags(rawValue: 0x00000002)
    
    /// StringFormatNoFitBlackBox 0x00000004
    /// If set, parts of characters MUST be allowed to overhang the text layout rectangle.
    /// If clear, characters that overhang the boundaries of the text layout rectangle MUST be repositioned to avoid overhang.
    /// An italic, "f" is an example of a character that can have overhanging parts.
    public static let noFitBlackBox = StringFormatFlags(rawValue: 0x00000004)
    
    /// StringFormatDisplayFormatControl 0x00000020
    /// If set, control characters SHOULD appear in the output as representative Unicode glyphs.
    public static let displayFormatControl = StringFormatFlags(rawValue: 0x00000020)
    
    /// StringFormatNoFontFallback 0x00000400
    /// If set, an alternate font SHOULD be used for characters that are not supported in the requested font.
    /// If clear, a character missing from the requested font SHOULD appear as a "font missing" character, which MAY be an open square.
    public static let noFontFallback = StringFormatFlags(rawValue: 0x00000400)
    
    /// StringFormatMeasureTrailingSpaces 0x00000800
    /// If set, the space at the end of each line MUST be included in measurements of string length.
    /// If clear, the space at the end of each line MUST be excluded from measurements of string length.
    public static let measureTrailingSpaces = StringFormatFlags(rawValue: 0x00000800)
    
    /// StringFormatNoWrap 0x00001000
    /// If set, a string that extends past the end of the text layout rectangle MUST NOT be wrapped to the next line.
    /// If clear, a string that extends past the end of the text layout rectangle MUST be broken at the last word boundary within the
    /// bounding rectangle, and the remainder of the string MUST be wrapped to the next line.
    public static let noWrap = StringFormatFlags(rawValue: 0x00001000)
    
    /// StringFormatLineLimit 0x00002000
    /// If set, whole lines of text SHOULD be output and SHOULD NOT be clipped by the string's layout rectangle.
    /// If clear, text layout SHOULD continue until all lines are output, or until additional lines would not be visible as a result of clipping.
    /// This flag can be used either to deny or allow a line of text to be partially obscured by a layout rectangle that is not a multiple of
    /// line height. For all text to be visible, a layout rectangle at least as tall as the height of one line.
    public static let lineLimit = StringFormatFlags(rawValue: 0x00002000)
    
    /// StringFormatNoClip 0x00004000
    /// If set, text extending outside the string layout rectangle SHOULD be allowed to show.
    /// If clear, all text that extends outside the layout rectangle SHOULD be clipped.
    public static let noClip = StringFormatFlags(rawValue: 0x00004000)
    
    /// StringFormatBypassGDI 0x80000000
    /// This flag MAY be used to specify an implementation-specific process for rendering text.<8>
    public static let bypassGDI = StringFormatFlags(rawValue: 0x80000000)
    
    public static let all: StringFormatFlags = [
        .directionRightToLeft,
        .directionVertical,
        .noFitBlackBox,
        .displayFormatControl,
        .noFontFallback,
        .measureTrailingSpaces,
        .noWrap,
        .lineLimit,
        .noClip,
        .bypassGDI
    ]
}
