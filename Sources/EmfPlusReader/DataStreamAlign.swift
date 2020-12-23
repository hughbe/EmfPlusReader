//
//  DataStreamAlign.swift
//  
//
//  Created by Hugh Bellamy on 03/12/2020.
//

import DataStream

internal extension DataStream {
    mutating func readFourByteAlignmentPadding(startPosition: Int) throws {
        let excessBytes = (position - startPosition) % 4
        if excessBytes > 0 {
            let padding = 4 - excessBytes
            guard position + padding <= count else {
                throw EmfPlusReadError.corrupted
            }
            
            position += padding
        }
    }
    
    mutating func readRestOfRecord(startPosition: Int, size: UInt32) throws {
        let remainingCount = Int(size) - (position - startPosition)
        if remainingCount > 0 {
            guard position + remainingCount < count else {
                throw EmfPlusReadError.corrupted
            }
            
            position += remainingCount
        }
    }
}
