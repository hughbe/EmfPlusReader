//
//  EmfPlusPointR.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.37 EmfPlusPointR Object
/// The EmfPlusPointR object specifies an ordered pair of integer (X,Y) values that define a relative location in a coordinate space.
/// Note: The object that specifies the horizontal coordinate is not required to be the same type as the object that specifies the vertical
/// coordinate; that is, one can be 7 bits and the other can be 15 bits.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusPointR {
    public let x: Integer7OrInteger15
    public let y: Integer7OrInteger15
    
    public init(dataStream: inout DataStream, small: Bool) throws {
        /// X (variable): A signed integer that specifies the horizontal coordinate. This value MUST be specified by either an
        /// EmfPlusInteger7 object or an EmfPlusInteger15 object.
        self.x = try Integer7OrInteger15(dataStream: &dataStream, small: small)
        
        /// Y (variable): A signed integer that specifies the vertical coordinate. This value MUST be specified by either an
        /// EmfPlusInteger7 object or an EmfPlusInteger15 object.
        self.y = try Integer7OrInteger15(dataStream: &dataStream, small: small)
    }
    
    public enum Integer7OrInteger15 {
        case integer7(_: EmfPlusInteger7)
        case integer15(_: EmfPlusInteger15)
        
        public init(dataStream: inout DataStream, small: Bool) throws {
            if small {
                self = .integer7(try dataStream.read())
            } else {
                self = .integer15(try dataStream.read(endianess: .littleEndian))
            }
        }
    }
}
