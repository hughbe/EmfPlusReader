//
//  BitmapDataType.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.2 BitmapDataType Enumeration
/// The BitmapDataType enumeration defines types of bitmap data formats.
/// typedef enum
/// {
///  BitmapDataTypePixel = 0x00000000,
///  BitmapDataTypeCompressed = 0x00000001
/// } BitmapDataType;
/// Bitmap data is specified by EmfPlusBitmap objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum BitmapDataType: UInt32, DataStreamCreatable {
    /// BitmapDataTypePixel: Specifies a bitmap image with pixel data.
    case pixel = 0x00000000

    /// BitmapDataTypeCompressed: Specifies an image with compressed data.
    case compressed = 0x00000001
}
