//
//  EmfPlusLinearGradientBrushOptionalData.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.25 EmfPlusLinearGradientBrushOptionalData Object
/// The EmfPlusLinearGradientBrushOptionalData object specifies optional data for a linear gradient brush.
/// Note: Each field of this object is optional and might not be present in the OptionalData field of an EmfPlusLinearGradientBrushData
/// object, depending on the BrushData flags set in its BrushDataFlags field. Although it is not practical to represent every possible
/// combination of fields present or absent, this section specifies their relative order in the object. The implementer is responsible for
/// determining which fields are actually present in a given metafile record, and for unmarshaling the data for individual fields separately
/// and appropriately.
/// Graphics brushes are specified by EmfPlusBrush objects.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusLinearGradientBrushOptionalData {
    public let transformMatrix: EmfPlusTransformMatrix?
    public let presetColors: EmfPlusBlendColors?
    public let blendFactorsHorizontal: EmfPlusBlendFactors?
    public let blendFactorsVertical: EmfPlusBlendFactors?
    
    public init(dataStream: inout DataStream, flags: BrushDataFlags, size: UInt32) throws {
        let startPosition = dataStream.position
        var remainingSize = size
        
        /// TransformMatrix (24 bytes): An optional EmfPlusTransformMatrix object that specifies a world space to device space
        /// transform for the linear gradient brush. This field MUST be present if the BrushDataTransform flag is set in the
        /// BrushDataFlags field of the EmfPlusLinearGradientBrushData object.
        if flags.contains(.transform) {
            guard remainingSize >= 24 else {
                throw EmfPlusReadError.corrupted
            }
            
            self.transformMatrix = try EmfPlusTransformMatrix(dataStream: &dataStream)
            remainingSize = size - UInt32(dataStream.position - startPosition)
        } else {
            self.transformMatrix = nil
        }
        
        /// BlendPattern (variable): An optional blend pattern for the linear gradient brush. If this field is present, it MUST contain
        /// either an EmfPlusBlendColors object, or one or two EmfPlusBlendFactors objects, but it MUST NOT contain both.
        /// The table below shows the valid combinations of EmfPlusLinearGradientBrushData BrushData flags and the
        /// corresponding blend patterns:
        /// PresetColors BlendFactorsH BlendFactorsV Blend Pattern
        /// Clear Clear Clear This field MUST NOT be present in the EmfPlusLinearGradientBrushOptionalData object.
        /// Set Clear Clear An EmfPlusBlendColors object MUST be present.
        /// Clear Set Clear An EmfPlusBlendFactors object along the horizontal gradient line MUST be present.
        /// Clear Clear Set An EmfPlusBlendFactors object along the vertical gradient line MUST be present.<14>
        /// Clear Set Set An EmfPlusBlendFactors object along the vertical gradient line and an EmfPlusBlendFactors object along
        /// the horizontal gradient line MUST be present.<15>
        if flags.contains(.presetColors) {
            self.presetColors = try EmfPlusBlendColors(dataStream: &dataStream, availableSize: remainingSize)
            self.blendFactorsHorizontal = nil
            self.blendFactorsVertical = nil
            remainingSize = size - UInt32(dataStream.position - startPosition)
        } else {
            self.presetColors = nil
            if flags.contains(.blendFactorsH) {
                self.blendFactorsHorizontal = try EmfPlusBlendFactors(dataStream: &dataStream, availableSize: remainingSize)
                remainingSize = size - UInt32(dataStream.position - startPosition)
            } else {
                self.blendFactorsHorizontal = nil
            }
            if flags.contains(.blendFactorsV) {
                self.blendFactorsVertical = try EmfPlusBlendFactors(dataStream: &dataStream, availableSize: remainingSize)
                remainingSize = size - UInt32(dataStream.position - startPosition)
            } else {
                self.blendFactorsVertical = nil
            }
        }
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
