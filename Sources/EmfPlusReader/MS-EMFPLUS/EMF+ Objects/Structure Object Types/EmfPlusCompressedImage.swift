//
//  EmfPlusCompressedImage.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.10 EmfPlusCompressedImage Object
/// The EmfPlusCompressedImage object specifies an image with compressed data.
/// Bitmaps are specified by EmfPlusBitmap objects. An EmfPlusCompressedImage object MUST be present in the BitmapData field
/// of an EmfPlusBitmap object if BitmapDataTypeCompressed is specified in its Type field.
/// This object is generic and is used for different types of compressed data, including:
///  Exchangeable Image File Format (EXIF) [EXIF];
///  Graphics Interchange Format (GIF) [GIF];
///  Joint Photographic Experts Group (JPEG) [JFIF];
///  Portable Network Graphics (PNG) [RFC2083] [W3C-PNG]; and
///  Tag Image File Format (TIFF) [RFC3302] [TIFF].
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusCompressedImage {
    public let compressedImageData: [UInt8]
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        /// CompressedImageData (variable): An array of bytes, which specify the compressed image. The type of compression is
        /// determined from the data itself.
        self.compressedImageData = try dataStream.readBytes(count: Int(size))
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
