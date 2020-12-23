//
//  EmfPlusRegionNode.swift
//  
//
//  Created by Hugh Bellamy on 20/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.40 EmfPlusRegionNode Object
/// The EmfPlusRegionNode object specifies nodes of a graphics region.
/// Graphics regions are specified by EmfPlusRegion objects, which define a binary tree of region nodes.
/// Each node MUST either be a terminal node or specify additional region nodes.
/// This object is generic and is used to specify different types of region node data, including:
///  An EmfPlusRegionNodePath object, for a terminal node;
///  An EmfPlusRectF object, for a terminal node; and
///  An EmfPlusRegionNodeChildNodes object, for a non-terminal node.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusRegionNode {
    public let type: RegionNodeDataType
    public let regionNodeData: RegionNodeData
    
    public init(dataStream: inout DataStream, availableSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard availableSize >= 0x00000004 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Type (4 bytes): An unsigned integer that specifies the type of data in the RegionNodeData field.
        /// This value is defined in the RegionNodeDataType enumeration.
        self.type = try RegionNodeDataType(dataStream: &dataStream)
        
        /// RegionNodeData (variable): Optional, variable-length data that defines the region node data object specified in the Type field.
        /// The content and format of the data can be different for every region node type. This field MUST NOT be present if the node
        /// type is RegionNodeDataTypeEmpty or RegionNodeDataTypeInfinite.
        switch self.type {
        case .and,
             .or,
             .xor,
             .exclude,
             .complement:
            self.regionNodeData = .childNodes(try EmfPlusRegionNodeChildNodes(dataStream: &dataStream, availableSize: availableSize - 0x00000004))
        case .rect:
            self.regionNodeData = .rectangle(try EmfPlusRectF(dataStream: &dataStream))
        case .path:
            self.regionNodeData = .path(try EmfPlusRegionNodePath(dataStream: &dataStream))
        case .empty,
            .infinite:
            self.regionNodeData = .none
        }
        
        guard dataStream.position - startPosition <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    public indirect enum RegionNodeData {
        case none
        case path(_: EmfPlusRegionNodePath)
        case rectangle(_: EmfPlusRectF)
        case childNodes(_: EmfPlusRegionNodeChildNodes)
    }
}
