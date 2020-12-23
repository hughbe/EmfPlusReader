//
//  UnitType.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.32 UnitType Enumeration
/// The UnitType enumeration defines units of measurement in different coordinate systems.
/// typedef enum
/// {
///  UnitTypeWorld = 0x00,
///  UnitTypeDisplay = 0x01,
///  UnitTypePixel = 0x02,
///  UnitTypePoint = 0x03,
///  UnitTypeInch = 0x04,
///  UnitTypeDocument = 0x05,
///  UnitTypeMillimeter = 0x06
/// } UnitType;
/// See section 2.1.1 for the specification of additional enumerations.
public enum UnitType: UInt8, DataStreamCreatable {
    /// UnitTypeWorld: Specifies a unit of logical distance within the world space.
    case world = 0x00
    
    /// UnitTypeDisplay: Specifies a unit of distance based on the characteristics of the physical display.
    case display = 0x01
    
    /// UnitTypePixel: Specifies a unit of 1 pixel.
    case pixel = 0x02
    
    /// UnitTypePoint: Specifies a unit of 1 printer's point, or 1/72 inch.
    case point = 0x03
    
    /// UnitTypeInch: Specifies a unit of 1 inch.
    case inch = 0x04
    
    /// UnitTypeDocument: Specifies a unit of 1/300 inch.
    case document = 0x05
    
    /// UnitTypeMillimeter: Specifies a unit of 1 millimeter.
    case millimeter = 0x06
}
