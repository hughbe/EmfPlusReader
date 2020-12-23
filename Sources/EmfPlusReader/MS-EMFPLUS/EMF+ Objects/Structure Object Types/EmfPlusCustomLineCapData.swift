//
//  EmfPlusCustomLineCapData.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.13 EmfPlusCustomLineCapData Object
/// The EmfPlusCustomLineCapData object specifies default data for a custom line cap.
public struct EmfPlusCustomLineCapData {
    public let flags: CustomLineCapDataFlags
    public let baseCap: LineCapType
    public let baseInset: Float
    public let strokeStartCap: LineCapType
    public let strokeEndCap: LineCapType
    public let strokeJoin: LineJoinType
    public let strokeMiterLimit: Float
    public let widthScale: Float
    public let fillHotSpot: EmfPlusPointF
    public let strokeHotSpot: EmfPlusPointF
    public let optionalData: EmfPlusCustomLineCapOptionalData

    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size >= 0x00000030 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// CustomLineCapDataFlags (4 bytes): An unsigned integer that specifies the data in the OptionalData field.
        /// This value is composed of CustomLineCapData flags.
        self.flags = try CustomLineCapDataFlags(dataStream: &dataStream)
        
        /// BaseCap (4 bytes): An unsigned integer that specifies the value from the LineCap enumeration on which the custom line
        /// cap is based.
        self.baseCap = try LineCapType(dataStream: &dataStream)
        
        /// BaseInset (4 bytes): A floating-point value that specifies the distance between the beginning of the line cap and the end of
        /// the line.
        self.baseInset = try dataStream.readFloat(endianess: .littleEndian)
        
        /// StrokeStartCap (4 bytes): An unsigned integer that specifies the value in the LineCap enumeration that indicates the line
        /// cap used at the start of the line to be drawn.
        self.strokeStartCap = try LineCapType(dataStream: &dataStream)
        
        /// StrokeEndCap (4 bytes): An unsigned integer that specifies the value in the LineCap enumeration that indicates what line
        /// cap is to be used at the end of the line to be drawn.
        self.strokeEndCap = try LineCapType(dataStream: &dataStream)
        
        /// StrokeJoin (4 bytes): An unsigned integer that specifies the value in the LineJoin enumeration, which specifies how to join
        /// two lines that are drawn by the same pen and whose ends meet. At the intersection of the two line ends, a line join makes
        /// the connection look more continuous.
        self.strokeJoin = try LineJoinType(dataStream: &dataStream)
        
        /// StrokeMiterLimit (4 bytes): A floating-point value that contains the limit of the thickness of the join on a mitered corner by
        /// setting the maximum allowed ratio of miter length to line width.
        self.strokeMiterLimit = try dataStream.readFloat(endianess: .littleEndian)
        
        /// WidthScale (4 bytes): A floating-point value that specifies the amount by which to scale the custom line cap with respect
        /// to the width of the EmfPlusPen object that is used to draw the lines.
        self.widthScale = try dataStream.readFloat(endianess: .littleEndian)
        
        /// FillHotSpot (8 bytes): An EmfPlusPointF object that is not currently used. It MUST be set to {0.0, 0.0}.
        let fillHotSpot = try EmfPlusPointF(dataStream: &dataStream)
        guard fillHotSpot.x == 0 && fillHotSpot.y == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.fillHotSpot = fillHotSpot
        
        /// StrokeHotSpot (8 bytes): An EmfPlusPointF object that is not currently used. It MUST be set to {0.0, 0.0}.
        let strokeHotSpot = try EmfPlusPointF(dataStream: &dataStream)
        guard strokeHotSpot.x == 0 && strokeHotSpot.y == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.strokeHotSpot = strokeHotSpot
        
        /// OptionalData (variable): An optional EmfPlusCustomLineCapOptionalData object that specifies additional data for the
        /// custom graphics line cap. The specific contents of this field are determined by the value of the CustomLineCapDataFlags
        /// field.
        self.optionalData = try EmfPlusCustomLineCapOptionalData(dataStream: &dataStream, flags: self.flags, size: size - 0x00000030)
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
