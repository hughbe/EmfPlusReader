//
//  PixelFormat.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.24 PixelFormat Enumeration
/// The PixelFormat enumeration defines pixel formats that are supported in EMF+ bitmaps.
/// typedef enum
/// {
///  PixelFormatUndefined = 0x00000000,
///  PixelFormat1bppIndexed = 0x00030101,
///  PixelFormat4bppIndexed = 0x00030402,
///  PixelFormat8bppIndexed = 0x00030803,
///  PixelFormat16bppGrayScale = 0x00101004,
///  PixelFormat16bppRGB555 = 0x00021005,
///  PixelFormat16bppRGB565 = 0x00021006,
///  PixelFormat16bppARGB1555 = 0x00061007,
///  PixelFormat24bppRGB = 0x00021808,
///  PixelFormat32bppRGB = 0x00022009,
///  PixelFormat32bppARGB = 0x0026200A,
///  PixelFormat32bppPARGB = 0x000E200B,
///  PixelFormat48bppRGB = 0x0010300C,
///  PixelFormat64bppARGB = 0x0034400D,
///  PixelFormat64bppPARGB = 0x001A400E
/// } PixelFormat;
/// Pixel formats are specified by EmfPlusBitmap objects. They are encoded as follows:
///  Bits 0-7: Enumeration of the pixel format constants, starting at zero.
///  Bits 8-15: The total number of bits per pixel.
///  Bit 16: If set, the color value is indexed into a palette.
///  Bit 17: If set, the color value is in a GDI-supported format.
///  Bit 18: If set, the color value has an alpha component.
///  Bit 19: If set, the color value has a premultiplied alpha component.
///  Bit 20: If set, extended colors, 16-bits per channel, are supported.
///  Bits 21-31: Reserved.
/// See section 2.1.1 for the specification of additional enumerations.
public enum PixelFormat: UInt32, DataStreamCreatable {
    /// PixelFormatUndefined: The format is not specified.
    case undefined = 0x00000000
    
    /// PixelFormat1bppIndexed: The format is monochrome, and a color palette lookup table is used.
    case PixelFormat1bppIndexed = 0x00030101
    
    /// PixelFormat4bppIndexed: The format is 16-color, and a color palette lookup table is used.
    case PixelFormat4bppIndexed = 0x00030402
    
    /// PixelFormat8bppIndexed: The format is 256-color, and a color palette lookup table is used.
    case PixelFormat8bppIndexed = 0x00030803
    
    /// PixelFormat16bppGrayScale: The format is 16 bits per pixel, grayscale.
    case PixelFormat16bppGrayScale = 0x00101004
    
    /// PixelFormat16bppRGB555: The format is 16 bits per pixel; 5 bits each are used for the red, green, and blue components.
    /// The remaining bit is not used.
    case PixelFormat16bppRGB555 = 0x00021005
    
    /// PixelFormat16bppRGB565: The format is 16 bits per pixel; 5 bits are used for the red component, 6 bits for the green
    /// component, and 5 bits for the blue component.
    case PixelFormat16bppRGB565 = 0x00021006
    
    /// PixelFormat16bppARGB1555: The format is 16 bits per pixel; 1 bit is used for the alpha component, and 5 bits each are used
    /// for the red, green, and blue components.
    case PixelFormat16bppARGB1555 = 0x00061007
    
    /// PixelFormat24bppRGB: The format is 24 bits per pixel; 8 bits each are used for the red, green, and blue components.
    case PixelFormat24bppRGB = 0x00021808
    
    /// PixelFormat32bppRGB: The format is 32 bits per pixel; 8 bits each are used for the red, green, and blue components.
    /// The remaining 8 bits are not used.
    case PixelFormat32bppRGB = 0x00022009
    
    /// PixelFormat32bppARGB: The format is 32 bits per pixel; 8 bits each are used for the alpha, red, green, and blue components.
    case PixelFormat32bppARGB = 0x0026200A
    
    /// PixelFormat32bppPARGB: The format is 32 bits per pixel; 8 bits each are used for the alpha, red, green, and blue components.
    /// The red, green, and blue components are premultiplied according to the alpha component.
    case PixelFormat32bppPARGB = 0x000E200B
    
    /// PixelFormat48bppRGB: The format is 48 bits per pixel; 16 bits each are used for the red, green, and blue components.
    case PixelFormat48bppRGB = 0x0010300C
    
    /// PixelFormat64bppARGB: The format is 64 bits per pixel; 16 bits each are used for the alpha, red, green, and blue components.
    case PixelFormat64bppARGB = 0x0034400D
    
    /// PixelFormat64bppPARGB: The format is 64 bits per pixel; 16 bits each are used for the alpha, red, green, and blue components.
    /// The red, green, and blue components are premultiplied according to the alpha component.
    case PixelFormat64bppPARGB = 0x001A400E
    
    public var indexed: Bool {
        (rawValue & 0x00010000) != 0
    }
}
