//
//  HueSaturationLightnessEffect.swift
//
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.3.7 HueSaturationLightnessEffect Object
/// The HueSaturationLightnessEffect object specifies adjustments to the hue, saturation, and lightness of an image.
/// Bitmap images are specified by EmfPlusBitmap objects.
/// See section 2.2.3 for the specification of additional image effects parameter objects.
public struct HueSaturationLightnessEffect {
    public let hueLevel: Int32
    public let saturationLevel: Int32
    public let lightnessLevel: Int32
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size == 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        /// HueLevel (4 bytes): Specifies the adjustment to the hue.
        /// Value Meaning
        /// -180 ≤ value < 0 Negative values specify clockwise rotation on the color wheel.
        /// 0 A value of 0 specifies that the hue MUST NOT change.
        /// 0 < value ≤ 180 Positive values specify counter-clockwise rotation on the color wheel.
        let hueLevel: Int32 = try dataStream.read(endianess: .littleEndian)
        guard hueLevel >= -180 && hueLevel <= 180 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.hueLevel = hueLevel
        
        /// SaturationLevel (4 bytes): Specifies the adjustment to the saturation.
        /// Value Meaning
        /// -100 ≤ value < 0 Negative values specify decreasing saturation.
        /// 0 A value of 0 specifies that the saturation MUST NOT change.
        /// 0 < value ≤ 100 Positive values specify increasing saturation.
        let saturationLevel: Int32 = try dataStream.read(endianess: .littleEndian)
        guard saturationLevel >= -100 && saturationLevel <= 100 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.saturationLevel = saturationLevel
        
        /// LightnessLevel (4 bytes): Specifies the adjustment to the lightness.
        /// Value Meaning
        /// -100 ≤ value < 0 Negative values specify decreasing lightness.
        /// 0 A value of 0 specifies that the lightness MUST NOT change.
        /// 0 < value ≤ 100 Positive values specify increasing lightness.
        let lightnessLevel: Int32 = try dataStream.read(endianess: .littleEndian)
        guard lightnessLevel >= -100 && lightnessLevel <= 100 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.lightnessLevel = lightnessLevel
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
