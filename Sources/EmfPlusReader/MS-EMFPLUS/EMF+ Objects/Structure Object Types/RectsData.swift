//
//  RectsData.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

public enum RectsData {
    case compressed(_: [EmfPlusRect])
    case uncompressed(_: [EmfPlusRectF])
    
    public init(dataStream: inout DataStream, count: UInt32, compressed: Bool) throws {
        if compressed {
            var values: [EmfPlusRect] = []
            values.reserveCapacity(Int(count))
            for _ in 0..<count {
                values.append(try EmfPlusRect(dataStream: &dataStream))
            }
            
            self = .compressed(values)
        } else {
            var values: [EmfPlusRectF] = []
            values.reserveCapacity(Int(count))
            for _ in 0..<count {
                values.append(try EmfPlusRectF(dataStream: &dataStream))
            }
            
            self = .uncompressed(values)
        }
    }
}
