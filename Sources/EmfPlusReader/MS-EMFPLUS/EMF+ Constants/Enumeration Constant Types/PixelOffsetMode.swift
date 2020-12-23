//
//  PixelOffsetMode.swift
//  
//
//  Created by Hugh Bellamy on 16/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.25 PixelOffsetMode Enumeration
/// The PixelOffsetMode enumeration defines how pixels are offset, which specifies the trade-off between rendering speed and quality.
/// typedef enum
/// {
///  PixelOffsetModeDefault = 0x00,
///  PixelOffsetModeHighSpeed = 0x01,
///  PixelOffsetModeHighQuality = 0x02,
///  PixelOffsetModeNone = 0x03,
///  PixelOffsetModeHalf = 0x04
/// } PixelOffsetMode;
/// See section 2.1.1 for the specification of additional enumerations.
public enum PixelOffsetMode: UInt8, DataStreamCreatable {
    /// PixelOffsetModeDefault: Pixels are centered on integer coordinates, specifying speed over quality.
    case `default` = 0x00
    
    /// PixelOffsetModeHighSpeed: Pixels are centered on integer coordinates, as with PixelOffsetModeNone. Higher speed at the
    /// expense of quality is specified.
    case highSpeed = 0x01
    
    /// PixelOffsetModeHighQuality: Pixels are centered on half-integer coordinates, as with PixelOffsetModeHalf. Higher quality at
    /// the expense of speed is specified.
    case highQuality = 0x02
    
    /// PixelOffsetModeNone: Pixels are centered on the origin, which means that the pixel covers the area from -0.5 to 0.5 on both
    /// the x and y axes and its center is at (0,0).
    case none = 0x03
    
    /// PixelOffsetModeHalf: Pixels are centered on half-integer coordinates, which means that the pixel covers the area from 0 to 1
    /// on both the x and y axes and its center is at (0.5,0.5). By offsetting pixels during rendering, the render quality can be improved
    /// at the cost of render speed.
    case half = 0x04
}
