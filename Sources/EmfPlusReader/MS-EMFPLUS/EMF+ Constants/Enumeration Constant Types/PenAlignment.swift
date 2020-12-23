//
//  PenAlignment.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.23 PenAlignment Enumeration
/// The PenAlignment enumeration defines the distribution of the width of the pen with respect to the line being drawn.
/// typedef enum
/// {
///  PenAlignmentCenter = 0x00000000,
///  PenAlignmentInset = 0x00000001,
///  PenAlignmentLeft = 0x00000002,
///  PenAlignmentOutset = 0x00000003,
///  PenAlignmentRight = 0x00000004
/// } PenAlignment;
/// Graphics pens are specified by EmfPlusPen objects. Pen alignment can be visualized by considering a theoretical one-dimensional
/// line drawn between two specified points. The pen alignment determines the proportion of pen width that is orthogonal to the
/// theoretical line.
/// See section 2.1.1 for the specification of additional enumerations.
public enum PenAlignment: UInt32, DataStreamCreatable {
    /// PenAlignmentCenter: Specifies that the EmfPlusPen object is centered over the theoretical line.
    case center = 0x00000000
    
    /// PenAlignmentInset: Specifies that the pen is positioned on the inside of the theoretical line.
    case inset = 0x00000001
    
    /// PenAlignmentLeft: Specifies that the pen is positioned to the left of the theoretical line.
    case left = 0x00000002
    
    /// PenAlignmentOutset: Specifies that the pen is positioned on the outside of the theoretical line.
    case outset = 0x00000003
    
    /// PenAlignmentRight: Specifies that the pen is positioned to the right of the theoretical line.
    case right = 0x00000004
}
