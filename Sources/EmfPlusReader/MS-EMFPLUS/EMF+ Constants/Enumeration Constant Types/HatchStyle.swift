//
//  HatchStyle.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.13 HatchStyle Enumeration
/// The HatchStyle enumeration defines hatch patterns used by graphics brushes. A hatch pattern consists of a solid background color
/// and lines drawn over the background.
/// typedef enum
/// {
///  HatchStyleHorizontal = 0x00000000,
///  HatchStyleVertical = 0x00000001,
///  HatchStyleForwardDiagonal = 0x00000002,
///  HatchStyleBackwardDiagonal = 0x00000003,
///  HatchStyleLargeGrid = 0x00000004,
///  HatchStyleDiagonalCross = 0x00000005,
///  HatchStyle05Percent = 0x00000006,
///  HatchStyle10Percent = 0x00000007,
///  HatchStyle20Percent = 0x00000008,
///  HatchStyle25Percent = 0x00000009,
///  HatchStyle30Percent = 0x0000000A,
///  HatchStyle40Percent = 0x0000000B,
///  HatchStyle50Percent = 0x0000000C,
///  HatchStyle60Percent = 0x0000000D,
///  HatchStyle70Percent = 0x0000000E,
///  HatchStyle75Percent = 0x0000000F,
///  HatchStyle80Percent = 0x00000010,
///  HatchStyle90Percent = 0x00000011,
///  HatchStyleLightDownwardDiagonal = 0x00000012,
///  HatchStyleLightUpwardDiagonal = 0x00000013,
///  HatchStyleDarkDownwardDiagonal = 0x00000014,
///  HatchStyleDarkUpwardDiagonal = 0x00000015,
///  HatchStyleWideDownwardDiagonal = 0x00000016,
///  HatchStyleWideUpwardDiagonal = 0x00000017,
///  HatchStyleLightVertical = 0x00000018,
///  HatchStyleLightHorizontal = 0x00000019,
///  HatchStyleNarrowVertical = 0x0000001A,
///  HatchStyleNarrowHorizontal = 0x0000001B,
///  HatchStyleDarkVertical = 0x0000001C,
///  HatchStyleDarkHorizontal = 0x0000001D,
///  HatchStyleDashedDownwardDiagonal = 0x0000001E,
///  HatchStyleDashedUpwardDiagonal = 0x0000001F,
///  HatchStyleDashedHorizontal = 0x00000020,
///  HatchStyleDashedVertical = 0x00000021,
///  HatchStyleSmallConfetti = 0x00000022,
///  HatchStyleLargeConfetti = 0x00000023,
///  HatchStyleZigZag = 0x00000024,
///  HatchStyleWave = 0x00000025,
///  HatchStyleDiagonalBrick = 0x00000026,
///  HatchStyleHorizontalBrick = 0x00000027,
///  HatchStyleWeave = 0x00000028,
///  HatchStylePlaid = 0x00000029,
///  HatchStyleDivot = 0x0000002A,
///  HatchStyleDottedGrid = 0x0000002B,
///  HatchStyleDottedDiamond = 0x0000002C,
///  HatchStyleShingle = 0x0000002D,
///  HatchStyleTrellis = 0x0000002E,
///  HatchStyleSphere = 0x0000002F,
///  HatchStyleSmallGrid = 0x00000030,
///  HatchStyleSmallCheckerBoard = 0x00000031,
///  HatchStyleLargeCheckerBoard = 0x00000032,
///  HatchStyleOutlinedDiamond = 0x00000033,
///  HatchStyleSolidDiamond = 0x00000034
/// } HatchStyle;
/// Graphics brushes are specified by EmfPlusBrush objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum HatchStyle: UInt32, DataStreamCreatable {
    /// HatchStyleHorizontal: Specifies equally spaced horizontal lines.
    case horizontal = 0x00000000
    
    /// HatchStyleVertical: Specifies equally spaced vertical lines.
    case vertical = 0x00000001
    
    /// HatchStyleForwardDiagonal: Specifies lines on a diagonal from upper left to lower right.
    case forwardDiagonal = 0x00000002
    
    /// HatchStyleBackwardDiagonal: Specifies lines on a diagonal from upper right to lower left.
    case backwardDiagonal = 0x00000003
    
    /// HatchStyleLargeGrid: Specifies crossing horizontal and vertical lines.
    case largeGrid = 0x00000004
    
    /// HatchStyleDiagonalCross: Specifies crossing forward diagonal and backward diagonal lines with anti-aliasing.
    case diagonalCross = 0x00000005
    
    /// HatchStyle05Percent: Specifies a 5-percent hatch, which is the ratio of foreground color to background color equal to 5:100.
    case fivePercent = 0x00000006
    
    /// HatchStyle10Percent: Specifies a 10-percent hatch, which is the ratio of foreground color to background color equal to 10:100.
    case tenPercent = 0x00000007
    
    /// HatchStyle20Percent: Specifies a 20-percent hatch, which is the ratio of foreground color to background color equal to 20:100.
    case twentyPercent = 0x00000008
    
    /// HatchStyle25Percent: Specifies a 25-percent hatch, which is the ratio of foreground color to background color equal to 25:100.
    case twentyFivePercent = 0x00000009
    
    /// HatchStyle30Percent: Specifies a 30-percent hatch, which is the ratio of foreground color to background color equal to 30:100.
    case thirtyPercent = 0x0000000A
    
    /// HatchStyle40Percent: Specifies a 40-percent hatch, which is the ratio of foreground color to background color equal to 40:100.
    case fourtyPercent = 0x0000000B
    
    /// HatchStyle50Percent: Specifies a 50-percent hatch, which is the ratio of foreground color to background color equal to 50:100.
    case fiftyPercent = 0x0000000C
    
    /// HatchStyle60Percent: Specifies a 60-percent hatch, which is the ratio of foreground color to background color equal to 60:100.
    case sixtyPercent = 0x0000000D
    
    /// HatchStyle70Percent: Specifies a 70-percent hatch, which is the ratio of foreground color to background color equal to 70:100.
    case seventyPercent = 0x0000000E
    
    /// HatchStyle75Percent: Specifies a 75-percent hatch, which is the ratio of foreground color to background color equal to 75:100.
    case seventyFivePercent = 0x0000000F
    
    /// HatchStyle80Percent: Specifies an 80-percent hatch, which is the ratio of foreground color to background color equal to 80:100.
    case eightyPercent = 0x00000010
    
    /// HatchStyle90Percent: Specifies a 90-percent hatch, which is the ratio of foreground color to background color equal to 90:100.
    case ninetyPercent = 0x00000011
    
    /// HatchStyleLightDownwardDiagonal: Specifies diagonal lines that slant to the right from top to bottom points with no anti-aliasing.
    /// They are spaced 50 percent further apart than lines in the HatchStyleForwardDiagonal pattern
    case lightDownwardDiagonal = 0x00000012
    
    /// HatchStyleLightUpwardDiagonal: Specifies diagonal lines that slant to the left from top to bottom points with no anti-aliasing.
    /// They are spaced 50 percent further apart than lines in the HatchStyleBackwardDiagonal pattern.
    case lightUpwardDiagonal = 0x00000013
    
    /// HatchStyleDarkDownwardDiagonal: Specifies diagonal lines that slant to the right from top to bottom points with no anti-aliasing.
    /// They are spaced 50 percent closer and are twice the width of lines in the HatchStyleForwardDiagonal pattern.
    case darkDownwardDiagonal = 0x00000014
    
    /// HatchStyleDarkUpwardDiagonal: Specifies diagonal lines that slant to the left from top to bottom points with no anti-aliasing.
    /// They are spaced 50 percent closer and are twice the width of lines in the HatchStyleBackwardDiagonal pattern.
    case darkUpwardDiagonal = 0x00000015
    
    /// HatchStyleWideDownwardDiagonal: Specifies diagonal lines that slant to the right from top to bottom points with no anti-aliasing.
    /// They have the same spacing between lines in HatchStyleWideDownwardDiagonal pattern and HatchStyleForwardDiagonal
    /// pattern, but HatchStyleWideDownwardDiagonal has the triple line width of HatchStyleForwardDiagonal.
    case wideDownwardDiagonal = 0x00000016
    
    /// HatchStyleWideUpwardDiagonal: Specifies diagonal lines that slant to the left from top to bottom points with no anti-aliasing.
    /// They have the same spacing between lines in HatchStyleWideUpwardDiagonal pattern and HatchStyleBackwardDiagonal pattern,
    /// but HatchStyleWideUpwardDiagonal has the triple line width of HatchStyleWideUpwardDiagonal.
    case wideUpwardDiagonal = 0x00000017
    
    /// HatchStyleLightVertical: Specifies vertical lines that are spaced 50 percent closer together than lines in the HatchStyleVertical
    /// pattern.
    case lightVertical = 0x00000018
    
    /// HatchStyleLightHorizontal: Specifies horizontal lines that are spaced 50 percent closer than lines in the HatchStyleHorizontal
    /// pattern.
    case lightHorizontal = 0x00000019
    
    /// HatchStyleNarrowVertical: Specifies vertical lines that are spaced 75 percent closer than lines in the HatchStyleVertical pattern;
    /// or 25 percent closer than lines in the HatchStyleLightVertical pattern.
    case narrowVertical = 0x0000001A
    
    /// HatchStyleNarrowHorizontal: Specifies horizontal lines that are spaced 75 percent closer than lines in the HatchStyleHorizontal
    /// pattern; or 25 percent closer than lines in the HatchStyleLightHorizontal pattern.
    case narrowHorizontal = 0x0000001B
    
    /// HatchStyleDarkVertical: Specifies lines that are spaced 50 percent closer than lines in the HatchStyleVertical pattern.
    case darkVertical = 0x0000001C
    
    /// HatchStyleDarkHorizontal: Specifies lines that are spaced 50 percent closer than lines in the HatchStyleHorizontal pattern.
    case darkHorizontal = 0x0000001D
    
    /// HatchStyleDashedDownwardDiagonal: Specifies dashed diagonal lines that slant to the right from top to bottom points.
    case dashedDownwardDiagonal = 0x0000001E
    
    /// HatchStyleDashedUpwardDiagonal: Specifies dashed diagonal lines that slant to the left from top to bottom points.
    case dashedUpwardDiagonal = 0x0000001F
    
    /// HatchStyleDashedHorizontal: Specifies dashed horizontal lines.
    case dashedHorizontal = 0x00000020
    
    /// HatchStyleDashedVertical: Specifies dashed vertical lines.
    case dashedVertical = 0x00000021
    
    /// HatchStyleSmallConfetti: Specifies a pattern of lines that has the appearance of confetti.
    case smallConfetti = 0x00000022
    
    /// HatchStyleLargeConfetti: Specifies a pattern of lines that has the appearance of confetti, and is composed of larger
    /// pieces than the HatchStyleSmallConfetti pattern.
    case largeConfetti = 0x00000023
    
    /// HatchStyleZigZag: Specifies horizontal lines that are composed of zigzags.
    case zigZag = 0x00000024
    
    /// HatchStyleWave: Specifies horizontal lines that are composed of tildes.
    case styleWave = 0x00000025
    
    /// HatchStyleDiagonalBrick: Specifies a pattern of lines that has the appearance of layered bricks that slant to the left from top
    /// to bottom points.
    case diagonalBrick = 0x00000026
    
    /// HatchStyleHorizontalBrick: Specifies a pattern of lines that has the appearance of horizontally layered bricks.
    case horizontalBrick = 0x00000027
    
    /// HatchStyleWeave: Specifies a pattern of lines that has the appearance of a woven material.
    case weave = 0x00000028
    
    /// HatchStylePlaid: Specifies a pattern of lines that has the appearance of a plaid material.
    case plaid = 0x00000029
    
    /// HatchStyleDivot: Specifies a pattern of lines that has the appearance of divots.
    case divot = 0x0000002A
    
    /// HatchStyleDottedGrid: Specifies crossing horizontal and vertical lines, each of which is composed of dots.
    case dottedGrid = 0x0000002B
    
    /// HatchStyleDottedDiamond: Specifies crossing forward and backward diagonal lines, each of which is composed of dots.
    case dottedDiamond = 0x0000002C
    
    /// HatchStyleShingle: Specifies a pattern of lines that has the appearance of diagonally layered shingles that slant to the right
    /// from top to bottom points.
    case shingle = 0x0000002D
    
    /// HatchStyleTrellis: Specifies a pattern of lines that has the appearance of a trellis.
    case trellis = 0x0000002E
    
    /// HatchStyleSphere: Specifies a pattern of lines that has the appearance of spheres laid adjacent to each other.
    case sphere = 0x0000002F
    
    /// HatchStyleSmallGrid: Specifies crossing horizontal and vertical lines that are spaced 50 percent closer together than
    /// HatchStyleLargeGrid.
    case smallGrid = 0x00000030
    
    /// HatchStyleSmallCheckerBoard: Specifies a pattern of lines that has the appearance of a checkerboard.
    case smallCheckerBoard = 0x00000031
    
    /// HatchStyleLargeCheckerBoard: Specifies a pattern of lines that has the appearance of a checkerboard, with squares that are
    /// twice the size of the squares in the HatchStyleSmallCheckerBoard pattern.
    case largeCheckerboard = 0x00000032
    
    /// HatchStyleOutlinedDiamond: Specifies crossing forward and backward diagonal lines; the lines are not anti-aliased.
    case outlinedDiamond = 0x00000033
    
    /// HatchStyleSolidDiamond: Specifies a pattern of lines that has the appearance of a checkerboard placed diagonally.
    case solidDiamond = 0x00000034
}
