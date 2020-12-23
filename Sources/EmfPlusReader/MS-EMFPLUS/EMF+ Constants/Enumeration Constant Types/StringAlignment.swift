//
//  StringAlignment.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.28 StringAlignment Enumeration
/// The StringAlignment enumeration defines ways to align strings with respect to a text layout rectangle.
/// typedef enum
/// {
///  StringAlignmentNear = 0x00000000,
///  StringAlignmentCenter = 0x00000001,
///  StringAlignmentFar = 0x00000002
/// } StringAlignment;
/// See section 2.1.1 for the specification of additional enumerations.
public enum StringAlignment: UInt32, DataStreamCreatable {
    /// StringAlignmentNear: Specifies that string alignment is toward the origin of the layout rectangle.
    /// This can be used to align characters along a line or to align text within a rectangle. For a right-toleft layout rectangle, the origin
    /// SHOULD be at the upper right.
    case near = 0x00000000
    
    /// StringAlignmentCenter: Specifies that alignment is centered between the origin and extent of the layout rectangle.
    case center = 0x00000001
    
    /// StringAlignmentFar: Specifies that alignment is to the right side of the layout rectangle.
    case far = 0x00000002
}
