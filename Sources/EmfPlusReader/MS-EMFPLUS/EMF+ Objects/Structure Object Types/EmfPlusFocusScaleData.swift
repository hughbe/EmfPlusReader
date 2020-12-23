//
//  EmfPlusFocusScaleData.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.18 EmfPlusFocusScaleData Object
/// The EmfPlusFocusScaleData object specifies focus scales for the blend pattern of a path gradient brush.
public struct EmfPlusFocusScaleData {
    public let focusScaleCount: UInt32
    public let focusScaleX: Float
    public let focusScaleY: Float
    
    public init(dataStream: inout DataStream) throws {
        /// FocusScaleCount (4 bytes): An unsigned integer that specifies the number of focus scales. This value MUST be 2.
        self.focusScaleCount = try dataStream.read(endianess: .littleEndian)
        guard self.focusScaleCount == 2 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// FocusScaleX (4 bytes): A floating-point value that defines the horizontal focus scale. The focus scale MUST be a value
        /// between 0.0 and 1.0, exclusive.
        let focusScaleX = try dataStream.readFloat(endianess: .littleEndian)
        guard focusScaleX > 0.0 && focusScaleX < 1.0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.focusScaleX = focusScaleX
        
        /// FocusScaleY (4 bytes): A floating-point value that defines the vertical focus scale. The focus scale MUST be a value
        /// between 0.0 and 1.0, exclusive.
        let focusScaleY = try dataStream.readFloat(endianess: .littleEndian)
        guard focusScaleY > 0.0 && focusScaleY < 1.0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.focusScaleY = focusScaleY
    }
}
