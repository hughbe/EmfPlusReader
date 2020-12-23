//
//  EmfPlusFont.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

public struct EmfPlusFont {
    public let version: EmfPlusGraphicsVersion
    public let emSize: Float
    public let sizeUnit: UnitType
    public let fontStyleFlags: FontStyleFlags
    public let reserved: UInt32
    public let length: UInt32
    public let familyName: String
    
    public init(dataStream: inout DataStream, dataSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard dataSize >= 0x00000018 && dataSize % 4 == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Version (4 bytes): An EmfPlusGraphicsVersion object that specifies the version of operating system graphics that was
        /// used to create this object.
        self.version = try EmfPlusGraphicsVersion(dataStream: &dataStream)
        
        /// EmSize (4 bytes): A floating-point value that specifies the em size of the font in units specified by the SizeUnit field.
        self.emSize = try dataStream.readFloat(endianess: .littleEndian)
        
        /// SizeUnit (4 bytes): An unsigned integer that specifies the units used for the EmSize field. These are typically the units that
        /// were employed when designing the font. The value is in the UnitType enumeration.<10>
        let sizeUnitRaw: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard let sizeUnit = UnitType(rawValue: UInt8(sizeUnitRaw)) else {
            throw EmfPlusReadError.corrupted
        }
        
        self.sizeUnit = sizeUnit
        
        /// FontStyleFlags (4 bytes): A signed integer that specifies attributes of the character glyphs that affect the appearance of the
        /// font, such as bold and italic. This value is composed of FontStyle flags.
        self.fontStyleFlags = try FontStyleFlags(dataStream: &dataStream)
        
        /// Reserved (4 bytes): An unsigned integer that is reserved and MUST be ignored.
        self.reserved = try dataStream.read(endianess: .littleEndian)
        
        /// Length (4 bytes): An unsigned integer that specifies the number of characters in the FamilyName field.
        self.length = try dataStream.read(endianess: .littleEndian)
        guard length * 0x00000002 + 0x00000018 <= dataSize else {
            throw EmfPlusReadError.corrupted
        }
        
        /// FamilyName (variable): A string of Length Unicode characters that contains the name of the font family.
        self.familyName = try dataStream.readString(count: Int(self.length) * 2, encoding: .utf16LittleEndian)!
        
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == dataSize else {
            throw EmfPlusReadError.corrupted
        }
    }
}
