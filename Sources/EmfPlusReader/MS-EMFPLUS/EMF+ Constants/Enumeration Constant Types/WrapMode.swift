//
//  WrapMode.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.33 WrapMode Enumeration
/// The WrapMode enumeration defines how the pattern from a texture or gradient brush is tiled across a shape or at shape boundaries,
/// when it is smaller than the area being filled.
/// typedef enum
/// {
///  WrapModeTile = 0x00000000,
///  WrapModeTileFlipX = 0x00000001,
///  WrapModeTileFlipY = 0x00000002,
///  WrapModeTileFlipXY = 0x00000003,
///  WrapModeClamp = 0x00000004
/// } WrapMode;
public enum WrapMode: UInt32, DataStreamCreatable {
    /// WrapModeTile: Tiles the gradient or texture.
    case tile = 0x00000000
    
    /// WrapModeTileFlipX: Reverses the texture or gradient horizontally, and then tiles the texture or gradient.
    case tileFlipX = 0x00000001
    
    /// WrapModeTileFlipY: Reverses the texture or gradient vertically, and then tiles the texture or gradient.
    case tileFlipY = 0x00000002
    
    /// WrapModeTileFlipXY: Reverses the texture or gradient horizontally and vertically, and then tiles the texture or gradient.
    case tileFlipXY = 0x00000003
    
    /// WrapModeClamp: Fixes the texture or gradient to the object boundary.
    case clamp = 0x00000004
}
