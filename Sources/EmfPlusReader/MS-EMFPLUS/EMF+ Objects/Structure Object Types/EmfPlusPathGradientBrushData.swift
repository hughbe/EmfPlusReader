//
//  EmfPlusPathGradientBrushData.swift
//
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.29 EmfPlusPathGradientBrushData Object
/// The EmfPlusPathGradientBrushData object specifies a path gradient for a graphics brush.
/// Graphics brushes are specified by EmfPlusBrush objects. A path gradient brush paints a color gradient in which the color changes
/// gradually along a gradient line from the center point outward to the boundary, which are specified by either a closed cardinal spline
/// or a path in the BoundaryData field.
/// Gamma correction controls the overall brightness and intensity of an image. Uncorrected images can look either bleached out or
/// too dark. Varying the amount of gamma correction changes not only the brightness but also the ratios of red to green to blue.
/// The need for gamma correction arises because an output device might not render colors in the same intensity as the input image.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusPathGradientBrushData {
    public let brushDataFlags: BrushDataFlags
    public let wrapMode: WrapMode
    public let centerColor: EmfPlusARGB
    public let centerPointF: EmfPlusPointF
    public let surroundingColorCount: UInt32
    public let surroundingColor: [EmfPlusARGB]
    public let boundaryData: BoundaryData
    public let optionalData: EmfPlusPathGradientBrushOptionalData
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size >= 0x00000018 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// BrushDataFlags (4 bytes): An unsigned integer that specifies the data in the OptionalData field.
        /// This value is composed of BrushData flags. The following flags are relevant to a path gradient brush:
        /// Name Value
        /// BrushDataPath 0x00000001
        /// BrushDataTransform 0x00000002
        /// BrushDataPresetColors 0x00000004
        /// BrushDataBlendFactorsH 0x00000008
        /// BrushDataFocusScales 0x00000040
        /// BrushDataIsGammaCorrected 0x00000080
        self.brushDataFlags = try BrushDataFlags(dataStream: &dataStream)
        
        /// WrapMode (4 bytes): A signed integer from the WrapMode enumeration that specifies whether to paint the area outside the
        /// boundary of the brush. When painting outside the boundary, the wrap mode specifies how the color gradient is repeated.
        self.wrapMode = try WrapMode(dataStream: &dataStream)
        
        /// CenterColor (4 bytes): An EmfPlusARGB object that specifies the center color of the path gradient brush, which is the
        /// color that appears at the center point of the brush. The color of the brush changes gradually from the boundary color
        /// to the center color as it moves from the boundary to the center point.
        self.centerColor = try EmfPlusARGB(dataStream: &dataStream)
        
        /// CenterPointF (8 bytes): An EmfPlusPointF object that specifies the center point of the path gradient brush, which can be
        /// any location inside or outside the boundary. The color of the brush changes gradually from the boundary color to the
        /// center color as it moves from the boundary to the center point.
        self.centerPointF = try EmfPlusPointF(dataStream: &dataStream)
        
        /// SurroundingColorCount (4 bytes): An unsigned integer that specifies the number of colors specified in the SurroundingColor
        /// field. The surrounding colors are colors specified for discrete points on the boundary of the brush.
        self.surroundingColorCount = try dataStream.read(endianess: .littleEndian)
        guard 0x00000018 + self.surroundingColorCount * 4 <= size else {
            throw EmfPlusReadError.corrupted
        }
        
        /// SurroundingColor (variable): An array of SurroundingColorCount EmfPlusARGB objects that specify the colors for discrete
        /// points on the boundary of the brush.
        var surroundingColor: [EmfPlusARGB] = []
        surroundingColor.reserveCapacity(Int(self.surroundingColorCount))
        for _ in 0..<self.surroundingColorCount {
            surroundingColor.append(try EmfPlusARGB(dataStream: &dataStream))
        }
        
        self.surroundingColor = surroundingColor
        
        /// BoundaryData (variable): The boundary of the path gradient brush, which is specified by either a path or a closed cardinal
        /// spline. If the BrushDataPath flag is set in the BrushDataFlags field, this field MUST contain an EmfPlusBoundaryPathData
        /// object; otherwise, this field MUST contain an EmfPlusBoundaryPointData object.
        let remainingSizeForBoundaryData = size - UInt32(dataStream.position - startPosition)
        if self.brushDataFlags.contains(.path) {
            self.boundaryData = .path(try EmfPlusBoundaryPathData(dataStream: &dataStream, availableSize: remainingSizeForBoundaryData))
        } else {
            self.boundaryData = .points(try EmfPlusBoundaryPointData(dataStream: &dataStream, availableSize: remainingSizeForBoundaryData))
        }
        
        /// OptionalData (variable): An optional EmfPlusPathGradientBrushOptionalData object that specifies additional data for the
        /// path gradient brush. The specific contents of this field are determined by the value of the BrushDataFlags field.
        let remainingSizeForOptionalData = size - UInt32(dataStream.position - startPosition)
        self.optionalData = try EmfPlusPathGradientBrushOptionalData(dataStream: &dataStream, flags: self.brushDataFlags, size: remainingSizeForOptionalData)
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// BoundaryData (variable): The boundary of the path gradient brush, which is specified by either a path or a closed cardinal
    /// spline. If the BrushDataPath flag is set in the BrushDataFlags field, this field MUST contain an EmfPlusBoundaryPathData
    /// object; otherwise, this field MUST contain an EmfPlusBoundaryPointData object.
    public enum BoundaryData {
        case path(_: EmfPlusBoundaryPathData)
        case points(_: EmfPlusBoundaryPointData)
    }
}
