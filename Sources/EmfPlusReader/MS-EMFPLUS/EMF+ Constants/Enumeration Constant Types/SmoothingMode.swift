//
//  SmoothingMode.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.27 SmoothingMode Enumeration
/// The SmoothingMode enumeration defines smoothing modes to apply to lines, curves, and the edges of filled areas to make them
/// appear more continuous or sharply defined.
/// typedef enum
/// {
///  SmoothingModeDefault = 0x00,
///  SmoothingModeHighSpeed = 0x01,
///  SmoothingModeHighQuality = 0x02,
///  SmoothingModeNone = 0x03,
///  SmoothingModeAntiAlias8x4 = 0x04,
///  SmoothingModeAntiAlias8x8 = 0x05
/// } SmoothingMode;
/// See section 2.1.1 for the specification of additional enumerations.
public enum SmoothingMode: UInt8, DataStreamCreatable {
    /// SmoothingModeDefault: Default curve smoothing with no anti-aliasing.
    case `default` = 0x00
    
    /// SmoothingModeHighSpeed: Best performance with no anti-aliasing.
    case highSpeed = 0x01
    
    /// SmoothingModeHighQuality: Best quality with anti-aliasing.
    case highQuality = 0x02
    
    /// SmoothingModeNone: No curve smoothing and no anti-aliasing.
    case none = 0x03
    
    /// SmoothingModeAntiAlias8x4: Anti-aliasing using an 8x4 box filter.<4>
    case antiAlias8x4 = 0x04
    
    /// SmoothingModeAntiAlias8x8: Anti-aliasing using an 8x8 box filter.<5>
    case antiAlias8x8 = 0x05
}
