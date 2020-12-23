//
//  EmfPlusHatchBrushData.swift
//  
//
//  Created by Hugh Bellamy on 21/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.20 EmfPlusHatchBrushData Object
/// The EmfPlusHatchBrushData object specifies a hatch pattern for a graphics brush.
/// Graphics brushes are specified by EmfPlusBrush objects. A hatch brush paints a background and draws a pattern of lines, dots,
/// dashes, squares, and crosshatch lines over this background. The hatch brush defines two colors: one for the background and one
/// for the pattern over the background. The color of the background is called the background color, and the color of the pattern is
/// called the foreground color.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusHatchBrushData {
    public let hatchStyle: HatchStyle
    public let foreColor: EmfPlusARGB
    public let backColor: EmfPlusARGB
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size == 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        /// HatchStyle (4 bytes): An unsigned integer that specifies the brush hatch style. It is defined in the HatchStyle enumeration.
        self.hatchStyle = try HatchStyle(dataStream: &dataStream)
        
        /// ForeColor (4 bytes): An EmfPlusARGB object that specifies the color used to draw the lines of the hatch pattern.
        self.foreColor = try EmfPlusARGB(dataStream: &dataStream)
        
        /// BackColor (4 bytes): An EmfPlusARGB object that specifies the color used to paint the background of the hatch pattern.
        self.backColor = try EmfPlusARGB(dataStream: &dataStream)
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
