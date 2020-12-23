//
//  EmfPlusPalette.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.28 EmfPlusPalette Object
/// The EmfPlusPalette object specifies the colors that make up a palette.
/// See section 2.2.2 for the specification of additional graphics objects.
public struct EmfPlusPalette {
    public let paletteStyleFlags: PaletteStyleFlags
    public let paletteCount: UInt32
    public let paletteEntries: [EmfPlusARGB]
    
    public init(dataStream: inout DataStream, availableSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard availableSize >= 0x00000008 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// PaletteStyleFlags (4 bytes): An unsigned integer that specifies the attributes of data in the palette.
        /// This value MUST be composed of PaletteStyle flags.
        self.paletteStyleFlags = try PaletteStyleFlags(dataStream: &dataStream)
        
        /// PaletteCount (4 bytes): An unsigned integer that specifies the number of entries in the PaletteEntries array.
        self.paletteCount = try dataStream.read(endianess: .littleEndian)
        
        /// PaletteEntries (variable): An array of PaletteCount EmfPlusARGB objects that specify the data in the palette.
        var paletteEntries: [EmfPlusARGB] = []
        paletteEntries.reserveCapacity(Int(self.paletteCount))
        for _ in 0..<self.paletteCount {
            paletteEntries.append(try EmfPlusARGB(dataStream: &dataStream))
        }
        
        self.paletteEntries = paletteEntries
        
        guard dataStream.position - startPosition <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
    }
}
