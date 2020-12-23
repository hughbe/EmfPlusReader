//
//  PathPointTypeFlags.swift
//
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.1.2.6 PathPointType Flags
/// The PathPointType flags specify type properties of points on graphics paths. These flags can be combined to specify multiple options.
/// See section 2.1.2 for the specification of additional bit flags.
public struct PathPointTypeFlags: OptionSet {
    public let rawValue: UInt8
    
    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    public init(dataStream: inout DataStream) throws {
        self.rawValue = try dataStream.read(endianess: .littleEndian)
    }
    
    /// PathPointTypeDashMode 0x01
    /// Specifies that a line segment that passes through the point is dashed.
    public static let dashMode = PathPointTypeFlags(rawValue: 0x01)
    
    /// PathPointTypePathMarker 0x02
    /// Specifies that the point is a position marker.
    public static let pathMarker = PathPointTypeFlags(rawValue: 0x02)
    
    /// PathPointTypeCloseSubpath 0x08
    /// Specifies that the point is the endpoint of a subpath.
    public static let closeSubpath = PathPointTypeFlags(rawValue: 0x08)
    
    public static let all: PathPointTypeFlags = [.dashMode, pathMarker, closeSubpath]
}
