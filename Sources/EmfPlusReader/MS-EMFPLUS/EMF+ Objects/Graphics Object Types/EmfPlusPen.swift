//
//  EmfPlusPen.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.1.7 EmfPlusPen Object
/// The EmfPlusPen object specifies a graphics pen for the drawing of lines.
/// See section 2.2.1 for the specification of additional graphics objects
public struct EmfPlusPen {
    public let version: EmfPlusGraphicsVersion
    public let type: UInt32
    public let penData: EmfPlusPenData
    public let brushObject: EmfPlusBrush
    
    public init(dataStream: inout DataStream, dataSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard dataSize >= 0x00000008 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Version (4 bytes): An EmfPlusGraphicsVersion object that specifies the version of operating system graphics that was
        /// used to create this object.
        self.version = try EmfPlusGraphicsVersion(dataStream: &dataStream)
        
        /// Type (4 bytes): This field MUST be set to zero.
        self.type = try dataStream.read(endianess: .littleEndian)
        
        /// PenData (variable): An EmfPlusPenData object that specifies properties of the graphics pen.
        self.penData = try EmfPlusPenData(dataStream: &dataStream, availableSize: dataSize - 0x00000008)
        
        /// BrushObject (variable): An EmfPlusBrush object that specifies a graphics brush associated with the pen.
        let remainingSize = dataSize - UInt32(dataStream.position - startPosition)
        self.brushObject = try EmfPlusBrush(dataStream: &dataStream, dataSize: remainingSize)
        
        guard dataStream.position - startPosition == dataSize else {
            throw EmfPlusReadError.corrupted
        }
    }
}
