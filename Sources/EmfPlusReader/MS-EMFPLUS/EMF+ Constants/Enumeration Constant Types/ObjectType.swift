//
//  ObjectType.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.21 ObjectType Enumeration
/// The ObjectType enumeration defines types of graphics objects that can be created and used in graphics operations.
/// typedef enum
/// {
///  ObjectTypeInvalid = 0x00000000,
///  ObjectTypeBrush = 0x00000001,
///  ObjectTypePen = 0x00000002,
///  ObjectTypePath = 0x00000003,
///  ObjectTypeRegion = 0x00000004,
///  ObjectTypeImage = 0x00000005,
///  ObjectTypeFont = 0x00000006,
///  ObjectTypeStringFormat = 0x00000007,
///  ObjectTypeImageAttributes = 0x00000008,
///  ObjectTypeCustomLineCap = 0x00000009
/// } ObjectType;
/// Graphics objects are specified by EmfPlusObject records.
/// See section 2.1.1 for the specification of additional enumerations.
public enum ObjectType: UInt32, DataStreamCreatable {
    /// ObjectTypeInvalid: The object is not a valid object.
    case invalid = 0x00000000
    
    /// ObjectTypeBrush: Specifies an EmfPlusBrush object. Brush objects fill graphics regions.
    case brush = 0x00000001
    
    /// ObjectTypePen: Specifies an EmfPlusPen object. Pen objects draw graphics lines.
    case pen = 0x00000002
    
    /// ObjectTypePath: Specifies an EmfPlusPath object. Path objects specify sequences of lines, curves, and shapes.
    case path = 0x00000003
    
    /// ObjectTypeRegion: Specifies an EmfPlusRegion object. Region objects specify areas of the output surface.
    case region = 0x00000004
    
    /// ObjectTypeImage: Specifies an EmfPlusImage object. Image objects encapsulate bitmaps and metafiles.
    case image = 0x00000005
    
    /// ObjectTypeFont: Specifies an EmfPlusFont object. Font objects specify font properties, including typeface style, em size, and
    /// font family.
    case font = 0x00000006
    
    /// ObjectTypeStringFormat: Specifies an EmfPlusStringFormat object. String format objects specify text layout, including
    /// alignment, orientation, tab stops, clipping, and digit substitution for languages that do not use Western European digits.
    case stringFormat = 0x00000007
    
    /// ObjectTypeImageAttributes: Specifies an EmfPlusImageAttributes object. Image attribute objects specify operations on pixels
    /// during image rendering, including color adjustment, grayscale adjustment, gamma correction, and color mapping.
    case imageAttributes = 0x00000008
    
    /// ObjectTypeCustomLineCap: Specifies an EmfPlusCustomLineCap object. Custom line cap objects specify shapes to draw at
    /// the ends of a graphics line, including squares, circles, and diamonds.
    case customLineCap = 0x00000009
}
