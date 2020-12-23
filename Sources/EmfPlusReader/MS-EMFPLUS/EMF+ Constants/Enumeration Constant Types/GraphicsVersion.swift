//
//  GraphicsVersion.swift
//  
//
//  Created by Hugh Bellamy on 16/12/2020.
//

/// [MS-EMFLUS] 2.1.1.12 GraphicsVersion Enumeration
/// The GraphicsVersion enumeration defines versions of operating system graphics that are used to create EMF+ metafiles.
/// typedef enum
/// {
///  GraphicsVersion1 = 0x0001,
///  GraphicsVersion1_1 = 0x0002
/// } GraphicsVersion;
/// Graphics versions are specified in EmfPlusGraphicsVersion objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum GraphicsVersion: UInt16 {
    /// GraphicsVersion1: Specifies GDI+ version 1.0.
    case version1 = 0x0001
    
    /// GraphicsVersion1_1: Specifies GDI+ version 1.1.<3>
    case version1_1 = 0x0002
    
    case unknown = 0xFFFF
}
