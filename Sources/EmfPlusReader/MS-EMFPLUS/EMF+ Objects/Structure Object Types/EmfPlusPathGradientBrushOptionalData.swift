//
//  EmfPlusPathGradientBrushOptionalData.swift
//
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.30 EmfPlusPathGradientBrushOptionalData Object
/// The EmfPlusPathGradientBrushOptionalData object specifies optional data for a path gradient brush.
/// Note: Each field of this object is optional and might not be present in the OptionalData field of an EmfPlusPathGradientBrushData
/// object, depending on the BrushData flags set in its BrushDataFlags field. Although it is not practical to represent every possible
/// combination of fields present or absent, this section specifies their relative order in the object. The implementer is responsible for
/// determining which fields are actually present in a given metafile record, and for unmarshaling the data for individual fields separately
/// and appropriately.
/// Graphics brushes are specified by EmfPlusBrush objects.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusPathGradientBrushOptionalData {
    public let transformMatrix: EmfPlusTransformMatrix?
    public let presetColors: EmfPlusBlendColors?
    public let blendFactors: EmfPlusBlendFactors?
    public let focusScaleData: EmfPlusFocusScaleData?
    
    public init(dataStream: inout DataStream, flags: BrushDataFlags, size: UInt32) throws {
        let startPosition = dataStream.position
        var remainingSize = size
        
        /// TransformMatrix (24 bytes): An optional EmfPlusTransformMatrix object that specifies a world space to device space
        /// transform for the path gradient brush. This field MUST be present if the BrushDataTransform flag is set in the
        /// BrushDataFlags field of the EmfPlusPathGradientBrushData object.
        if flags.contains(.transform) {
            guard remainingSize >= 24 else {
                throw EmfPlusReadError.corrupted
            }
            
            self.transformMatrix = try EmfPlusTransformMatrix(dataStream: &dataStream)
            remainingSize = size - UInt32(dataStream.position - startPosition)
        } else {
            self.transformMatrix = nil
        }
        
        /// BlendPattern (variable): An optional blend pattern for the path gradient brush. If this field is present, it MUST contain
        /// either an EmfPlusBlendColors object, or an EmfPlusBlendFactors object, but it MUST NOT contain both. The table
        /// below shows the valid combinations of EmfPlusPathGradientBrushData BrushData flags and the corresponding blend
        /// patterns:
        /// PresetColors BlendFactorsH Blend Patterns
        /// Clear Clear This field MUST NOT be present.
        /// Set Clear An EmfPlusBlendColors object MUST be present.
        /// Clear Set An EmfPlusBlendFactors object MUST be present.
        if flags.contains(.presetColors) {
            self.presetColors = try EmfPlusBlendColors(dataStream: &dataStream, availableSize: remainingSize)
            self.blendFactors = nil
            remainingSize = size - UInt32(dataStream.position - startPosition)
        } else if flags.contains(.blendFactorsH) {
            self.presetColors = nil
            self.blendFactors = try EmfPlusBlendFactors(dataStream: &dataStream, availableSize: remainingSize)
            remainingSize = size - UInt32(dataStream.position - startPosition)
        } else {
            self.presetColors = nil
            self.blendFactors = nil
        }
        
        /// FocusScaleData (12 bytes): An optional EmfPlusFocusScaleData object that specifies focus scales for the path gradient
        /// brush. This field MUST be present if the BrushDataFocusScales flag is set in the BrushDataFlags field of the
        /// EmfPlusPathGradientBrushData object.
        if flags.contains(.focusScales) {
            guard remainingSize >= 0x0000000C else {
                throw EmfPlusReadError.corrupted
            }
            
            self.focusScaleData = try EmfPlusFocusScaleData(dataStream: &dataStream)
            remainingSize = size - UInt32(dataStream.position - startPosition)
        } else {
            self.focusScaleData = nil
        }
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
