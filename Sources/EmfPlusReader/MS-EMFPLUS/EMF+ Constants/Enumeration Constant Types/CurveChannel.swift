//
//  CurveChannel.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.8 CurveChannel Enumeration
/// The CurveChannel enumeration defines color channels that can be affected by a color curve effect adjustment to an image.
/// typedef enum
/// {
///  CurveChannelAll = 0x00000000,
///  CurveChannelRed = 0x00000001,
///  CurveChannelGreen = 0x00000002,
///  CurveChannelBlue = 0x00000003
/// } CurveChannel;
/// Bitmap images are specified by EmfPlusBitmap objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum CurveChannel: UInt32, DataStreamCreatable {
    /// CurveChannelAll: Specifies that a color curve adjustment applies to all color channels.
    case all = 0x00000000
    
    /// CurveChannelRed: Specifies that a color curve adjustment applies only to the red color channel.
    case red = 0x00000001
    
    /// CurveChannelGreen: Specifies that a color curve adjustment applies only to the green color channel.
    case green = 0x00000002
    
    /// CurveChannelBlue: Specifies that a color curve adjustment applies only to the blue color channel.
    case blue = 0x00000003
}
