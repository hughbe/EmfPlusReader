//
//  EmfPlusBitmap.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.2 EmfPlusBitmap Object
/// The EmfPlusBitmap object specifies a bitmap that contains a graphics image.
/// Graphics images are specified by EmfPlusImage objects. An EmfPlusBitmap object MUST be present in the ImageData field of an
/// EmfPlusImage object if ImageTypeBitmap is specified in its Type field.
/// This object is generic and is used to specify different types of bitmap data, including:
///  An EmfPlusBitmapData object.
///  An EmfPlusCompressedImage object; and
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusBitmap {
    public let width: Int32
    public let height: Int32
    public let stride: Int32
    public let pixelFormat: PixelFormat
    public let type: BitmapDataType
    public let bitmapData: BitmapData
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size >= 20 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Width (4 bytes): A signed integer that specifies the width in pixels of the area occupied by the bitmap.
        /// If the image is compressed, according to the Type field, this value is undefined and MUST be ignored.
        self.width = try dataStream.read(endianess: .littleEndian)
        
        /// Height (4 bytes): A signed integer that specifies the height in pixels of the area occupied by the bitmap.
        /// If the image is compressed, according to the Type field, this value is undefined and MUST be ignored.
        self.height = try dataStream.read(endianess: .littleEndian)
        
        /// Stride (4 bytes): A signed integer that specifies the byte offset between the beginning of one scanline and the next.
        /// This value is the number of bytes per pixel, which is specified in the PixelFormat field, multiplied by the width in pixels,
        /// which is specified in the Width field. The value of this field MUST be a multiple of four.
        /// If the image is compressed, according to the Type field, this value is undefined and MUST be ignored.
        self.stride = try dataStream.read(endianess: .littleEndian)
        
        /// PixelFormat (4 bytes): An unsigned integer that specifies the format of the pixels that make up the bitmap image.
        /// The supported pixel formats are specified in the PixelFormat enumeration.
        /// If the image is compressed, according to the Type field, this value is undefined and MUST be ignored.
        /// X (1 bit): Reserved and MUST be ignored.
        /// N (1 bit): If set, the pixel format is "canonical", which means that 32 bits per pixel are supported, with 24-bits for color
        /// components and an 8-bit alpha channel.
        /// If clear, the pixel format is not canonical.
        /// E (1 bit): If set, the pixel format supports extended colors in 16-bits per channel.
        /// If clear, extended colors are not supported.
        /// P (1 bit): If set, each color component in the pixel has been premultiplied by the pixel's alpha transparency value.
        /// If clear, each color component is multiplied by the pixel's alpha transparency value when the source pixel is blended with
        /// the destination pixel.
        /// A (1 bit): If set, the pixel format includes an alpha transparency component.
        /// If clear, the pixel format does not include a component that specifies transparency.
        /// G (1 bit): If set, the pixel format is supported in Windows GDI.
        /// If clear, the pixel format is not supported in Windows GDI.
        /// I (1 bit): If set, the pixel values are indexes into a palette.
        /// If clear, the pixel values are actual colors.
        /// BitsPerPixel (1 byte): The total number of bits per pixel.
        /// Index (1 byte): The pixel format enumeration index.
        self.pixelFormat = try PixelFormat(dataStream: &dataStream)
        
        /// Type (4 bytes): An unsigned integer that specifies the type of data in the BitmapData field. This value is defined in the
        /// BitmapDataType enumeration.
        self.type = try BitmapDataType(dataStream: &dataStream)
        
        /// BitmapData (variable): Variable-length data that defines the bitmap data object specified in the Type field. The content and
        /// format of the data can be different for every bitmap type.
        let remainingCount = size - UInt32(dataStream.position - startPosition)
        switch type {
        case .compressed:
            self.bitmapData = .compressed(try EmfPlusCompressedImage(dataStream: &dataStream, size: remainingCount))
        case .pixel:
            self.bitmapData = .pixel(try EmfPlusBitmapData(dataStream: &dataStream, pixelFormat: self.pixelFormat, size: remainingCount))
        }
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// BitmapData (variable): Variable-length data that defines the bitmap data object specified in the Type field. The content and
    /// format of the data can be different for every bitmap type.
    public enum BitmapData {
        case compressed(_: EmfPlusCompressedImage)
        case pixel(_: EmfPlusBitmapData)
    }
}
