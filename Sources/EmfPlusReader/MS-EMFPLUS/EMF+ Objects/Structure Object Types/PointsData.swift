//
//  PointsData.swift
//  
//
//  Created by Hugh Bellamy on 21/12/2020.
//

import DataStream

public enum PointsData {
    case relative(_: [EmfPlusPointR])
    case compressed(_: [EmfPlusPoint])
    case uncompressed(_: [EmfPlusPointF])
    
    public init(dataStream: inout DataStream, count: UInt32, relative: Bool, compressed: Bool) throws {
        if relative {
            var values: [EmfPlusPointR] = []
            values.reserveCapacity(Int(count))
            for _ in 0..<count {
                values.append(try EmfPlusPointR(dataStream: &dataStream, small: true))
            }
            
            self = .relative(values)
        } else if compressed {
            var values: [EmfPlusPoint] = []
            values.reserveCapacity(Int(count))
            for _ in 0..<count {
                values.append(try EmfPlusPoint(dataStream: &dataStream))
            }
            
            self = .compressed(values)
        } else {
            var values: [EmfPlusPointF] = []
            values.reserveCapacity(Int(count))
            for _ in 0..<count {
                values.append(try EmfPlusPointF(dataStream: &dataStream))
            }
            
            self = .uncompressed(values)
        }
    }
}
