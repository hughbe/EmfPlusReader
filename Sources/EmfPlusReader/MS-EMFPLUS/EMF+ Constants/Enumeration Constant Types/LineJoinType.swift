//
//  LineJoinType.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.1.1.18 LineJoinType Enumeration
/// The LineJoinType enumeration defines ways to join two lines that are drawn by the same graphics pen and whose ends meet.
/// typedef enum
/// {
///  LineJoinTypeMiter = 0x00000000,
///  LineJoinTypeBevel = 0x00000001,
///  LineJoinTypeRound = 0x00000002,
///  LineJoinTypeMiterClipped = 0x00000003
/// } LineJoinType;
/// Graphics lines are specified by EmfPlusPen objects. A line join makes the intersection of the two line ends look more continuous.
/// See section 2.1.1 for the specification of additional enumerations.
public enum LineJoinType: UInt32, DataStreamCreatable {
    /// LineJoinTypeMiter: Specifies a mitered line join.
    case miter = 0x00000000
    
    /// LineJoinTypeBevel: Specifies a beveled line join.
    case bevel = 0x00000001
    
    /// LineJoinTypeRound: Specifies a rounded line join.
    case round = 0x00000002
    
    /// LineJoinTypeMiterClipped: Specifies a clipped mitered line join.
    case miterClipped = 0x00000003
}
