//
//  EmfPlusCustomStartCapData.swift
//
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.15 EmfPlusCustomStartCapData Object
/// The EmfPlusCustomStartCapData object specifies a custom line cap for the start of a line.
/// Custom line caps are specified by EmfPlusCustomLineCap objects. If the PenDataStartCap flag is set in its PenDataFlags field, an
/// EmfPlusCustomStartCapData object MUST be present in the OptionalData field of an EmfPlusPenData object.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusCustomStartCapData  {
    public let customStartCapSize: UInt32
    public let customStartCap: EmfPlusCustomLineCap
    
    public init(dataStream: inout DataStream, availableSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard availableSize >= 0x00000004 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// CustomStartCapSize (4 bytes): An unsigned integer that specifies the size in bytes of the CustomStartCap field.
        self.customStartCapSize = try dataStream.read(endianess: .littleEndian)
        guard 0x00000004 + self.customStartCapSize <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataStartPosition = dataStream.position
        
        /// CustomStartCap (variable): A custom graphics line cap that defines the shape to draw at the start of a line. It can be any
        /// of various shapes, including a square, circle or diamond.
        self.customStartCap = try EmfPlusCustomLineCap(dataStream: &dataStream, dataSize: self.customStartCapSize)
        
        guard dataStream.position - startPosition <= availableSize &&
                dataStream.position - dataStartPosition == self.customStartCapSize else {
            throw EmfPlusReadError.corrupted
        }
    }
}
