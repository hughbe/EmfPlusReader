//
//  LineCapType.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.17 LineCapType Enumeration
/// The LineCapType enumeration defines types of line caps to use at the ends of lines that are drawn with graphics pens.
/// typedef enum
/// {
///  LineCapTypeFlat = 0x00000000,
///  LineCapTypeSquare = 0x00000001,
///  LineCapTypeRound = 0x00000002,
///  LineCapTypeTriangle = 0x00000003,
///  LineCapTypeNoAnchor = 0x00000010,
///  LineCapTypeSquareAnchor = 0x00000011,
///  LineCapTypeRoundAnchor = 0x00000012,
///  LineCapTypeDiamondAnchor = 0x00000013,
///  LineCapTypeArrowAnchor = 0x00000014,
///  LineCapTypeAnchorMask = 0x000000F0,
///  LineCapTypeCustom = 0x000000FF
/// } LineCapType;
/// Graphics line caps are specified by EmfPlusPen objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum LineCapType: UInt32, DataStreamCreatable {
    /// LineCapTypeFlat: Specifies a squared-off line cap. The end of the line MUST be the last point in the line.
    case flat = 0x00000000
    
    /// LineCapTypeSquare: Specifies a square line cap. The center of the square MUST be located at the last point in the line.
    /// The width of the square is the line width.
    case square = 0x00000001
    
    /// LineCapTypeRound: Specifies a circular line cap. The center of the circle MUST be located at the last point in the line.
    /// The diameter of the circle is the line width.
    case round = 0x00000002
    
    /// LineCapTypeTriangle: Specifies a triangular line cap. The base of the triangle MUST be located at the last point in the line.
    /// The base of the triangle is the line width.
    case triangle = 0x00000003

    /// LineCapTypeNoAnchor: Specifies that the line end is not anchored.
    case noAnchor = 0x00000010
    
    /// LineCapTypeSquareAnchor: Specifies that the line end is anchored with a square line cap. The center of the square MUST be
    /// located at the last point in the line. The height and width of the square are the line width.
    case squareAnchor = 0x00000011
    
    /// LineCapTypeRoundAnchor: Specifies that the line end is anchored with a circular line cap. The center of the circle MUST be
    /// located at the last point in the line. The circle SHOULD be wider than the line.
    case roundAnchor = 0x00000012
    
    /// LineCapTypeDiamondAnchor: Specifies that the line end is anchored with a diamond-shaped line cap, which is a square turned
    /// at 45 degrees. The center of the diamond MUST be located at the last point in the line. The diamond SHOULD be wider than
    /// the line.
    case diamondAnchor = 0x00000013
    
    /// LineCapTypeArrowAnchor: Specifies that the line end is anchored with an arrowhead shape. The arrowhead point MUST be
    /// located at the last point in the line. The arrowhead SHOULD be wider than the line.
    case arrowAnchor = 0x00000014
    
    /// LineCapTypeAnchorMask: Mask used to check whether a line cap is an anchor cap.
    case anchorMask = 0x000000F0
    
    /// LineCapTypeCustom: Specifies a custom line cap.
    case custom = 0x000000FF
}
