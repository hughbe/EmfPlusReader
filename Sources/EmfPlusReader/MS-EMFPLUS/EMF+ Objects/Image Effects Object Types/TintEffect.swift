//
//  TintEffect.swift
//
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.3.11 TintEffect Object
/// The TintEffect object specifies an addition of black or white to a specified hue in an image.
/// Bitmap images are specified by EmfPlusBitmap objects.
/// See section 2.2.3 for the specification of additional image effects parameter objects.
public struct TintEffect {
    public let hue: Int32
    public let amount: Int32
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size == 0x00000008 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Hue (4 bytes): A signed integer that specifies the hue to which the tint effect is applied.
        /// Value Meaning
        /// -180 ≤ value < 0 The color at a specified counter-clockwise rotation of the color wheel, starting from blue.
        /// 0 A value of 0 specifies the color blue on the color wheel.
        /// 0 < value ≤ 180 The color at a specified clockwise rotation of the color wheel, starting from blue.
        let hue: Int32 = try dataStream.read(endianess: .littleEndian)
        guard hue >= -180 && hue <= 180 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.hue = hue
        
        /// Amount (4 bytes): A signed integer that specifies how much the hue is strengthened or weakened.
        /// Value Meaning
        /// -100 ≤ value < 0 Negative values specify how much the hue is weakened, which equates to the
        /// addition of black.
        /// 0 A value of 0 specifies that the tint MUST NOT change.
        /// 0 < value ≤ 100 Positive values specify how much the hue is strengthened, which equates
        /// to the addition of white.
        let amount: Int32 = try dataStream.read(endianess: .littleEndian)
        guard amount >= -100 && amount <= 100 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.amount = amount
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
