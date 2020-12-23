//
//  PaletteStyleFlags.swift
//
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.1.2.5 PaletteStyle Flags
/// The PaletteStyle flags specify properties of graphics palettes. These flags can be combined to specify multiple options.
/// See section 2.1.2 for the specification of additional bit flags.
public struct PaletteStyleFlags: OptionSet {
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public init(dataStream: inout DataStream) throws {
        self.rawValue = try dataStream.read(endianess: .littleEndian)
    }
    
    /// PaletteStyleHasAlpha 0x00000001
    /// If set, one or more of the palette entries MUST contain alpha transparency information.
    public static let hasAlpha = PaletteStyleFlags(rawValue: 0x00000001)
    
    /// PaletteStyleGrayScale 0x00000002
    /// If set, the palette MUST contain only grayscale entries.
    public static let grayScale = PaletteStyleFlags(rawValue: 0x00000002)
    
    /// PaletteStyleHalftone 0x00000004
    /// If set, the palette MUST contain discrete color values that can be used for halftoning.
    public static let halftone = PaletteStyleFlags(rawValue: 0x00000004)
    
    public static let all: PaletteStyleFlags = [.hasAlpha, .grayScale, .halftone]
}
