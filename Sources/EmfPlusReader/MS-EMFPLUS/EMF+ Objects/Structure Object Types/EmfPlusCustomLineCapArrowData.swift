//
//  EmfPlusCustomLineCapArrowData.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.12 EmfPlusCustomLineCapArrowData Object
/// The EmfPlusCustomLineCapArrowData object specifies adjustable arrow data for a custom line cap.
/// Custom line caps are specified by EmfPlusCustomLineCap objects.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusCustomLineCapArrowData {
    public let width: Float
    public let height: Float
    public let middleInset: Float
    public let fillState: UInt32
    public let lineStartCap: LineCapType
    public let lineEndCap: LineCapType
    public let lineJoin: LineJoinType
    public let lineMiterLimit: Float
    public let widthScale: Float
    public let fillHotspot: EmfPlusPointF
    public let lineHotSpot: EmfPlusPointF
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size == 0x00000034 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Width (4 bytes): A floating-point value that specifies the width of the arrow cap.
        /// The width of the arrow cap is scaled by the width of the EmfPlusPen object that is used to draw the line being capped.
        /// For example, when drawing a capped line with a pen that has a width of 5 pixels, and the adjustable arrow cap object has
        /// a width of 3, the actual arrow cap is drawn 15 pixels wide.
        self.width = try dataStream.readFloat(endianess: .littleEndian)
        
        /// Height (4 bytes): A floating-point value that specifies the height of the arrow cap.
        /// The height of the arrow cap is scaled by the width of the EmfPlusPen object that is used to draw the line being capped.
        /// For example, when drawing a capped line with a pen that has a width of 5 pixels, and the adjustable arrow cap object
        /// has a height of 3, the actual arrow cap is drawn 15 pixels high.
        self.height = try dataStream.readFloat(endianess: .littleEndian)
        
        /// MiddleInset (4 bytes): A floating-point value that specifies the number of pixels between the outline of the arrow cap and
        /// the fill of the arrow cap.
        self.middleInset = try dataStream.readFloat(endianess: .littleEndian)
        
        /// FillState (4 bytes): A Boolean value that specifies whether the arrow cap is filled. If the arrow cap is not filled, only the
        /// outline is drawn.
        self.fillState = try dataStream.read(endianess: .littleEndian)
        
        /// LineStartCap (4 bytes): An unsigned integer that specifies the value in the LineCap enumeration that indicates the line cap
        /// to be used at the start of the line to be drawn.
        self.lineStartCap = try LineCapType(dataStream: &dataStream)
        
        /// LineEndCap (4 bytes): An unsigned integer that specifies the value in the LineCap enumeration that indicates the line cap
        /// to be used at the end of the line to be drawn.
        self.lineEndCap = try LineCapType(dataStream: &dataStream)
        
        /// LineJoin (4 bytes): An unsigned integer that specifies the value in the LineJoin enumeration that specifies how to join two
        /// lines that are drawn by the same pen and whose ends meet. At the intersection of the two line ends, a line join makes the
        /// connection look more continuous.
        self.lineJoin = try LineJoinType(dataStream: &dataStream)
        
        /// LineMiterLimit (4 bytes): A floating-point value that specifies the limit of the thickness of the join on a mitered corner by
        /// setting the maximum allowed ratio of miter length to line width.
        self.lineMiterLimit = try dataStream.readFloat(endianess: .littleEndian)
        
        /// WidthScale (4 bytes): A floating-point value that specifies the amount by which to scale an EmfPlusCustomLineCap object
        /// with respect to the width of the graphics pen that is used to draw the lines.
        self.widthScale = try dataStream.readFloat(endianess: .littleEndian)
        
        /// FillHotSpot (8 bytes): An EmfPlusPointF object that is not currently used. It MUST be set to {0.0, 0.0}.
        let fillHotspot = try EmfPlusPointF(dataStream: &dataStream)
        guard fillHotspot.x == 0.0 && fillHotspot.y == 0.0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.fillHotspot = fillHotspot
        
        /// LineHotSpot (8 bytes): An EmfPlusPointF object that is not currently used. It MUST be set to {0.0, 0.0}.
        let lineHotSpot = try EmfPlusPointF(dataStream: &dataStream)
        guard lineHotSpot.x == 0.0 && lineHotSpot.y == 0.0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.lineHotSpot = lineHotSpot

        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
