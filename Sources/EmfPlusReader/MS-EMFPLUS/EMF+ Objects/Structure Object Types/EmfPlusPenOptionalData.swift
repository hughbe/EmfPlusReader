//
//  EmfPlusPenOptionalData.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.34 EmfPlusPenOptionalData Object
/// The EmfPlusPenOptionalData object specifies optional data for a graphics pen.
/// Note: Each field of this object is optional and might not be present in the OptionalData field of an EmfPlusPenData object (section
/// 2.2.2.33), depending on the PenData flags (section 2.1.2.7) set in its PenDataFlags field. Although it is not practical to represent
/// every possible combination of fields present or absent, this section specifies their relative order in the object. The implementer is
/// responsible for determining which fields are actually present in a given metafile record, and for unmarshaling the data for individual
/// fields separately and appropriately.
/// Graphics pens are specified by EmfPlusPen objects.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusPenOptionalData {
    public let transformMatrix: EmfPlusTransformMatrix?
    public let startCap: LineCapType?
    public let endCap: LineCapType?
    public let join: LineJoinType?
    public let miterLimit: Float?
    public let lineStyle: LineStyle?
    public let dashedLineCapType: DashedLineCapType?
    public let dashOffset: Float?
    public let dashedLineData: EmfPlusDashedLineData?
    public let penAlignment: PenAlignment?
    public let compoundLineData: EmfPlusCompoundLineData?
    public let customStartCapData: EmfPlusCustomStartCapData?
    public let customEndCapData: EmfPlusCustomEndCapData?
    
    public init(dataStream: inout DataStream, flags: PenDataFlags, availableSize: UInt32) throws {
        let startPosition = dataStream.position
        
        var remainingSize = availableSize
        
        /// TransformMatrix (24 bytes): An optional EmfPlusTransformMatrix object that specifies a world space to device space
        /// transform for the pen. This field MUST be present if the PenDataTransform flag is set in the PenDataFlags field of the
        /// EmfPlusPenData object.
        if flags.contains(.transform) {
            guard remainingSize >= 24 else {
                throw EmfPlusReadError.corrupted
            }
            
            self.transformMatrix = try EmfPlusTransformMatrix(dataStream: &dataStream)
            remainingSize = availableSize - UInt32(dataStream.position - startPosition)
        } else {
            self.transformMatrix = nil
        }
        
        /// StartCap (4 bytes): An optional signed integer that specifies the shape for the start of a line in the CustomStartCapData field.
        /// This field MUST be present if the PenDataStartCap flag is set in the PenDataFlags field of the EmfPlusPenData object, and
        /// the value is defined in the LineCapType enumeration.
        if flags.contains(.startCap) {
            guard remainingSize >= 0x00000004 else {
                throw EmfPlusReadError.corrupted
            }

            self.startCap = try LineCapType(dataStream: &dataStream)
            remainingSize = availableSize - UInt32(dataStream.position - startPosition)
        } else {
            self.startCap = nil
        }
        
        /// EndCap (4 bytes): An optional signed integer that specifies the shape for the end of a line in the CustomEndCapData field.
        /// This field MUST be present if the PenDataEndCap flag is set in the PenDataFlags field of the EmfPlusPenData object, and
        /// the value is defined in the LineCapType enumeration.
        if flags.contains(.endCap) {
            guard remainingSize >= 0x00000004 else {
                throw EmfPlusReadError.corrupted
            }

            self.endCap = try LineCapType(dataStream: &dataStream)
            remainingSize = availableSize - UInt32(dataStream.position - startPosition)
        } else {
            self.endCap = nil
        }
        
        /// Join (4 bytes): An optional signed integer that specifies how to join two lines that are drawn by the same pen and whose
        /// ends meet. This field MUST be present if the PenDataJoin flag is set in the PenDataFlags field of the EmfPlusPenData
        /// object, and the value is defined in the LineJoinType enumeration.
        if flags.contains(.join) {
            guard remainingSize >= 0x00000004 else {
                throw EmfPlusReadError.corrupted
            }

            self.join = try LineJoinType(dataStream: &dataStream)
            remainingSize = availableSize - UInt32(dataStream.position - startPosition)
        } else {
            self.join = nil
        }
        
        /// MiterLimit (4 bytes): An optional floating-point value that specifies the miter limit, which is the maximum allowed ratio of
        /// miter length to line width. The miter length is the distance from the intersection of the line walls on the inside the join to
        /// the intersection of the line walls outside the join. The miter length can be large when the angle between two lines is small.
        /// This field MUST be present if the PenDataMiterLimit flag is set in the PenDataFlags field of the EmfPlusPenData object.
        if flags.contains(.miterLimit) {
            guard remainingSize >= 0x00000004 else {
                throw EmfPlusReadError.corrupted
            }

            self.miterLimit = try dataStream.readFloat(endianess: .littleEndian)
            remainingSize = availableSize - UInt32(dataStream.position - startPosition)
        } else {
            self.miterLimit = nil
        }
        
        /// LineStyle (4 bytes): An optional signed integer that specifies the style used for lines drawn with this pen object. This field
        /// MUST be present if the PenDataLineStyle flag is set in the PenDataFlags field of the EmfPlusPenData object, and the
        /// value is defined in the LineStyle enumeration.
        if flags.contains(.lineStyle) {
            guard remainingSize >= 0x00000004 else {
                throw EmfPlusReadError.corrupted
            }

            self.lineStyle = try LineStyle(dataStream: &dataStream)
            remainingSize = availableSize - UInt32(dataStream.position - startPosition)
        } else {
            self.lineStyle = nil
        }
        
        /// DashedLineCapType (4 bytes): An optional signed integer that specifies the shape for both ends of each dash in a dashed
        /// line. This field MUST be present if the PenDataDashedLineCap flag is set in the PenDataFlags field of the EmfPlusPenData
        /// object, and the value is defined in the DashedLineCapType enumeration.
        if flags.contains(.dashedLineCap) {
            guard remainingSize >= 0x00000004 else {
                throw EmfPlusReadError.corrupted
            }

            self.dashedLineCapType = try DashedLineCapType(dataStream: &dataStream)
            remainingSize = availableSize - UInt32(dataStream.position - startPosition)
        } else {
            self.dashedLineCapType = nil
        }
        
        /// DashOffset (4 bytes): An optional floating-point value that specifies the distance from the start of a line to the start of the
        /// first space in a dashed line pattern. This field MUST be present if the PenDataDashedLineOffset flag is set in the
        /// PenDataFlags field of the EmfPlusPenData object.
        if flags.contains(.dashedLineOffset) {
            guard remainingSize >= 0x00000004 else {
                throw EmfPlusReadError.corrupted
            }

            self.dashOffset = try dataStream.readFloat(endianess: .littleEndian)
            remainingSize = availableSize - UInt32(dataStream.position - startPosition)
        } else {
            self.dashOffset = nil
        }
        
        /// DashedLineData (variable): An optional EmfPlusDashedLineData object that specifies the lengths of dashes and spaces
        /// in a custom dashed line. This field MUST be present if the PenDataDashedLine flag is set in the PenDataFlags field of the
        /// EmfPlusPenData object.
        if flags.contains(.dashedLine) {
            self.dashedLineData = try EmfPlusDashedLineData(dataStream: &dataStream, availableSize: remainingSize)
            remainingSize = availableSize - UInt32(dataStream.position - startPosition)
        } else {
            self.dashedLineData = nil
        }
        
        /// PenAlignment (4 bytes): An optional signed integer that specifies the distribution of the pen width with respect to the
        /// coordinates of the line being drawn. This field MUST be present if the PenDataNonCenter flag is set in the PenDataFlags
        /// field of the EmfPlusPenData object, and the value is defined in the PenAlignment enumeration.
        /// For example, consider the placement of a line. If the starting and ending coordinates of the line are defined, it is possible
        /// to think of a theoretical line between the two points that is zero width. Center alignment means that the pen width is
        /// distributed as evenly as possible on either side of that theoretical line.
        if flags.contains(.nonCenter) {
            guard remainingSize >= 0x00000004 else {
                throw EmfPlusReadError.corrupted
            }

            self.penAlignment = try PenAlignment(dataStream: &dataStream)
            remainingSize = availableSize - UInt32(dataStream.position - startPosition)
        } else {
            self.penAlignment = nil
        }
        
        /// CompoundLineData (variable): An optional EmfPlusCompoundLineData object that specifies an array of floating-point
        /// values that define the compound line of a pen, which is made up of parallellines and spaces. This field MUST be present
        /// if the PenDataCompoundLine flag is set in the PenDataFlags field of the EmfPlusPenData object.
        if flags.contains(.compoundLine) {
            self.compoundLineData = try EmfPlusCompoundLineData(dataStream: &dataStream, availableSize: remainingSize)
            remainingSize = availableSize - UInt32(dataStream.position - startPosition)
        } else {
            self.compoundLineData = nil
        }
        
        /// CustomStartCapData (variable): An optional EmfPlusCustomStartCapData object that defines the custom start-cap shape,
        /// which is the shape to use at the start of a line drawn with this pen. It can be any of various shapes, such as a square,
        /// circle, or diamond. This field MUST be present if the PenDataCustomStartCap flag is set in the PenDataFlags field of the
        /// EmfPlusPenData object.
        if flags.contains(.customStartCap) {
            self.customStartCapData = try EmfPlusCustomStartCapData(dataStream: &dataStream, availableSize: remainingSize)
            remainingSize = availableSize - UInt32(dataStream.position - startPosition)
        } else {
            self.customStartCapData = nil
        }
        
        /// CustomEndCapData (variable): An optional EmfPlusCustomEndCapData object that defines the custom end-cap shape,
        /// which is the shape to use at the end of a line drawn with this pen. It can be any of various shapes, such as a square, circle,
        /// or diamond. This field MUST be present if the PenDataCustomEndCap flag is set in the PenDataFlags field of the
        /// EmfPlusPenData object.
        if flags.contains(.customEndCap) {
            self.customEndCapData = try EmfPlusCustomEndCapData(dataStream: &dataStream, availableSize: remainingSize)
            remainingSize = availableSize - UInt32(dataStream.position - startPosition)
        } else {
            self.customEndCapData = nil
        }
        
        guard dataStream.position - startPosition <= availableSize else {
            throw EmfPlusReadError.corrupted
        }
    }
}
