//
//  ColorCurveEffect.swift
//
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.3.4 ColorCurveEffect Object
/// The ColorCurveEffect object specifies one of eight adjustments to the color curve of an image
/// Bitmap images are specified by EmfPlusBitmap objects.
/// See section 2.2.3 for the specification of additional image effects parameter objects.
public struct ColorCurveEffect {
    public let curveAdjustment: CurveAdjustments
    public let curveChannel: CurveChannel
    public let adjustmentIntensity: Int32
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size == 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        /// CurveAdjustment (4 bytes): An unsigned integer that specifies the curve adjustment to apply to the colors in bitmap.
        /// This value is defined in the CurveAdjustments enumeration.
        self.curveAdjustment = try CurveAdjustments(dataStream: &dataStream)
        
        /// CurveChannel (4 bytes): An unsigned integer that specifies the color channel to which the curve adjustment applies.
        /// This value is defined in the CurveChannel enumeration.
        self.curveChannel = try CurveChannel(dataStream: &dataStream)
        
        /// AdjustmentIntensity (4 bytes): A signed integer that specifies the intensity of the curve adjustment to the color channel
        /// specified by CurveChannel. The ranges of meaningful values for this field vary according to the CurveAdjustment value,
        /// as follows:
        /// Exposure adjustment range:
        /// Value Meaning
        /// -255 ≤ value < 0 As the value decreases, the exposure of the image SHOULD decrease.
        /// 0 A value of 0 specifies that the exposure MUST NOT change.
        /// 0 < value ≤ 255 As the value increases, the exposure of the image SHOULD increase.
        /// Density adjustment range:
        /// Value Meaning
        /// -
        /// 255 ≤ value < 0
        /// As the value decreases, the density of the image SHOULD decrease, resulting in a darker
        /// image.
        /// 0 A value of 0 specifies that the density MUST NOT change.
        /// 0 < value ≤ 255 As the value increases, the density of the image SHOULD increase.
        /// Contrast adjustment range:
        /// Value Meaning
        /// -100 ≤ value < 0 As the value decreases, the contrast of the image SHOULD decrease.
        /// 0 A value of 0 specifies that the contrast MUST NOT change.
        /// 0 < value ≤ 100 As the value increases, the contrast of the image SHOULD increase.
        /// Highlight adjustment range:
        /// Value Meaning
        /// -100 ≤ value < 0 As the value decreases, the light areas of the image SHOULD appear darker.
        /// 0 A value of 0 specifies that the highlight MUST NOT change.
        /// 0 < value ≤ 100 As the value increases, the light areas of the image SHOULD appear lighter.
        /// Shadow adjustment range:
        /// Value Meaning
        /// -100 ≤ value < 0 As the value decreases, the dark areas of the image SHOULD appear darker.
        /// 0 A value of 0 specifies that the shadow MUST NOT change.
        /// 0 < value ≤ 100 As the value increases, the dark areas of the image SHOULD appear lighter.
        /// White saturation adjustment range:
        /// Value Meaning
        /// 0 — 255 As the value increases, the upper limit of the range of color channel intensities
        /// increases.
        /// Black saturation adjustment range:
        /// 0 — 255 As the value increases, the lower limit of the range of color channel intensities
        /// increases.
        self.adjustmentIntensity = try dataStream.read(endianess: .littleEndian)
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
