//
//  EmfPlusBitmapData.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.3 EmfPlusBitmapData Object
/// The EmfPlusBitmapData object specifies a bitmap image with pixel data.
/// Bitmaps are specified by EmfPlusBitmap objects. An EmfPlusBitmapData object MUST be present in the BitmapData field of an
/// EmfPlusBitmap object if BitmapDataTypePixel is specified in its Type field.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusBitmapData {
    public let colors: EmfPlusPalette?
    public let pixelData: [UInt8]
    
    public init(dataStream: inout DataStream, pixelFormat: PixelFormat, size: UInt32) throws {
        let startPosition = dataStream.position
        
        /// Colors (variable): An optional EmfPlusPalette object, which specifies the palette of colors used in the pixel data.
        /// This field MUST be present if the I flag is set in the PixelFormat field of the EmfPlusBitmap object.
        if pixelFormat.indexed {
            self.colors = try EmfPlusPalette(dataStream: &dataStream, availableSize: size)
        } else {
            self.colors = nil
        }
        
        /// PixelData (variable): An array of bytes that specify the pixel data. The size and format of this data can be computed from
        /// fields in the EmfPlusBitmap object, including the pixel format from the PixelFormat enumeration.
        let remainingSize = size - UInt32(dataStream.position - startPosition)
        self.pixelData = try dataStream.readBytes(count: Int(remainingSize))
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
