//
//  EmfPlusRegionNodePath.swift
//  
//
//  Created by Hugh Bellamy on 20/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.42 EmfPlusRegionNodePath Object
/// The EmfPlusRegionNodePath object specifies a graphics path for drawing the boundary of a region node.
/// Region nodes are specified by EmfPlusRegion objects. An EmfPlusRegionNodePath object MUST be present in the RegionNodeData
/// field of an EmfPlusRegionNode object if its Type field is set to the RegionNodeDataTypePath value from the RegionNodeDataType
/// enumeration.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusRegionNodePath {
    public let regionNodePathLength: UInt32
    public let regionNodePath: EmfPlusPath
    
    public init(dataStream: inout DataStream) throws {
        /// RegionNodePathLength (4 bytes): A signed integer that specifies the length in bytes of the RegionNodePath field.
        self.regionNodePathLength = try dataStream.read(endianess: .littleEndian)
        
        let startPosition = dataStream.position
        
        /// RegionNodePath (variable): An EmfPlusPath object that specifies the boundary of the region node.
        self.regionNodePath = try EmfPlusPath(dataStream: &dataStream, dataSize: self.regionNodePathLength)
        
        guard dataStream.position - startPosition == self.regionNodePathLength else {
            throw EmfPlusReadError.corrupted
        }
    }
}
