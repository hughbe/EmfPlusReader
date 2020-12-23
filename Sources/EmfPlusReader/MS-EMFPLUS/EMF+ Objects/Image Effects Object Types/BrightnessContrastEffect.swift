//
//  BrightnessContrastEffect.swift
//
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.3.2 BrightnessContrastEffect Object
/// The BrightnessContrastEffect object specifies an expansion or contraction of the lightest and darkest areas of an image.
/// Bitmap images are specified by EmfPlusBitmap objects.
/// See section 2.2.3 for the specification of additional image effects parameter objects.
public struct BrightnessContrastEffect {
    public let brightnessLevel: Int32
    public let contrastLevel: Int32
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size == 0x00000008 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// BrightnessLevel (4 bytes): A signed integer that specifies the brightness level. This value MUST be in the range -255 through
        /// 255, with effects as follows: Value Meaning
        /// -255 ≤ value < 0 As the value decreases, the brightness of the image SHOULD decrease.
        /// 0 A value of 0 specifies that the brightness MUST NOT change.
        /// 0 < value ≤ 255 As the value increases, the brightness of the image SHOULD increase.
        let brightnessLevel: Int32 = try dataStream.read(endianess: .littleEndian)
        guard brightnessLevel >= -255 && brightnessLevel <= 255 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.brightnessLevel = brightnessLevel
        
        /// ContrastLevel (4 bytes): A signed integer that specifies the contrast level. This value MUST be in the range -100 through
        /// 100, with effects as follows:
        /// Value Meaning
        /// -100 ≤ value < 0 As the value decreases, the contrast of the image SHOULD decrease.
        /// 0 A value of 0 specifies that the contrast MUST NOT change.
        /// 0 < value ≤ 100 As the value increases, the contrast of the image SHOULD increase.
        let contrastLevel: Int32 = try dataStream.read(endianess: .littleEndian)
        guard contrastLevel >= -100 && contrastLevel <= 100 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.contrastLevel = contrastLevel
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
