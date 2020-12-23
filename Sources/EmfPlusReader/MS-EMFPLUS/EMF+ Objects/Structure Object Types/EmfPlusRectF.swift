//
//  EmfPlusRectF.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.39 EmfPlusRectF Object
/// The EmfPlusRectF object specifies a rectangle's origin, height, and width as 32-bit floating-point values.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusRectF {
    public let x: Float
    public let y: Float
    public let width: Float
    public let height: Float
    
    public init(dataStream: inout DataStream) throws {
        /// X (4 bytes): A floating-point value that specifies the horizontal coordinate of the upper-left corner of the rectangle.
        self.x = try dataStream.readFloat(endianess: .littleEndian)
        
        /// Y (4 bytes): A floating-point value that specifies the vertical coordinate of the upper-left corner of the rectangle.
        self.y = try dataStream.readFloat(endianess: .littleEndian)
        
        /// Width (4 bytes): A floating-point value that specifies the width of the rectangle.
        self.width = try dataStream.readFloat(endianess: .littleEndian)
        
        /// Height (4 bytes): A floating-point value that specifies the height of the rectangle.
        self.height = try dataStream.readFloat(endianess: .littleEndian)
    }
}
