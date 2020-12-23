//
//  BrushDataFlags.swift
//
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.1.2.1 BrushData Flags
/// The BrushData flags specify properties of graphics brushes, including the presence of optional data fields. These flags can be
/// combined to specify multiple options.
/// Graphics brushes are specified by EmfPlusBrush objects.
/// See section 2.1.2 for the specification of additional bit flags.
public struct BrushDataFlags: OptionSet {
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public init(dataStream: inout DataStream) throws {
        self.rawValue = try dataStream.read(endianess: .littleEndian)
    }
    
    /// BrushDataPath 0x00000001
    /// This flag is meaningful in EmfPlusPathGradientBrushData objects.
    /// If set, an EmfPlusBoundaryPathData object is specified in the BoundaryData field of the brush data object.
    /// If clear, an EmfPlusBoundaryPointData object is specified in the BoundaryData field of the brush data object.
    public static let path = BrushDataFlags(rawValue: 0x00000001)
    
    /// BrushDataTransform 0x00000002
    /// This flag is meaningful in EmfPlusLinearGradientBrushData objects, EmfPlusPathGradientBrushData objects, and
    /// EmfPlusTextureBrushData objects.
    /// If set, a 2x3 world space to device space transform matrix is specified in the OptionalData field of the brush data object.
    public static let transform = BrushDataFlags(rawValue: 0x00000002)
    
    /// BrushDataPresetColors 0x00000004
    /// This flag is meaningful in EmfPlusLinearGradientBrushData and EmfPlusPathGradientBrushData objects.
    /// If set, an EmfPlusBlendColors object is specified in the OptionalData field of the brush data object.
    public static let presetColors = BrushDataFlags(rawValue: 0x00000004)
    
    /// BrushDataBlendFactorsH 0x00000008
    /// This flag is meaningful in EmfPlusLinearGradientBrushData and EmfPlusPathGradientBrushData objects.
    /// If set, an EmfPlusBlendFactors object that specifies a blend pattern along a horizontal gradient is specified in the OptionalData
    /// field of the brush data object.
    public static let blendFactorsH = BrushDataFlags(rawValue: 0x00000008)
    
    /// BrushDataBlendFactorsV 0x00000010
    /// This flag is meaningful in EmfPlusLinearGradientBrushData objects.
    /// If set, an EmfPlusBlendFactors object that specifies a blend pattern along a vertical gradient is specified in the OptionalData
    /// field of the brush data object.<6>
    public static let blendFactorsV = BrushDataFlags(rawValue: 0x00000010)
    
    /// BrushDataFocusScales 0x00000040
    /// This flag is meaningful in EmfPlusPathGradientBrushData objects.
    /// If set, an EmfPlusFocusScaleData object is specified in the OptionalData field of the brush data object.
    public static let focusScales = BrushDataFlags(rawValue: 0x00000040)
    
    /// BrushDataIsGammaCorrected 0x00000080
    /// This flag is meaningful in EmfPlusLinearGradientBrushData, EmfPlusPathGradientBrushData, and EmfPlusTextureBrushData
    /// objects.
    /// If set, the brush MUST already be gamma corrected; that is, output brightness and intensity have been corrected to match the
    /// input image.
    public static let isGammaCorrected = BrushDataFlags(rawValue: 0x00000080)
    
    /// BrushDataDoNotTransform 0x00000100
    /// This flag is meaningful in EmfPlusTextureBrushData objects.
    /// If set, a world space to device space transform SHOULD NOT be applied to the texture brush.
    public static let doNotTransform = BrushDataFlags(rawValue: 0x00000100)
    
    public static let all: BrushDataFlags = [
        .path,
        .transform,
        .presetColors,
        .blendFactorsH,
        .blendFactorsV,
        .focusScales,
        .isGammaCorrected,
        .doNotTransform
    ]
}
