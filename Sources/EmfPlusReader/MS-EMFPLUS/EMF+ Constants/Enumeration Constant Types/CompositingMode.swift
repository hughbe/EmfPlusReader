//
//  CompositingMode.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.5 CompositingMode Enumeration
/// The CompositingMode enumeration defines modes for combining source colors with background colors. The compositing mode
/// represents the enable state of alpha blending.
/// typedef enum
/// {
///  CompositingModeSourceOver = 0x00,
///  CompositingModeSourceCopy = 0x01
/// } CompositingMode;
/// Graphics colors are specified by EmfPlusARGB objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum CompositingMode: UInt8, DataStreamCreatable {
    /// CompositingModeSourceOver: Enables alpha blending, which specifies that when a color is rendered, it is blended with the
    /// background color. The extent of blending is determined by the value of the alpha component of the color being rendered.
    case sourceOver = 0x00
    
    /// CompositingModeSourceCopy: Disables alpha blending, which means that when a source color is rendered, it overwrites the
    /// background color.
    case sourceCopy = 0x01
}
