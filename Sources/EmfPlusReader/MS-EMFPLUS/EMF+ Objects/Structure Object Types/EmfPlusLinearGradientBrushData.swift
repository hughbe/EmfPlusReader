//
//  EmfPlusLinearGradientBrushData.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.24 EmfPlusLinearGradientBrushData Object
/// The EmfPlusLinearGradientBrushData object specifies a linear gradient for a graphics brush.
/// Graphics brushes are specified by EmfPlusBrush objects. A linear gradient brush paints a color gradient in which the color changes
/// gradually along a gradient line from a starting boundary point to an ending boundary point, which are specified by the diagonal of a
/// rectangle in the RectF field.
/// Gamma correction controls the overall brightness and intensity of an image. Uncorrected images can look either bleached out or too
/// dark. Varying the amount of gamma correction changes not only the brightness but also the ratios of red to green to blue. The need
/// for gamma correction arises because an output device might not render colors in the same intensity as the input image.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusLinearGradientBrushData {
    public let brushDataFlags: BrushDataFlags
    public let wrapMode: WrapMode
    public let rectF: EmfPlusRectF
    public let startColor: EmfPlusARGB
    public let endColor: EmfPlusARGB
    public let reserved1: UInt32
    public let reserved2: UInt32
    public let optionalData: EmfPlusLinearGradientBrushOptionalData
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size >= 0x00000028 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// BrushDataFlags (4 bytes): An unsigned integer that specifies the data in the OptionalData field.
        /// This value MUST be composed of BrushData flags. The following flags are relevant to a linear gradient brush:
        /// Name Value
        /// BrushDataTransform 0x00000002
        /// BrushDataPresetColors 0x00000004
        /// BrushDataBlendFactorsH 0x00000008
        /// BrushDataBlendFactorsV 0x00000010
        /// BrushDataIsGammaCorrected 0x00000080
        self.brushDataFlags = try BrushDataFlags(dataStream: &dataStream)
        
        /// WrapMode (4 bytes): A signed integer from the WrapMode enumeration that specifies whether to paint the area outside
        /// the boundary of the brush. When painting outside the boundary, the wrap mode specifies how the color gradient is repeated.
        self.wrapMode = try WrapMode(dataStream: &dataStream)
        
        /// RectF (16 bytes): An EmfPlusRectF object that specifies the starting and ending points of the gradient line.
        /// The upper-left corner of the rectangle is the starting point. The lower-right corner is the ending point.
        self.rectF = try EmfPlusRectF(dataStream: &dataStream)
        
        /// StartColor (4 bytes): An EmfPlusARGB object, which specifies the color at the starting boundary point of the linear gradient
        /// brush.
        self.startColor = try EmfPlusARGB(dataStream: &dataStream)
        
        /// EndColor (4 bytes): An EmfPlusARGB object that specifies the color at the ending boundary point of the linear gradient brush.
        self.endColor = try EmfPlusARGB(dataStream: &dataStream)
        
        /// Reserved1 (4 bytes): This field is reserved and SHOULD<12> be ignored.
        self.reserved1 = try dataStream.read(endianess: .littleEndian)
        
        /// Reserved2 (4 bytes): This field is reserved and SHOULD<13> be ignored.
        self.reserved2 = try dataStream.read(endianess: .littleEndian)
        
        /// OptionalData (variable): An optional EmfPlusLinearGradientBrushOptionalData object that specifies additional data for
        /// the linear gradient brush. The specific contents of this field are determined by the value of the BrushDataFlags field.
        self.optionalData = try EmfPlusLinearGradientBrushOptionalData(dataStream: &dataStream, flags: self.brushDataFlags, size: size - 0x00000028)
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
