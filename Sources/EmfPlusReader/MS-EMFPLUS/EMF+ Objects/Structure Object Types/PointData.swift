//
//  PointData.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

public enum PointData {
    case relative(_: EmfPlusPointR)
    case compressed(_: EmfPlusPoint)
    case uncompressed(_: EmfPlusPointF)
    
    public init(dataStream: inout DataStream, count: UInt32, relative: Bool, compressed: Bool) throws {
        if relative {
            self = .relative(try EmfPlusPointR(dataStream: &dataStream, small: true))
        } else if compressed {
            self = .compressed(try EmfPlusPoint(dataStream: &dataStream))
        } else {
            self = .uncompressed(try EmfPlusPointF(dataStream: &dataStream))
        }
    }
}
