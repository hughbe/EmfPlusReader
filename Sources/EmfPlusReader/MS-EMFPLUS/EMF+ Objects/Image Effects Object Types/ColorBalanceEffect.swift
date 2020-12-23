//
//  ColorBalanceEffect.swift
//
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.3.3 ColorBalanceEffect Object
/// The ColorBalanceEffect object specifies adjustments to the relative amounts of red, green, and blue in an image.
/// Bitmap images are specified by EmfPlusBitmap objects.
/// See section 2.2.3 for the specification of additional image effects parameter objects.
public struct ColorBalanceEffect {
    public let cyanRed: Int32
    public let magentaGreen: Int32
    public let yellowBlue: Int32
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size == 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        /// CyanRed (4 bytes): A signed integer that specifies a change in the amount of red in the image. This value MUST be in
        /// the range -100 through 100, with effects as follows:
        /// Value Meaning
        /// -100 ≤ value < 0 As the value decreases, the amount of red in the image SHOULD decrease and
        /// the amount of cyan SHOULD increase.
        /// 0 A value of 0 specifies that the amounts of red and cyan MUST NOT change.
        /// 0 < value ≤ 100 As the value increases, the amount of red in the image SHOULD increase
        /// and the amount of cyan SHOULD decrease.
        let cyanRed: Int32 = try dataStream.read(endianess: .littleEndian)
        guard cyanRed >= -100 && cyanRed <= 100 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.cyanRed = cyanRed
        
        /// MagentaGreen (4 bytes): A signed integer that specifies a change in the amount of green in the image.
        /// This value MUST be in the range -100 through 100, with effects as follows:
        /// Value Meaning
        /// -100 ≤ value < 0 As the value decreases, the amount of green in the image SHOULD decrease
        /// and the amount of magenta SHOULD increase.
        /// 0 A value of 0 specifies that the amounts of green and magenta MUST NOT change.
        /// 0 < value ≤ 100 As the value increases, the amount of green in the image SHOULD increase
        /// and the amount of magenta SHOULD decrease.
        let magentaGreen: Int32 = try dataStream.read(endianess: .littleEndian)
        guard magentaGreen >= -100 && magentaGreen <= 100 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.magentaGreen = magentaGreen
        
        /// YellowBlue (4 bytes): A signed integer that specifies a change in the amount of blue in the image.
        /// This value MUST be in the range -100 through 100, with effects as follows:
        /// Value Meaning
        /// -100 ≤ value < 0
        /// As the value decreases, the amount of blue in the image SHOULD decrease and the amount
        /// of yellow SHOULD increase.
        /// 0 A value of 0 specifies that the amounts of blue and yellow MUST NOT change.
        /// 0 < value ≤ 100 As the value increases, the amount of blue in the image SHOULD increase
        /// and the amount of yellow SHOULD decrease.
        let yellowBlue: Int32 = try dataStream.read(endianess: .littleEndian)
        guard yellowBlue >= -100 && yellowBlue <= 100 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.yellowBlue = yellowBlue
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
