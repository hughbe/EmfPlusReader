//
//  EmfPlusTextureBrushData.swift
//  
//
//  Created by Hugh Bellamy on 21/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.45 EmfPlusTextureBrushData Object
/// The EmfPlusTextureBrushData object specifies a texture image for a graphics brush.
/// Graphics brushes are specified by EmfPlusBrush objects. A texture brush paints an image, which in this context is called a "texture".
/// The texture consists of either a portion of an image or a scaled version of an image, which is specified by an EmfPlusImage object
/// in the OptionalData field.
/// Gamma correction controls the overall brightness and intensity of an image. Uncorrected images can look either bleached out or
/// too dark. Varying the amount of gamma correction changes not only the brightness but also the ratios of red to green to blue. The
/// need for gamma correction arises because an output device might not render colors in the same intensity as the input image.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusTextureBrushData {
    public let brushDataFlags: BrushDataFlags
    public let wrapMode: WrapMode
    public let optionalData: EmfPlusTextureBrushOptionalData
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size >= 0x00000008 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// BrushDataFlags (4 bytes): An unsigned integer that specifies the data in the OptionalData field.
        /// This value MUST be composed of BrushData flags. The following flags are relevant to a texture brush:
        /// Name Value
        /// BrushDataTransform 0x00000002
        /// BrushDataIsGammaCorrected 0x00000080
        /// BrushDataDoNotTransform 0x00000100
        self.brushDataFlags = try BrushDataFlags(dataStream: &dataStream)
        
        /// WrapMode (4 bytes): A signed integer from the WrapMode enumeration that specifies how to repeat the texture image
        /// across a shape, when the image is smaller than the area being filled.
        self.wrapMode = try WrapMode(dataStream: &dataStream)
        
        /// OptionalData (variable): An optional EmfPlusTextureBrushOptionalData object that specifies additional data for the texture
        /// brush. The specific contents of this field are determined by the value of the BrushDataFlags field.
        self.optionalData = try EmfPlusTextureBrushOptionalData(dataStream: &dataStream, flags: self.brushDataFlags, size: size - 0x00000008)
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
