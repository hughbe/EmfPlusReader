//
//  EmfPlusPointF.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.36 EmfPlusPointF Object
/// The EmfPlusPointF object specifies an ordered pair of floating-point (X,Y) values that define an absolute location in a coordinate space.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusPointF {
    public let x: Float
    public let y: Float
    
    public init(dataStream: inout DataStream) throws {
        /// X (4 bytes): A floating-point value that specifies the horizontal coordinate.
        self.x = try dataStream.readFloat(endianess: .littleEndian)
        
        /// Y (4 bytes): A floating-point value that specifies the vertical coordinate
        self.y = try dataStream.readFloat(endianess: .littleEndian)
    }
}
