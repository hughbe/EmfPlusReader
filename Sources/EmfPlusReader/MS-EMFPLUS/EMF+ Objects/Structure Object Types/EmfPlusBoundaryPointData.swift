//
//  EmfPlusBoundaryPointData.swift
//
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.7 EmfPlusBoundaryPointData Object
/// The EmfPlusBoundaryPointData object specifies a closed cardinal spline boundary for a gradient brush.
/// Boundary point data is specified in the BoundaryData field of an EmfPlusPathGradientBrushData object.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusBoundaryPointData {
    public let boundaryPointCount: UInt32
    public let boundaryPointData: [EmfPlusPointF]
    
    public init(dataStream: inout DataStream, availableSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard availableSize >= 0x00000004 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// BoundaryPointCount (4 bytes): A signed integer that specifies the number of points in the BoundaryPointData field.
        self.boundaryPointCount = try dataStream.read(endianess: .littleEndian)
        guard 0x00000004 + self.boundaryPointCount * 0x00000008 <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
                
        /// BoundaryPointData (variable): An array of BoundaryPointCount EmfPlusPointF objects that specify the boundary of the brush.
        var boundaryPointData: [EmfPlusPointF] = []
        boundaryPointData.reserveCapacity(Int(self.boundaryPointCount))
        for _ in 0..<self.boundaryPointCount {
            boundaryPointData.append(try EmfPlusPointF(dataStream: &dataStream))
        }
        
        self.boundaryPointData = boundaryPointData
        
        guard dataStream.position - startPosition <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
    }
}
