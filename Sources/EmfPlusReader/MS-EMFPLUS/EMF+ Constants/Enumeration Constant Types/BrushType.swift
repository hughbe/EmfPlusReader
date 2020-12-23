//
//  BitmapDataType.swift
//
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.3 BrushType Enumeration
/// The BrushType enumeration defines types of graphics brushes, which are used to fill graphics regions.
/// typedef enum
/// {
///  BrushTypeSolidColor = 0x00000000,
///  BrushTypeHatchFill = 0x00000001,
///  BrushTypeTextureFill = 0x00000002,
///  BrushTypePathGradient = 0x00000003,
///  BrushTypeLinearGradient = 0x00000004
/// } BrushType;
/// Graphics brushes are specified by EmfPlusBrush objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum BrushType: UInt32, DataStreamCreatable {
    /// BrushTypeSolidColor: Specifies a solid-color brush, which is characterized by an EmfPlusARGB value.
    case solidColor = 0x00000000
    
    /// BrushTypeHatchFill: Specifies a hatch brush, which is characterized by a predefined pattern.
    case hatchFill = 0x00000001
    
    /// BrushTypeTextureFill: Specifies a texture brush, which is characterized by an image.
    case textureFill = 0x00000002
    
    /// BrushTypePathGradient: Specifies a path gradient brush, which is characterized by a color gradient path gradient brush data.
    case pathGradient = 0x00000003
    
    /// BrushTypeLinearGradient: BrushData contains linear gradient brush data.
    case linearGradient = 0x00000004
}
