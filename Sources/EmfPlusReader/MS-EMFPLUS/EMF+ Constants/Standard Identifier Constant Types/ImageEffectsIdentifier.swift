//
//  ImageEffectsIdentifier.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream
import WindowsDataTypes

/// [MS-EMFPLUS] 2.1.3.1 ImageEffects Identifiers
/// The ImageEffects identifiers define standard GUIDs for specifying graphics image effects. These identifiers are used by device drivers
/// to publish their levels of support for these effects. The identifier constants are defined using the GUID curly-braced string representation
/// ([MS-DTYP] section 2.3.4.3).
/// Image effects identifiers and Image Effects Parameter Blocks are specified by EmfPlusSerializableObject records for
/// EmfPlusDrawImagePoints records.
public enum ImageEffectsIdentifier {
    case blur
    case brightnessContrast
    case colorBalance
    case colorCurve
    case colorLookupTable
    case colorMatrix
    case hueSaturationLightness
    case levels
    case redEyeCorrection
    case sharpen
    case tint
    case unknown(_: GUID)
    
    /// BlurEffectGuid {633C80A4-1843-482B-9EF2-BE2834C5FDD4} Specifies the blur effect.
    public static let blurEffectGuid = GUID(0x633C80A4, 0x1843, 0x482B, 0x9EF2, 0xBE2834C5FDD4)
    
    /// BrightnessContrastEffectGuid {D3A1DBE1-8EC4-4C17-9F4C-EA97AD1C343D} Specifies the brightness contrast effect.
    public static let brightnessContrastEffectGuid = GUID(0xD3A1DBE1, 0x8EC4, 0x4C17, 0x9F4C, 0xEA97AD1C343D)
        
    /// ColorBalanceEffectGuid {537E597D-251E-48DA-9664-29CA496B70F8} Specifies the color balance effect.
    public static let colorBalanceEffectGuid = GUID(0x537E597D, 0x251E, 0x48DA, 0x9664, 0x29CA496B70F8)
        
    /// ColorCurveEffectGuid {DD6A0022-58E4-4A67-9D9B-D48EB881A53D} Specifies the color curve effect.<9>
    public static let colorCurveEffectGuid = GUID(0xDD6A0022, 0x58E4, 0x4A67, 0x9D9B, 0xD48EB881A53D)
    
    /// ColorLookupTableEffectGuid {A7CE72A9-0F7F-40D7-B3CC-D0C02D5C3212} Specifies the color lookup table effect.
    public static let colorLookupTableEffectGuid = GUID(0xA7CE72A9, 0x0F7F, 0x40D7, 0xB3CC, 0xD0C02D5C3212)
    
    /// ColorMatrixEffectGuid {718F2615-7933-40E3-A511-5F68FE14DD74} Specifies the color matrix effect.
    public static let colorMatrixEffectGuid = GUID(0x718F2615, 0x7933, 0x40E3, 0xA511, 0x5F68FE14DD74)
    
    /// HueSaturationLightnessEffectGuid {8B2DD6C3-EB07-4D87-A5F0-7108E26A9C5F} Specifies the hue saturation lightness effect.
    public static let hueSaturationLightnessEffectGuid = GUID(0x8B2DD6C3, 0xEB07, 0x4D87, 0xA5F0, 0x7108E26A9C5F)
        
    /// LevelsEffectGuid {99C354EC-2A31-4F3A-8C34-17A803B33A25} Specifies the levels effect.
    public static let levelsEffectGuid = GUID(0x99C354EC, 0x2A31, 0x4F3A, 0x8C34, 0x17A803B33A25)
    
    /// RedEyeCorrectionEffectGuid {74D29D05-69A4-4266-9549-3CC52836B632} Specifies the red-eye correction effect.
    public static let redEyeCorrectionEffectGuid = GUID(0x74D29D05, 0x69A4, 0x4266, 0x9549, 0x3CC52836B632)
    
    /// SharpenEffectGuid {63CBF3EE-C526-402C-8F71-62C540BF5142} Specifies the sharpen effect.
    public static let sharpenEffectGuid = GUID(0x63CBF3EE, 0xC526, 0x402C, 0x8F71, 0x62C540BF5142)
    
    /// TintEffectGuid {1077AF00-2848-4441-9489-44AD4C2D7A2C} Specifies the tint effect.
    public static let tintEffectGuid = GUID(0x1077AF00, 0x2848, 0x4441, 0x9489, 0x44AD4C2D7A2C)

    
    public init(dataStream: inout DataStream) throws {
        let guid = try GUID(dataStream: &dataStream)

        switch guid {
        case Self.blurEffectGuid:
            self = .blur
        case Self.brightnessContrastEffectGuid:
            self = .brightnessContrast
        case Self.colorBalanceEffectGuid:
            self = .colorBalance
        case Self.colorCurveEffectGuid:
            self = .colorCurve
        case Self.colorLookupTableEffectGuid:
            self = .colorLookupTable
        case Self.colorMatrixEffectGuid:
            self = .colorMatrix
        case Self.hueSaturationLightnessEffectGuid:
            self = .hueSaturationLightness
        case Self.levelsEffectGuid:
            self = .levels
        case Self.redEyeCorrectionEffectGuid:
            self = .redEyeCorrection
        case Self.sharpenEffectGuid:
            self = .sharpen
        case Self.tintEffectGuid:
            self = .tint
        default:
            self = .unknown(guid)
        }
    }
}

