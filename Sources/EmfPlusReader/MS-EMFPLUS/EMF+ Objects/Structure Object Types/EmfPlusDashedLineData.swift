//
//  EmfPlusDashedLineData.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.16 EmfPlusDashedLineData Object
/// The EmfPlusDashedLineData object specifies properties of a dashed line for a graphics pen.
/// Graphics pens are specified by EmfPlusPen objects. An EmfPlusDashedLineData object MUST be present in the OptionalData field
/// of an EmfPlusPenData object, if the PenDataDashedLine flag is set in its PenDataFlags field.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusDashedLineData  {
    public let dashedLineDataSize: UInt32
    public let dashedLineData: [Float]
    
    public init(dataStream: inout DataStream, availableSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard availableSize >= 0x00000004 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// DashedLineDataSize (4 bytes): An unsigned integer that specifies the number of elements in the DashedLineData field.
        self.dashedLineDataSize = try dataStream.read(endianess: .littleEndian)
        guard 0x00000004 + self.dashedLineDataSize * 4 <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
        
        /// DashedLineData (variable): An array of DashedLineDataSize floating-point values that specify the lengths of the dashes
        /// and spaces in a dashed line.
        var dashedLineData: [Float] = []
        dashedLineData.reserveCapacity(Int(self.dashedLineDataSize))
        for _ in 0..<self.dashedLineDataSize {
            dashedLineData.append(try dataStream.readFloat(endianess: .littleEndian))
        }
        
        self.dashedLineData = dashedLineData
        
        guard dataStream.position - startPosition <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
    }
}
