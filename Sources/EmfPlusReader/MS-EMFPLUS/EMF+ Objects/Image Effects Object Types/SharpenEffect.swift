//
//  SharpenEffect.swift
//
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.3.10 SharpenEffect Object
/// The SharpenEffect object specifies an increase in the difference in intensity between pixels in an image.
/// Bitmap images are specified by EmfPlusBitmap objects.
/// See section 2.2.3 for the specification of additional image effects parameter objects.
public struct SharpenEffect {
    public let radius: Float
    public let amount: Float
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size == 0x00000008 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Radius (4 bytes): A floating-point number that specifies the sharpening radius in pixels, which determines the number of
        /// pixels involved in calculating the new value of a given pixel.
        /// As this value increases, the number of pixels involved in the calculation increases, and the resulting bitmap SHOULD
        /// become sharper.
        self.radius = try dataStream.readFloat(endianess: .littleEndian)
        
        /// Amount (4 bytes): A floating-point number that specifies the difference in intensity between a given pixel and the
        /// surrounding pixels.
        /// Value Meaning
        /// 0 Specifies that sharpening MUST NOT be performed.
        /// 0 < value ≤ 100 As this value increases, the difference in intensity between pixels SHOULD increase.
        let amount = try dataStream.readFloat(endianess: .littleEndian)
        guard amount >= 0.0 && amount <= 100.0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.amount = amount
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
