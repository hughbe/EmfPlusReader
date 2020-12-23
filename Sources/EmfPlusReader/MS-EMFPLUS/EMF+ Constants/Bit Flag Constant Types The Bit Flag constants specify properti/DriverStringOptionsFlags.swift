//
//  DriverStringOptionsFlags.swift
//
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.1.2.3 DriverStringOptions Flags
/// The DriverStringOptions flags specify properties of graphics text positioning and rendering. These flags can be combined to specify
/// multiple options.
/// See section 2.1.2 for the specification of additional bit flags.
public struct DriverStringOptionsFlags: OptionSet {
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public init(dataStream: inout DataStream) throws {
        self.rawValue = try dataStream.read(endianess: .littleEndian)
    }
    
    /// DriverStringOptionsCmapLookup 0x00000001
    /// If set, the positions of character glyphs SHOULD be specified in a character map lookup table.
    /// If clear, the glyph positions SHOULD be obtained from an array of coordinates.
    public static let cmapLookup = DriverStringOptionsFlags(rawValue: 0x00000001)
    
    /// DriverStringOptionsVertical 0x00000002
    /// If set, the string SHOULD be rendered vertically.
    /// If clear, the string SHOULD be rendered horizontally.
    public static let vertical = DriverStringOptionsFlags(rawValue: 0x00000002)
    
    /// DriverStringOptionsRealizedAdvance 0x00000004
    /// If set, character glyph positions SHOULD be calculated relative to the position of the first glyph.<7>
    /// If clear, the glyph positions SHOULD be obtained from an array of coordinates.
    public static let realizedAdvance = DriverStringOptionsFlags(rawValue: 0x00000004)
    
    /// DriverStringOptionsLimitSubpixel 0x00000008
    /// If set, less memory SHOULD be used to cache anti-aliased glyphs, which produces lower quality text rendering.
    /// If clear, more memory SHOULD be used, which produces higher quality text rendering.
    public static let limitSubpixel = DriverStringOptionsFlags(rawValue: 0x00000008)
    
    public static let all: DriverStringOptionsFlags = [.cmapLookup, .vertical, .realizedAdvance, limitSubpixel]
}
