//
//  EmfPlusBlendColors.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.4 EmfPlusBlendColors Object
/// The EmfPlusBlendColors object specifies positions and colors for the blend pattern of a gradient brush.
/// Gradient brushes are specified by EmfPlusLinearGradientBrushData objects and EmfPlusPathGradientBrushData objects.
/// Blend patterns are used to smoothly shade the interiors of shapes filled by gradient brushes. and can be defined by arrays of
/// positions and colors or positions and factors. Positions and factors are specified by EmfPlusBlendFactors objects.
/// An EmfPlusBlendColors object MUST be present in the OptionalData field of an EmfPlusLinearGradientBrushData object, if the
/// BrushDataPresetColors flag is set in its BrushDataFlags field.
/// An EmfPlusBlendColors object MUST be present in the OptionalData field of an EmfPlusPathGradientBrushData object, if the
/// BrushDataPresetColors flag is set in its BrushDataFlags field.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusBlendColors {
    public let positionCount: UInt32
    public let blendPositions: [Float]
    public let blendColors: [EmfPlusARGB]
    
    public init(dataStream: inout DataStream, availableSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard availableSize >= 0x00000004 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// PositionCount (4 bytes): An unsigned integer that specifies the number of positions in the BlendPositions field and
        /// colors in the BlendColors field.
        self.positionCount = try dataStream.read(endianess: .littleEndian)
        guard 0x00000004 + self.positionCount * 0x00000004 + self.positionCount * 0x00000004 <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
        
        /// BlendPositions (variable): An array of PositionCount 32-bit floating-point values that specify proportions of distance
        /// along the gradient line.
        /// Each element MUST be a number between 0.0 and 1.0 inclusive. For a linear gradient brush, 0.0 represents the starting
        /// point and 1.0 represents the ending point. For a path gradient brush, 0.0 represents the midpoint and 1.0 represents an
        /// endpoint.
        var blendPositions: [Float] = []
        blendPositions.reserveCapacity(Int(self.positionCount))
        for _ in 0..<self.positionCount {
            let blendPosition = try dataStream.readFloat(endianess: .littleEndian)
            guard blendPosition >= 0.0 && blendPosition <= 1.0 else {
                throw EmfPlusReadError.corrupted
            }

            blendPositions.append(blendPosition)
        }
        
        self.blendPositions = blendPositions
        
        /// BlendColors (variable): An array of PositionCount EmfPlusARGB objects that specify colors at the positions defined in
        /// the BlendPositions field.
        var blendColors: [EmfPlusARGB] = []
        blendColors.reserveCapacity(Int(self.positionCount))
        for _ in 0..<self.positionCount {
            blendColors.append(try EmfPlusARGB(dataStream: &dataStream))
        }
        
        self.blendColors = blendColors
        
        guard dataStream.position - startPosition <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
    }
}
