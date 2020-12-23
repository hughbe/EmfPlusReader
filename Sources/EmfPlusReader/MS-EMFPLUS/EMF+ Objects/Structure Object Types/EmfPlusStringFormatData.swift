//
//  EmfPlusStringFormatData.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.44 EmfPlusStringFormatData Object
/// The EmfPlusStringFormatData object specifies tab stops and character positions for a graphics string.
/// Graphics strings are specified by EmfPlusStringFormat objects.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusStringFormatData {
    public let tabStops: [Float]
    public let charRange: [EmfPlusCharacterRange]
    
    public init(dataStream: inout DataStream, tabStopCount: Int32, rangeCount: Int32, size: UInt32) throws {
        guard tabStopCount >= 0 && rangeCount >= 0 && tabStopCount * 4 + rangeCount * 8 == size else {
            throw EmfPlusReadError.corrupted
        }
        
        let startPosition = dataStream.position
        
        /// TabStops (variable): An optional array of floating-point values that specify the optional tab stop locations for this object.
        /// Each tab stop value represents the number of spaces between tab stops or, for the first tab stop, the number of spaces
        /// between the beginning of a line of text and the first tab stop.
        /// This field MUST be present if the value of the TabStopCount field in the EmfPlusStringFormat object is greater than 0.
        var tabStops: [Float] = []
        tabStops.reserveCapacity(Int(tabStopCount))
        for _ in 0..<tabStopCount {
            tabStops.append(try dataStream.readFloat(endianess: .littleEndian))
        }
        
        self.tabStops = tabStops
        
        /// CharRange (variable): An optional array of RangeCount EmfPlusCharacterRange objects that specify the range of character
        /// positions within a string of text. The bounding region is defined by the area of the display that is occupied by a group of
        /// characters specified by the character range.
        /// This field MUST be present if the value of the RangeCount field in the EmfPlusStringFormat object is greater than 0.
        var charRange: [EmfPlusCharacterRange] = []
        charRange.reserveCapacity(Int(tabStopCount))
        for _ in 0..<tabStopCount {
            charRange.append(try EmfPlusCharacterRange(dataStream: &dataStream))
        }
        
        self.charRange = charRange
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
