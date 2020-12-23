//
//  EmfPlusCharacterRange.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.8 EmfPlusCharacterRange Object
/// The EmfPlusCharacterRange object specifies a range of character positions for a text string.
/// Graphics strings are specified by EmfPlusStringFormat objects.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusCharacterRange {
    public let first: Int32
    public let length: Int32
    
    public init(dataStream: inout DataStream) throws {
        /// First (4 bytes): A signed integer that specifies the first position of this range.
        self.first = try dataStream.read(endianess: .littleEndian)
        
        /// Length (4 bytes): A signed integer that specifies the number of positions in this range.
        self.length = try dataStream.read(endianess: .littleEndian)
    }
}
