//
//  EmfPlusBlendFactors.swift
//
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.5 EmfPlusBlendFactors Object
/// The EmfPlusBlendFactors object specifies positions and factors for the blend pattern of a gradient brush.
/// For a linear gradient brush, 0.0 represents 0% starting color and 100% ending color, and 1.0 represents 100% starting color and
/// 0% ending color. For a path gradient brush, 0.0 represents 0% midpoint color and 100% endpoint color, and 1.0 represents 100%
/// midpoint color and 0% endpoint color.
/// For example, if a linear gradient brush specifies a position of 0.2 and a factor of 0.3 along a gradient line that is 100 pixels long,
/// the color that is 20 pixels along that line consists of 30 percent starting color and 70 percent ending color.
/// Gradient brushes are specified by EmfPlusLinearGradientBrushData objects and EmfPlusPathGradientBrushData objects.
/// Blend patterns are used to smoothly shade the interiors of shapes filled by gradient brushes. and can be defined by arrays of
/// positions and colors or positions and factors. Positions and colors are specified by EmfPlusBlendColors objects.
/// An EmfPlusBlendFactors object MUST be present in the OptionalData field of an EmfPlusLinearGradientBrushData or
/// EmfPlusPathGradientBrushData object if either of the flags BrushDataBlendFactorsH or BrushDataBlendFactorsV is set in its
/// BrushDataFlags field.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusBlendFactors {
    public let positionCount: UInt32
    public let blendPositions: [Float]
    public let blendFactors: [Float]
    
    public init(dataStream: inout DataStream, availableSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard availableSize >= 0x00000004 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// PositionCount (4 bytes): An unsigned integer that specifies the number of positions in the BlendPositions field and factors
        /// in the BlendFactors field.
        self.positionCount = try dataStream.read(endianess: .littleEndian)
        guard 0x00000004 + self.positionCount * 0x00000004 + self.positionCount * 0x00000004 <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
        
        /// BlendPositions (variable): An array of PositionCount 32-bit floating-point values that specify proportions of distance along
        /// the gradient line.
        /// Each value MUST be a number between 0.0 and 1.0 inclusive. There MUST be at least two positions specified: the first
        /// position, which is always 0.0f, and the last position, which is always 1.0f. Each position in BlendPositions is generally
        /// greater than the preceding position. For a linear gradient brush, 0.0 represents the starting point and 1.0 represents the
        /// ending point. For a path gradient brush, 0.0 represents the midpoint and 1.0 represents an endpoint.
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
        
        /// BlendFactors (variable): An array of PositionCount 32-bit floating point values that specify proportions of colors at the
        /// positions defined in the BlendPositions field. Each value MUST be a number between 0.0 and 1.0 inclusive.
        var blendFactors: [Float] = []
        blendFactors.reserveCapacity(Int(self.positionCount))
        for _ in 0..<self.positionCount {
            let blendFactor = try dataStream.readFloat(endianess: .littleEndian)
            guard blendFactor >= 0.0 && blendFactor <= 1.0 else {
                throw EmfPlusReadError.corrupted
            }

            blendFactors.append(blendFactor)
        }
        
        self.blendFactors = blendFactors
        
        guard dataStream.position - startPosition <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
    }
}
