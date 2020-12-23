//
//  EmfPlusPathPointType.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.31 EmfPlusPathPointType Object
/// The EmfPlusPathPointType object specifies a type value associated with a point on a graphics path.
/// Graphics paths are specified by EmfPlusPath objects. Every point on a graphics path MUST have a type value associated with it.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusPathPointType {
    public let flags: PathPointTypeFlags
    public let type: PathPointType
    
    public init(rawValue: UInt8) throws {
        var flags = BitFieldReader(rawValue: rawValue)
        
        /// Type (4 bits): An unsigned integer path point type. This value is defined in the PathPointType enumeration.
        guard let type = PathPointType(rawValue: flags.readBits(count: 4)) else {
            throw EmfPlusReadError.corrupted
        }

        self.type = type
        
        /// Flags (4 bits): A flag field that specifies properties of the path point. This value is one or more of the PathPointType flags.
        self.flags = PathPointTypeFlags(rawValue: flags.readBits(count: 4))
    }
    
    public init(dataStream: inout DataStream) throws {
        try self.init(rawValue: try dataStream.read())
    }
}
