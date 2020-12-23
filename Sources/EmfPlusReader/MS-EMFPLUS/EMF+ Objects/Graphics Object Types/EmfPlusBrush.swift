//
//  EmfPlusBrush.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.1.1 EmfPlusBrush Object
/// The EmfPlusBrush object specifies a graphics brush for filling regions.
public struct EmfPlusBrush {
    public let version: EmfPlusGraphicsVersion
    public let type: BrushType
    public let brushData: BrushData
    
    public init(dataStream: inout DataStream, dataSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard dataSize >= 0x00000008 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Version (4 bytes): An EmfPlusGraphicsVersion object that specifies the version of operating system graphics that was
        /// used to create this object.
        self.version = try EmfPlusGraphicsVersion(dataStream: &dataStream)
        
        /// Type (4 bytes): An unsigned integer that specifies the type of brush, which determines the contents of the BrushData field.
        /// This value is defined in the BrushType enumeration.
        self.type = try BrushType(dataStream: &dataStream)
        
        /// BrushData (variable): Variable-length data that defines the brush object specified in the Type field. The content and format
        /// of the data can be different for every brush type.
        switch self.type {
        case .solidColor:
            self.brushData = .solidColor(try EmfPlusSolidBrushData(dataStream: &dataStream, size: dataSize - 0x00000008))
        case .hatchFill:
            self.brushData = .hatchFill(try EmfPlusHatchBrushData(dataStream: &dataStream, size: dataSize - 0x00000008))
        case .textureFill:
            self.brushData = .textureFill(try EmfPlusTextureBrushData(dataStream: &dataStream, size: dataSize - 0x00000008))
        case .pathGradient:
            self.brushData = .pathGradient(try EmfPlusPathGradientBrushData(dataStream: &dataStream, size: dataSize - 0x00000008))
        case .linearGradient:
            self.brushData = .linearGradient(try EmfPlusLinearGradientBrushData(dataStream: &dataStream, size: dataSize - 0x00000008))
        }
        
        guard dataStream.position - startPosition == dataSize else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    public enum BrushData {
        case solidColor(_: EmfPlusSolidBrushData)
        case hatchFill(_: EmfPlusHatchBrushData)
        case textureFill(_: EmfPlusTextureBrushData)
        case pathGradient(_: EmfPlusPathGradientBrushData)
        case linearGradient(_: EmfPlusLinearGradientBrushData)
    }
}
