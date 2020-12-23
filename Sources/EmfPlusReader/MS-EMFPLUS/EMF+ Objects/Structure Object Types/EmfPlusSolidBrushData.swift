//
//  EmfPlusSolidBrushData.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.43 EmfPlusSolidBrushData Object
/// The EmfPlusSolidBrushData object specifies a solid color for a graphics brush.
/// Graphics brushes are specified by EmfPlusBrush objects. A solid color brush paints a background in a solid color.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusSolidBrushData {
    public let solidColor: EmfPlusARGB
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size == 4 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// SolidColor (4 bytes): An EmfPlusARGB object that specifies the color of the brush.
        self.solidColor = try EmfPlusARGB(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
