//
//  ColorMatrixEffect.swift
//
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.3.6 ColorMatrixEffect Object
/// The ColorMatrixEffect object specifies an affine transform to be applied to an image.
/// Bitmap images are specified by EmfPlusBitmap objects. A color matrix effect is performed by multiplying a color vector by a
/// ColorMatrixEffect object. A 5x5 color matrix can perform a linear transform, including reflection, rotation, shearing, or scaling
/// followed by a translation.
/// See section 2.2.3 for the specification of additional image effects parameter objects.
public struct ColorMatrixEffect {
    public let m: [Float]
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        /// Matrix_N_0 (20 bytes): Matrix[N][0] of the 5x5 color matrix. This row is used for transforms.
        /// Matrix_0_0 (4 bytes): Matrix[0][0], which is the factor for the color red.
        /// Matrix_1_0 (4 bytes): Matrix[1][0].
        /// Matrix_2_0 (4 bytes): Matrix[2][0].
        /// Matrix_3_0 (4 bytes): Matrix[3][0].
        /// Matrix_4_0 (4 bytes): Matrix[4][0]. This value MUST be 0.0.
        /// Matrix_N_1 (20 bytes): Matrix[N][1] of the 5x5 color matrix. This row is used for transforms.
        /// Matrix_0_1 (4 bytes): Matrix[0][1].
        /// Matrix_1_1 (4 bytes): Matrix[1][1], which is the factor for the color green.
        /// Matrix_2_1 (4 bytes): Matrix[2][1].
        /// Matrix_3_1 (4 bytes): Matrix[3][1].
        /// Matrix_4_1 (4 bytes): Matrix[4][1]. This value MUST be 0.0.
        /// Matrix_N_2 (20 bytes): Matrix[N][2] of the 5x5 color matrix. This row is used for transforms.
        /// Matrix_0_2 (4 bytes): Matrix[0][2].
        /// Matrix_1_2 (4 bytes): Matrix[1][2].
        /// Matrix_2_2 (4 bytes): Matrix[2][2], which is the factor for the color blue.
        /// Matrix_3_2 (4 bytes): Matrix[3][2].
        /// Matrix_4_2 (4 bytes): Matrix[4][2]. This value MUST be 0.0.
        /// Matrix_N_3 (20 bytes): Matrix[N][3] of the 5x5 color matrix. This row is used for transforms.
        /// Matrix_0_3 (4 bytes): Matrix[0][3].
        /// Matrix_1_3 (4 bytes): Matrix[1][3].
        /// Matrix_2_3 (4 bytes): Matrix[2][3].
        /// Matrix_3_3 (4 bytes): Matrix[3][3], which is the factor for the alpha (transparency) value.
        /// Matrix_4_3 (4 bytes): Matrix[4][3]. This value MUST be 0.0.
        /// Matrix_N_4 (20 bytes): Matrix[N][4] of the 5x5 color matrix. This row is used for color translations.
        /// Matrix_0_4 (4 bytes): Matrix[0][4].
        /// Matrix_1_4 (4 bytes): Matrix[1][4].
        /// Matrix_2_4 (4 bytes): Matrix[2][4].
        /// Matrix_3_4 (4 bytes): Matrix[3][4].
        /// Matrix_4_4 (4 bytes): Matrix[4][4]. This value SHOULD be 1.0.<17>
        var m: [Float] = []
        m.reserveCapacity(Int(25))
        for _ in 0..<25 {
            m.append(try dataStream.readFloat(endianess: .littleEndian))
        }
        
        self.m = m
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
