//
//  FilterType.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.11 FilterType Enumeration
/// The FilterType enumeration defines types of filtering algorithms that can be used for text and graphics quality enhancement and
/// image rendering.
/// typedef enum
/// {
///  FilterTypeNone = 0x00,
///  FilterTypePoint = 0x01,
///  FilterTypeLinear = 0x02,
///  FilterTypeTriangle = 0x03,
///  FilterTypeBox = 0x04,
///  FilterTypePyramidalQuad = 0x06,
///  FilterTypeGaussianQuad = 0x07
/// } FilterType;
/// See section 2.1.1 for the specification of additional enumerations.
public enum FilterType: UInt8, DataStreamCreatable {
    /// FilterTypeNone: Specifies that filtering is not performed.
    case none = 0x00
    
    /// FilterTypePoint: Specifies that each destination pixel is computed by sampling the nearest pixel from the source image.
    case point = 0x01

    /// FilterTypeLinear: Specifies that linear interpolation is performed using the weighted average of a 2x2 area of pixels surrounding
    /// the source pixel.
    case linear = 0x02
    
    /// FilterTypeTriangle: Specifies that each pixel in the source image contributes equally to the destination image. This is the slowest
    /// of filtering algorithms.
    case triangle = 0x03
    
    /// FilterTypeBox: Specifies a box filter algorithm, in which each destination pixel is computed by averaging a rectangle of source
    /// pixels. This algorithm is useful only when reducing the size of an image.
    case box = 0x04
    
    /// FilterTypePyramidalQuad: Specifies that a 4-sample tent filter is used.
    case pyramidalQuad = 0x06
    
    /// FilterTypeGaussianQuad: Specifies that a 4-sample Gaussian filter is used, which creates a blur effect on an image.
    case gaussianQuad = 0x07
}
