//
//  DashedLineCapType.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.10 DashedLineCapType Enumeration
/// The DashedLineCapType enumeration defines types of line caps to use at the ends of dashed lines that are drawn with graphics pens.
/// typedef enum
/// {
///  DashedLineCapTypeFlat = 0x00000000,
///  DashedLineCapTypeRound = 0x00000002,
///  DashedLineCapTypeTriangle = 0x00000003
/// } DashedLineCapType;
/// Dashed lines are specified by EmfPlusDashedLineData objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum DashedLineCapType: UInt32, DataStreamCreatable {
    /// DashedLineCapTypeFlat: Specifies a flat dashed line cap.
    case flat = 0x00000000
    
    /// DashedLineCapTypeRound: Specifies a round dashed line cap.
    case round = 0x00000002
    
    /// DashedLineCapTypeTriangle: Specifies a triangular dashed line cap.
    case triangle = 0x00000003
}
