//
//  EmfPlusFillPathStructure.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.17 EmfPlusFillPath Object
/// The EmfPlusFillPath object specifies a graphics path for filling a custom line cap.
/// Custom line caps are specified by EmfPlusCustomLineCap objects. An EmfPlusFillPath object MUST be present if the
/// CustomLineCapDataFillPath flag is set in the CustomLineCapDataFlags field of an EmfPlusCustomLineCapData object.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusFillPathStructure {
    public let fillPathLength: UInt32
    public let fillPath: EmfPlusPath
    
    public init(dataStream: inout DataStream, availableSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard availableSize >= 0x00000004 else {
            throw EmfPlusReadError.corrupted
        }

        /// FillPathLength (4 bytes): A signed integer that specifies the length in bytes of the FillPath field.
        self.fillPathLength = try dataStream.read(endianess: .littleEndian)
        
        let dataStartPosition = dataStream.position
        
        /// FillPath (variable): An EmfPlusPath, which specifies the area to fill.
        self.fillPath = try EmfPlusPath(dataStream: &dataStream, dataSize: self.fillPathLength)
        guard 0x00000004 + self.fillPathLength <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
        
        guard dataStream.position - startPosition <= availableSize &&
                dataStream.position - dataStartPosition == self.fillPathLength else {
            throw EmfPlusReadError.corrupted
        }
    }
}
