//
//  EmfPlusPoint.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.35 EmfPlusPoint Object
/// The EmfPlusPoint object specifies an ordered pair of integer (X,Y) values that define an absolute location in a coordinate space.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusPoint {
    public let x: Int16
    public let y: Int16
    
    public init(dataStream: inout DataStream) throws {
        /// X (2 bytes): A signed integer that defines the horizontal coordinate.
        self.x = try dataStream.read(endianess: .littleEndian)
        
        /// Y (2 bytes): A signed integer that defines the vertical coordinate.
        self.y = try dataStream.read(endianess: .littleEndian)
    }
}
