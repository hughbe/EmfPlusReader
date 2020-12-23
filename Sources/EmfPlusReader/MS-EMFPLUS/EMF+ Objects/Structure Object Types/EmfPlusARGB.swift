//
//  EmfPlusARGB.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.1 EmfPlusARGB Object
/// The EmfPlusARGB object specifies a color as a combination of red, green, blue. and alpha.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusARGB {
    public let blue: UInt8
    public let green: UInt8
    public let red: UInt8
    public let alpha: UInt8
    
    public init(dataStream: inout DataStream) throws {
        /// Blue (1 byte): An unsigned integer that specifies the relative intensity of blue.
        self.blue = try dataStream.read()
        
        /// Green (1 byte): An unsigned integer that specifies the relative intensity of green.
        self.green = try dataStream.read()
        
        /// Red (1 byte): An unsigned integer that specifies the relative intensity of red.
        self.red = try dataStream.read()
        
        /// Alpha (1 byte): An unsigned integer that specifies the transparency of the background, ranging from 0 for completely
        /// transparent to 0xFF for completely opaque.
        self.alpha = try dataStream.read()
    }
}
