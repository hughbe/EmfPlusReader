//
//  PathPointType.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.22 PathPointType Enumeration
/// The PathPointType enumeration defines types of points on a graphics path.
/// typedef enum
/// {
///  PathPointTypeStart = 0x00,
///  PathPointTypeLine = 0x01,
///  PathPointTypeBezier = 0x03
/// } PathPointType;
/// Graphics path point types are specified by EmfPlusPathPointType objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum PathPointType: UInt8, DataStreamCreatable {
    /// PathPointTypeStart: Specifies that the point is the starting point of a path.
    case start = 0x00
    
    /// PathPointTypeLine: Specifies that the point is one of the two endpoints of a line.
    case line = 0x01
    
    /// PathPointTypeBezier: Specifies that the point is an endpoint or control point of a cubic Bezier curve.
    case bezier = 0x03
}
