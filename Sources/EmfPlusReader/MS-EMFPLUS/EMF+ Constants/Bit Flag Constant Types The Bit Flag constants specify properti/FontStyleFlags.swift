//
//  FontStyleFlags.swift
//
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.1.2.4 FontStyle Flags
/// The FontStyle flags specify styles of graphics font typefaces. These flags can be combined to specify multiple options.
/// Graphics font typefaces are specified by EmfPlusFont objects.
/// See section 2.1.2 for the specification of additional bit flags.
public struct FontStyleFlags: OptionSet {
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public init(dataStream: inout DataStream) throws {
        self.rawValue = try dataStream.read(endianess: .littleEndian)
    }
    
    /// FontStyleBold 0x00000001
    /// If set, the font typeface is rendered with a heavier weight or thickness.
    /// If clear, the font typeface is rendered with a normal thickness.
    public static let bold = FontStyleFlags(rawValue: 0x00000001)
    
    /// FontStyleItalic 0x00000002
    /// If set, the font typeface is rendered with the vertical stems of the characters at an increased angle or slant relative to the baseline.
    /// If clear, the font typeface is rendered with the vertical stems of the characters at a normal angle.
    public static let italic = FontStyleFlags(rawValue: 0x00000002)
    
    /// FontStyleUnderline 0x00000004
    /// If set, the font typeface is rendered with a line underneath the baseline of the characters.
    /// If clear, the font typeface is rendered without a line underneath the baseline.
    public static let underline = FontStyleFlags(rawValue: 0x00000004)
    
    /// FontStyleStrikeout 0x00000008
    /// If set, the font typeface is rendered with a line parallel to the baseline drawn through the middle of the characters.
    /// If clear, the font typeface is rendered without a line through the characters.
    public static let strikeout = FontStyleFlags(rawValue: 0x00000008)

    public static let all: FontStyleFlags = [.bold, .italic, .underline, .strikeout]
}
