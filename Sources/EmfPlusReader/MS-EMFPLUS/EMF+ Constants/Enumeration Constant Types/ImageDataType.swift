//
//  ImageDataType.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.15 ImageDataType Enumeration
/// The ImageDataType enumeration defines types of image data formats.
/// typedef enum
/// {
///  ImageDataTypeUnknown = 0x00000000,
///  ImageDataTypeBitmap = 0x00000001,
///  ImageDataTypeMetafile = 0x00000002
/// } ImageDataType;
/// Graphics images are specified by EmfPlusImage objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum ImageDataType: UInt32, DataStreamCreatable {
    /// ImageDataTypeUnknown: The type of image is not known.
    case unknown = 0x00000000
    
    /// ImageDataTypeBitmap: Specifies a bitmap image.
    case bitmap = 0x00000001
    
    /// ImageDataTypeMetafile: Specifies a metafile image.
    case metafile = 0x00000002
}
