//
//  EmfPlusBoundaryPathData.swift
//
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.6 EmfPlusBoundaryPathData Object
/// The EmfPlusBoundaryPathData object specifies a graphics path boundary for a gradient brush.
/// Boundary path data is specified in the BoundaryData field of an EmfPlusPathGradientBrushData object.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusBoundaryPathData {
    public let boundaryPathSize: UInt32
    public let boundaryPathData: EmfPlusPath
    
    public init(dataStream: inout DataStream, availableSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard availableSize >= 0x00000004 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// BoundaryPathSize (4 bytes): A signed integer that specifies the size in bytes of the BoundaryPathData field.
        self.boundaryPathSize = try dataStream.read(endianess: .littleEndian)
        guard 0x00000004 + self.boundaryPathSize <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataStartPosition = dataStream.position
        
        /// BoundaryPathData (variable): An EmfPlusPath object, which specifies the boundary of the brush.
        self.boundaryPathData = try EmfPlusPath(dataStream: &dataStream, dataSize: self.boundaryPathSize)
        
        guard dataStream.position - startPosition <= availableSize &&
                dataStream.position - dataStartPosition == self.boundaryPathSize else {
            throw EmfPlusReadError.corrupted
        }
    }
}
