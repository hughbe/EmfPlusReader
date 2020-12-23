//
//  LevelsEffect.swift
//
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.3.8 LevelsEffect Object
/// The LevelsEffect object specifies adjustments to the highlights, midtones, and shadows of an image.
/// Bitmap images are specified by EmfPlusBitmap objects.
/// See section 2.2.3 for the specification of additional image effects parameter objects.
public struct LevelsEffect {
    public let highlight: Int32
    public let midTone: Int32
    public let shadow: Int32
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size == 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Highlight (4 bytes): Specifies how much to lighten the highlights of an image. The color channel values at the high end
        /// of the intensity range are altered more than values near the middle or low ends, which means an image can be lightened
        /// without losing the contrast between the darker portions of the image.
        /// Value Meaning
        /// 0 ≤ value < 100 Specifies that highlights with a percent of intensity above this threshold SHOULD be increased.
        /// 100 Specifies that highlights MUST NOT change.
        let highlight: Int32 = try dataStream.read(endianess: .littleEndian)
        guard highlight >= 0 && highlight <= 100 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.highlight = highlight
        
        /// MidTone (4 bytes): Specifies how much to lighten or darken the midtones of an image. Color channel values in the middle
        /// of the intensity range are altered more than values near the high or low ends, which means an image can be lightened or
        /// darkened without losing the contrast between the darkest and lightest portions of the image.
        /// Value Meaning
        /// -100 ≤ value < 0 Specifies that midtones are made darker.
        /// 0 Specifies that midtones MUST NOT change.
        /// 0 < value ≤ 100 Specifies that midtones are made lighter.
        let midTone: Int32 = try dataStream.read(endianess: .littleEndian)
        guard midTone >= -100 && midTone <= 100 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.midTone = midTone
        
        /// Shadow (4 bytes): Specifies how much to darken the shadows of an image. Color channel values at the low end of the
        /// intensity range are altered more than values near the middle or high ends, which means an image can be darkened
        /// without losing the contrast between the lighter portions of the image.
        /// Value Meaning
        /// 0 Specifies that shadows MUST NOT change.
        /// 0 < value ≤ 100 Specifies that shadows with a percent of intensity below this threshold are made darker.
        let shadow: Int32 = try dataStream.read(endianess: .littleEndian)
        guard shadow >= 0 && shadow <= 100 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.shadow = shadow
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
