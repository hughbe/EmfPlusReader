//
//  EmfPlusTextureBrushOptionalData.swift
//  
//
//  Created by Hugh Bellamy on 21/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.46 EmfPlusTextureBrushOptionalData Object
/// The EmfPlusTextureBrushOptionalData object specifies optional data for a texture brush.
/// Note: Each field of this object is optional and might not be present in the OptionalData field of an EmfPlusTextureBrushData object,
/// depending on the BrushData flags set in its BrushDataFlags field. Although it is not practical to represent every possible combination
/// of fields present or absent, this section specifies their relative order in the object. The implementer is responsible for determining
/// which fields are actually present in a given metafile record, and for unmarshaling the data for individual fields separately and
/// appropriately.
public struct EmfPlusTextureBrushOptionalData {
    public let transformMatrix: EmfPlusTransformMatrix?
    public let imageObject: EmfPlusImage?
    
    public init(dataStream: inout DataStream, flags: BrushDataFlags, size: UInt32) throws {
        let startPosition = dataStream.position
        
        var remainingSize = size
        
        /// TransformMatrix (24 bytes): An optional EmfPlusTransformMatrix object that specifies a world space to device space
        /// transform for the texture brush. This field MUST be present if the BrushDataTransform flag is set in the BrushDataFlags
        /// field of the EmfPlusTextureBrushData object.
        if flags.contains(.transform) {
            guard remainingSize >= 24 else {
                throw EmfPlusReadError.corrupted
            }

            self.transformMatrix = try EmfPlusTransformMatrix(dataStream: &dataStream)
            remainingSize = size - UInt32(dataStream.position - startPosition)
        } else {
            self.transformMatrix = nil
        }
        
        /// ImageObject (variable): An optional EmfPlusImage object that specifies the brush texture. This field MUST be present if
        /// the size of the EmfPlusObject record that defines this texture brush is large enough to accommodate an EmfPlusImage
        /// object in addition to the required fields of the EmfPlusTextureBrushData object and optionally an EmfPlusTransformMatrix
        /// object.
        if remainingSize > 0 {
            self.imageObject = try EmfPlusImage(dataStream: &dataStream, dataSize: remainingSize)
        } else {
            self.imageObject = nil
        }
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
