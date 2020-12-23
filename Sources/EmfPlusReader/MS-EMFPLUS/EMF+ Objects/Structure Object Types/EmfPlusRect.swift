//
//  EmfPlusRect.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.38 EmfPlusRect Object
/// The EmfPlusRect object specifies a rectangle origin, height, and width as 16-bit signed integers.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusRect {
    public let x: Int16
    public let y: Int16
    public let width: Int16
    public let height: Int16
    
    public init(dataStream: inout DataStream) throws {
        /// X (2 bytes): A signed integer that specifies the horizontal coordinate of the upper-left corner of the rectangle.
        self.x = try dataStream.read(endianess: .littleEndian)
        
        /// Y (2 bytes): A signed integer that specifies the vertical coordinate of the upper-left corner of the rectangle.
        self.y = try dataStream.read(endianess: .littleEndian)
        
        /// Width (2 bytes): A signed integer that specifies the width of the rectangle.
        self.width = try dataStream.read(endianess: .littleEndian)
        
        /// Height (2 bytes): A signed integer that specifies the height of the rectangle.
        self.height = try dataStream.read(endianess: .littleEndian)
    }
}
