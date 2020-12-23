//
//  BlurEffect.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.3.1 BlurEffect Object
/// The BlurEffect object specifies a decrease in the difference in intensity between pixels in an image.
/// Bitmap images are specified by EmfPlusBitmap objects.
/// See section 2.2.3 for the specification of additional image effects parameter objects.
public struct BlurEffect {
    public let blurRadius: Float
    public let expandEdge: Bool
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size == 0x00000008 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// BlurRadius (4 bytes): A floating-point number that specifies the blur radius in pixels, which determines the number of
        /// pixels involved in calculating the new value of a given pixel. This value MUST be in the range 0.0 through 255.0.
        /// As this value increases, the number of pixels involved in the calculation increases, and the resulting bitmap SHOULD
        /// become more blurry.
        let blurRadius: Float = try dataStream.readFloat(endianess: .littleEndian)
        guard blurRadius >= 0.0 && blurRadius <= 255.0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.blurRadius = blurRadius
        
        /// ExpandEdge (4 bytes): A Boolean value that specifies whether the bitmap expands by an amount equal to the value of
        /// the BlurRadius to produce soft edges. This value MUST be one of the following:
        /// Value Meaning
        /// FALSE 0x00000000 The size of the bitmap MUST NOT change, and its soft edges SHOULD be clipped to the size of the
        /// BlurRadius.
        /// TRUE 0x00000001 The size of the bitmap SHOULD expand by an amount equal to the BlurRadius to produce
        /// soft edges.
        self.expandEdge = (try dataStream.read(endianess: .littleEndian) as UInt32) != 0x00000000
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
