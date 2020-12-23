//
//  EmfPlusCustomEndCapData.swift
//
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.11 EmfPlusCustomEndCapData Object
/// The EmfPlusCustomEndCapData object specifies a custom line cap for the end of a line.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusCustomEndCapData  {
    public let customEndCapSize: UInt32
    public let customEndCap: EmfPlusCustomLineCap
    
    public init(dataStream: inout DataStream, availableSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard availableSize >= 0x00000004 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// CustomEndCapSize (4 bytes): An unsigned integer that specifies the size in bytes of the CustomEndCap field.
        self.customEndCapSize = try dataStream.read(endianess: .littleEndian)
        guard 0x00000004 + self.customEndCapSize <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataStartPosition = dataStream.position
        
        /// CustomEndCap (variable): A custom line cap that defines the shape to draw at the end of a line. It can be any of various
        /// shapes, including a square, circle, or diamond.
        self.customEndCap = try EmfPlusCustomLineCap(dataStream: &dataStream, dataSize: self.customEndCapSize)
        
        guard dataStream.position - startPosition <= availableSize &&
                dataStream.position - dataStartPosition == self.customEndCapSize else {
            throw EmfPlusReadError.corrupted
        }
    }
}
