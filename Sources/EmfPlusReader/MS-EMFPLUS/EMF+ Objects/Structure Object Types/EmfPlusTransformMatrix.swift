//
//  EmfPlusTransformMatrix.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.47 EmfPlusTransformMatrix Object
/// The EmfPlusTransformMatrix object specifies a world space to device space transform.
public struct EmfPlusTransformMatrix {
    public let m11: Float
    public let m12: Float
    public let m21: Float
    public let m22: Float
    public let dx: Float
    public let dy: Float
    
    public init(dataStream: inout DataStream) throws {
        /// TransformMatrix (24 bytes): An affine transform, which requires a 2x2 matrix for a linear
        /// transformation and a 1x2 matrix for a translation. These values map to the coordinates of the
        /// transform matrix as follows:
        ///  TransformMatrix[0] Corresponds to m11, which is the coordinate of the first row and first column of the 2x2 matrix.
        ///  TransformMatrix[1] Corresponds to m12, which is the coordinate of the first row and second column of the 2x2 matrix.
        ///  TransformMatrix[2] Corresponds to m21, which is the coordinate of the second row and first column of the 2x2 matrix.
        ///  TransformMatrix[3] Corresponds to m22, which is the coordinate of the second row and second column of the 2x2 matrix.
        ///  TransformMatrix[4] Corresponds to dx, which is the horizontal displacement in the 1x2 matrix.
        ///  TransformMatrix[5] Corresponds to dy, which is the vertical displacement in the 1x2 matrix.
        self.m11 = try dataStream.readFloat(endianess: .littleEndian)
        self.m12 = try dataStream.readFloat(endianess: .littleEndian)
        self.m21 = try dataStream.readFloat(endianess: .littleEndian)
        self.m22 = try dataStream.readFloat(endianess: .littleEndian)
        self.dx = try dataStream.readFloat(endianess: .littleEndian)
        self.dy = try dataStream.readFloat(endianess: .littleEndian)
    }
}
