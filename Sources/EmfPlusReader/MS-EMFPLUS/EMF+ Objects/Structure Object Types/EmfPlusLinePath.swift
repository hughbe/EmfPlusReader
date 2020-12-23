//
//  EmfPlusLinePath.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.26 EmfPlusLinePath Object
/// The EmfPlusLinePath object specifies a graphics path for outlining a custom line cap.
/// Custom line caps are specified by EmfPlusCustomLineCap objects. An EmfPlusLinePath object MUST be present if the
/// CustomLineCapDataLinePath flag is set in the CustomLineCapDataFlags field of an EmfPlusCustomLineCapData object.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusLinePath {
    public let linePathLength: UInt32
    public let linePath: EmfPlusPath
    
    public init(dataStream: inout DataStream, availableSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard availableSize >= 0x00000004 else {
            throw EmfPlusReadError.corrupted
        }

        /// LinePathLength (4 bytes): A signed integer that defines the length in bytes of the LinePath field.
        self.linePathLength = try dataStream.read(endianess: .littleEndian)
        
        let dataStartPosition = dataStream.position
        
        /// LinePath (variable): An EmfPlusPath object that defines the outline.
        self.linePath = try EmfPlusPath(dataStream: &dataStream, dataSize: self.linePathLength)
        
        guard dataStream.position - startPosition <= availableSize &&
                dataStream.position - dataStartPosition == self.linePathLength else {
            throw EmfPlusReadError.corrupted
        }
    }
}
