//
//  EmfPlusPenData.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.33 EmfPlusPenData Object
/// The EmfPlusPenData object specifies properties of a graphics pen.
/// Graphics pens are specified by EmfPlusPen objects.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusPenData {
    public let penDataFlags: PenDataFlags
    public let penUnit: UnitType
    public let penWidth: Float
    public let optionalData: EmfPlusPenOptionalData
    
    public init(dataStream: inout DataStream, availableSize: UInt32) throws {
        let startPosition = dataStream.position

        guard availableSize >= 0x00000008 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// PenDataFlags (4 bytes): An unsigned integer that specifies the data in the OptionalData field. This value is composed of
        /// PenData flags.
        self.penDataFlags = try PenDataFlags(dataStream: &dataStream)
        
        /// PenUnit (4 bytes): An unsigned integer that specifies the measuring units for the pen. The value is from the UnitType
        /// enumeration.
        let penUnitRaw: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard let penUnit = UnitType(rawValue: UInt8(penUnitRaw)) else {
            throw EmfPlusReadError.corrupted
        }
        
        self.penUnit = penUnit
        
        /// PenWidth (4 bytes): A floating-point value that specifies the width of the line drawn by the pen in the units specified by
        /// the PenUnit field. If a zero width is specified, a minimum value is used, which is determined by the units.
        self.penWidth = try dataStream.readFloat(endianess: .littleEndian)
        
        /// OptionalData (variable): An optional EmfPlusPenOptionalData object that specifies additional data for the pen object.
        /// The specific contents of this field are determined by the value of the PenDataFlags field.
        self.optionalData = try EmfPlusPenOptionalData(dataStream: &dataStream, flags: self.penDataFlags, availableSize: availableSize - 0x00000008)
        
        guard dataStream.position - startPosition <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
    }
}
