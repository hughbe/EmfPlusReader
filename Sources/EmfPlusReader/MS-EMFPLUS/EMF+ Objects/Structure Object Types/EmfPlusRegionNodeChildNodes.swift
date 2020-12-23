//
//  EmfPlusRegionNodeChildNodes.swift
//  
//
//  Created by Hugh Bellamy on 20/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.41 EmfPlusRegionNodeChildNodes Object
/// The EmfPlusRegionNodeChildNodes object specifies child nodes of a graphics region node.
/// Graphics region nodes are specified with EmfPlusRegionNode objects.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusRegionNodeChildNodes {
    public let left: EmfPlusRegionNode
    public let right: EmfPlusRegionNode
    
    public init(dataStream: inout DataStream, availableSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard availableSize >= 0x00000008 else {
            throw EmfPlusReadError.corrupted
        }
        
        var remainingSize = availableSize
        
        /// Left (variable): An EmfPlusRegionNode object that specifies the left child node of this region node.
        self.left = try EmfPlusRegionNode(dataStream: &dataStream, availableSize: remainingSize)
        remainingSize = availableSize - UInt32(dataStream.position - startPosition)
        
        /// Right (variable): An EmfPlusRegionNode object that defines the right child node of this region node.
        self.right = try EmfPlusRegionNode(dataStream: &dataStream, availableSize: remainingSize)
        
        guard dataStream.position - startPosition <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
    }
}
