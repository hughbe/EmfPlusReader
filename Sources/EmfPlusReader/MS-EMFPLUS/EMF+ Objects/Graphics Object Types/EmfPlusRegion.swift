//
//  EmfPlusRegion.swift
//  
//
//  Created by Hugh Bellamy on 20/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.1.8 EmfPlusRegion Object
/// The EmfPlusRegion object specifies line and curve segments that define a nonrectilinear shape.
/// See section 2.2.1 for the specification of additional graphics objects.
public struct EmfPlusRegion {
    public let version: EmfPlusGraphicsVersion
    public let regionNodeCount: UInt32
    public let regionNode: EmfPlusRegionNode
    
    public init(dataStream: inout DataStream, dataSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard dataSize >= 8 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Version (4 bytes): An EmfPlusGraphicsVersion object that specifies the version of operating system graphics that was used
        /// to create this object.
        self.version = try EmfPlusGraphicsVersion(dataStream: &dataStream)
        
        /// RegionNodeCount (4 bytes): An unsigned integer that specifies the number of child nodes in the RegionNode field.
        self.regionNodeCount = try dataStream.read(endianess: .littleEndian)
        guard self.regionNodeCount < Int.max else {
            throw EmfPlusReadError.corrupted
        }
        
        /// RegionNode (variable): An array of RegionNodeCount+1 EmfPlusRegionNode objects. Regions are specified as a binary
        /// tree of region nodes, and each node MUST either be a terminal node or specify one or two child nodes. RegionNode
        /// MUST contain at least one element.
        let remainingSize = dataSize - UInt32(dataStream.position - startPosition)
        self.regionNode = try EmfPlusRegionNode(dataStream: &dataStream, availableSize: remainingSize)
        
        guard dataStream.position - startPosition == dataSize else {
            throw EmfPlusReadError.corrupted
        }
    }
}
