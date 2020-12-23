//
//  EmfPlusPathPointTypeRLE.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.32 EmfPlusPathPointTypeRLE Object
/// The EmfPlusPathPointTypeRLE object specifies type values associated with points on a graphics path using RLE compression
/// ([MS-WMF] section 3.1.6).
/// Graphics paths are specified by EmfPlusPath objects. Every point on a graphics path MUST have a type value associated with it.
/// RLE compression makes it possible to specify an arbitrary number of identical values without a proportional increase in storage
/// requirements.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusPathPointTypeRLE {
    public let pointType: EmfPlusPathPointType
    public let reserved: Bool
    public let runCount: UInt8
    public let pointsOnBezierCurve: Bool
    
    public init(dataStream: inout DataStream) throws {
        var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
        
        /// PointType (1 byte): An EmfPlusPathPointType object that specifies the type to associate with the path points.
        self.pointType = try EmfPlusPathPointType(rawValue: UInt8(flags.readBits(count: 8)))
        
        
        /// RunCount (6 bits): The run count, which is the number of path points to be associated with the type in the PointType field.
        self.runCount = UInt8(flags.readBits(count: 6))
        
        self.reserved = flags.readBit()
        
        /// B (1 bit): If set, the path points are on a Bezier curve.
        /// If clear, the path points are on a graphics line.
        self.pointsOnBezierCurve = flags.readBit()
    }
}
