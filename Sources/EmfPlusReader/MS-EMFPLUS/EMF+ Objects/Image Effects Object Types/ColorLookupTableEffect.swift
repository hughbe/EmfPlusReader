//
//  ColorLookupTableEffect.swift
//
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.3.5 ColorLookupTableEffect Object
/// The ColorLookupTableEffect object specifies adjustments to the colors in an image.
/// Bitmap images are specified by EmfPlusBitmap objects.
/// See section 2.2.3 for the specification of additional image effects parameter objects.
public struct ColorLookupTableEffect {
    public let blueLookupTable: [UInt8]
    public let greenLookupTable: [UInt8]
    public let redLookupTable: [UInt8]
    public let alphaLookupTable: [UInt8]
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size == 0x00000400 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// BlueLookupTable (256 bytes): An array of 256 bytes that specifies the adjustment for the blue color channel.
        self.blueLookupTable = try dataStream.readBytes(count: 256)
        
        /// GreenLookupTable (256 bytes): An array of 256 bytes that specifies the adjustment for the green color channel.
        self.greenLookupTable = try dataStream.readBytes(count: 256)
        
        /// RedLookupTable (256 bytes): An array of 256 bytes that specifies the adjustment for the red color channel.
        self.redLookupTable = try dataStream.readBytes(count: 256)
        
        /// AlphaLookupTable (256 bytes): An array of 256 bytes that specifies the adjustment for the alpha color channel.
        self.alphaLookupTable = try dataStream.readBytes(count: 256)
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
