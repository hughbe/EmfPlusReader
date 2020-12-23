//
//  CurveAdjustments.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.7 CurveAdjustments Enumeration
/// The CurveAdjustments enumeration defines adjustments that can be applied to the color curve of an image.
/// typedef enum
/// {
///  AdjustExposure = 0x00000000,
///  AdjustDensity = 0x00000001,
///  AdjustContrast = 0x00000002,
///  AdjustHighlight = 0x00000003,
///  AdjustShadow = 0x00000004,
///  AdjustMidtone = 0x00000005,
///  AdjustWhiteSaturation = 0x00000006,
///  AdjustBlackSaturation = 0x00000007
/// } CurveAdjustments;
/// Bitmap images are specified by EmfPlusBitmap objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum CurveAdjustments: UInt32, DataStreamCreatable {
    /// AdjustExposure: Specifies the simulation of increasing or decreasing the exposure of an image.
    case exposure = 0x00000000
    
    /// AdjustDensity: Specifies the simulation of increasing or decreasing the density of an image.
    case density = 0x00000001
    
    /// AdjustContrast: Specifies an increase or decrease of the contrast of an image.
    case contrast = 0x00000002
    
    /// AdjustHighlight: Specifies an increase or decrease of the value of a color channel of an image, if that channel already has a
    /// value that is above half intensity. This adjustment can be used to increase definition in the light areas of an image without
    /// affecting the dark areas.
    case highlight = 0x00000003
    
    /// AdjustShadow: Specifies an increase or decrease of the value of a color channel of an image, if that channel already has a
    /// value that is below half intensity. This adjustment can be used to increase definition in the dark areas of an image without
    /// affecting the light areas.
    case shadow = 0x00000004
    
    /// AdjustMidtone: Specifies an adjustment that lightens or darkens an image. Color channel values in the middle of the intensity
    /// range are altered more than color channel values near the minimum or maximum extremes of intensity. This adjustment can be
    /// used to lighten or darken an image without losing the contrast between the darkest and lightest parts of the image.
    case midtone = 0x00000005
    
    /// AdjustWhiteSaturation: Specifies an adjustment to the white saturation of an image, defined as the maximum value in the range
    /// of intensities for a given color channel, whose range is typically 0 to 255.
    /// For example, a white saturation adjustment value of 240 specifies that color channel values in the range 0 to 240 are adjusted
    /// so that they spread out over the range 0 to 255, with color channel values greater than 240 set to 255.
    case whiteSaturation = 0x00000006

    /// AdjustBlackSaturation: Specifies an adjustment to the black saturation of an image, which is the minimum value in the range of
    /// intensities for a given color channel, which is typically 0 to 255.
    /// For example, a black saturation adjustment value of 15 specifies that color channel values in the range 15 to 255 are adjusted
    /// so that they spread out over the range 0 to 255, with color channel values less than 15 set to 0.
    case blackSaturation = 0x00000007
}
