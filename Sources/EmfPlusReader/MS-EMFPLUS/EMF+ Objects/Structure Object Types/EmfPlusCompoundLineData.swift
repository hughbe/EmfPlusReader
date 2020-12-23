//
//  EmfPlusCompoundLineData.swift
//
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.9 EmfPlusCompoundLineData Object
/// The EmfPlusCompoundLineData object specifies line and space data for a compound line.
/// Graphics pens are specified by EmfPlusPen objects. An EmfPlusCompoundLineData object MUST be present in the OptionalData
/// field of an EmfPlusPenData object, if the PenDataCompoundLineData flag is set in its PenDataFlags field.
/// A compound line is made up of a pattern of alternating parallel lines and spaces of varying widths. The values in the array specify the
/// starting points of each component of the compound line relative to the total width. The first value specifies where the first line
/// component begins as a fraction of the distance across the width of the pen. The second value specifies where the first space
/// component begins as a fraction of the distance across the width of the pen. The final value in the array specifies where the last
/// line component ends.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusCompoundLineData  {
    public let compoundLineDataSize: UInt32
    public let compoundLineData: [Float]
    
    public init(dataStream: inout DataStream, availableSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard availableSize >= 0x00000004 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// DashedLineDataSize (4 bytes): An unsigned integer that specifies the number of elements in the DashedLineData field.
        self.compoundLineDataSize = try dataStream.read(endianess: .littleEndian)
        guard 0x00000004 + self.compoundLineDataSize * 4 <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
        
        /// CompoundLineData (variable): An array of CompoundLineDataSize floating-point values that specify the compound line
        /// of a pen. The elements MUST be in increasing order, and their values MUST be between 0.0 and 1.0, inclusive.
        var compoundLineData: [Float] = []
        compoundLineData.reserveCapacity(Int(self.compoundLineDataSize))
        for _ in 0..<self.compoundLineDataSize {
            let value = try dataStream.readFloat(endianess: .littleEndian)
            guard value >= 0.0 && value <= 1.0 else {
                throw EmfPlusReadError.corrupted
            }

            compoundLineData.append(value)
        }
        
        self.compoundLineData = compoundLineData
        
        guard dataStream.position - startPosition <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
    }
}
