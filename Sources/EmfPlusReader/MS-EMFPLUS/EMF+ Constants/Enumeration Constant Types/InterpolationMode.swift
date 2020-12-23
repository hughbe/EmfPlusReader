//
//  InterpolationMode.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS} 2.1.1.16 InterpolationMode Enumeration
/// The InterpolationMode enumeration defines ways to perform scaling, including stretching and
/// shrinking.
/// typedef enum
/// {
///  InterpolationModeDefault = 0x00,
///  InterpolationModeLowQuality = 0x01,
///  InterpolationModeHighQuality = 0x02,
///  InterpolationModeBilinear = 0x03,
///  InterpolationModeBicubic = 0x04,
///  InterpolationModeNearestNeighbor = 0x05,
///  InterpolationModeHighQualityBilinear = 0x06,
///  InterpolationModeHighQualityBicubic = 0x07
/// } InterpolationMode;
/// To stretch an image, each pixel in the original image SHOULD be mapped to a group of pixels in the larger image. To shrink an image,
/// groups of pixels in the original image SHOULD be mapped to single pixels in the smaller image. The effectiveness of the algorithm
/// that performs these mappings determines the quality of a scaled image. Higher-quality interpolation generally uses more data points
/// and requires more processing time than lower-quality interpolation.
/// See section 2.1.1 for the specification of additional enumerations.
public enum InterpolationMode: UInt8, DataStreamCreatable {
    /// InterpolationModeDefault: Specifies the default interpolation mode, which is defined as InterpolationModeBilinear.
    case `default` = 0x00
    
    /// InterpolationModeLowQuality: Specifies a low-quality interpolation mode, which is defined as InterpolationModeNearestNeighbor.
    case lowQuality = 0x01
    
    /// InterpolationModeHighQuality: Specifies a high-quality interpolation mode, which is defined as
    /// InterpolationModeHighQualityBicubic.
    case highQuality = 0x02
    
    /// InterpolationModeBilinear: Specifies bilinear interpolation, which uses the closest 2x2 neighborhood of known pixels surrounding
    /// the interpolated pixel. The weighted average of these 4 known pixel values determines the value to assign to the interpolated
    /// pixel. The result is smoother looking than InterpolationModeNearestNeighbor.
    case bilinear = 0x03
    
    /// InterpolationModeBicubic: Specifies bicubic interpolation, which uses the closest 4x4 neighborhood of known pixels surrounding
    /// the interpolated pixel. The weighted average of these 16 known pixel values determines the value to assign to the interpolated
    /// pixel. Because the known pixels are likely to be at varying distances from the interpolated pixel, closer pixels are given a higher
    /// weight in the calculation. The result is smoother looking than InterpolationModeBilinear.
    case bicubic = 0x04
    
    /// InterpolationModeNearestNeighbor: Specifies nearest-neighbor interpolation, which uses only the value of the pixel that is
    /// closest to the interpolated pixel. This mode simply duplicates or removes pixels, producing the lowest-quality result among
    /// these options.
    case nearestNeighbor = 0x05
    
    /// InterpolationModeHighQualityBilinear: Specifies bilinear interpolation with prefiltering.
    case highQualityBilinear = 0x06

    /// InterpolationModeHighQualityBicubic: Specifies bicubic interpolation with prefiltering, which produces the highest-quality result
    /// among these options.
    case highQualityBicubic = 0x07
}
