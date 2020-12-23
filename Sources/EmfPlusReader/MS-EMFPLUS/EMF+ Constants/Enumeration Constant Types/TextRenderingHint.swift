//
//  TextRenderingHint.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.31 TextRenderingHint Enumeration
/// The TextRenderingHint enumeration defines types of text hinting and anti-aliasing, which affects the quality of text rendering.
/// typedef enum
/// {
///  TextRenderingHintSystemDefault = 0x00,
///  TextRenderingHintSingleBitPerPixelGridFit = 0x01,
///  TextRenderingHintSingleBitPerPixel = 0x02,
///  TextRenderingHintAntialiasGridFit = 0x03,
///  TextRenderingHintAntialias = 0x04,
///  TextRenderingHintClearTypeGridFit = 0x05
/// } TextRenderingHint;
/// See section 2.1.1 for the specification of additional enumerations.
public enum TextRenderingHint: UInt8, DataStreamCreatable {
    /// TextRenderingHintSystemDefault: Specifies that each text character SHOULD be drawn using whatever font-smoothing settings
    /// have been configured on the operating system.
    case systemDefault = 0x00
    
    /// TextRenderingHintSingleBitPerPixelGridFit: Specifies that each text character SHOULD be drawn using its glyph bitmap.
    /// Smoothing MAY be used to improve the appearance of character glyph stems and curvature.
    case singleBitPerPixelGridFit = 0x01
    
    /// TextRenderingHintSingleBitPerPixel: Specifies that each text character SHOULD be drawn using its glyph bitmap.
    /// Smoothing is not used.
    case singleBitsPerPixel = 0x02
    
    /// TextRenderingHintAntialiasGridFit: Specifies that each text character SHOULD be drawn using its anti-aliased glyph bitmap
    /// with smoothing. The rendering is high quality because of anti-aliasing, but at a higher performance cost.
    case antialiasGridFit = 0x03
    
    /// TextRenderingHintAntialias: Specifies that each text character is drawn using its anti-aliased glyph bitmap without hinting.
    /// Better quality results from anti-aliasing, but stem width differences MAY be noticeable because hinting is turned off.
    case antialias = 0x04
    
    /// TextRenderingHintClearTypeGridFit: Specifies that each text character SHOULD be drawn using its ClearType glyph bitmap
    /// with smoothing. This is the highest-quality text hinting setting, which is used to take advantage of ClearType font features.
    case clearTypeGridFit = 0x05
}
