//
//  RectData.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

public enum RectData {
    case compressed(_: EmfPlusRect)
    case uncompressed(_: EmfPlusRectF)
    
    public init(dataStream: inout DataStream, compressed: Bool) throws {
        if compressed {
            self = .compressed(try EmfPlusRect(dataStream: &dataStream))
        } else {
            self = .uncompressed(try EmfPlusRectF(dataStream: &dataStream))
        }
    }
}
