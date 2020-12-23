//
//  CustomLineCapDataType.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.9 CustomLineCapDataType Enumeration
/// The CustomLineCapDataType enumeration defines types of custom line cap data, which specify styles and shapes for the ends of
/// graphics lines.
/// typedef enum
/// {
///  CustomLineCapDataTypeDefault = 0x00000000,
///  CustomLineCapDataTypeAdjustableArrow = 0x00000001
/// } CustomLineCapDataType;
/// Custom line cap data is specified by EmfPlusCustomLineCap objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum CustomLineCapDataType: UInt32, DataStreamCreatable {
    /// CustomLineCapDataTypeDefault: Specifies a default custom line cap.
    case `default` = 0x00000000
    
    /// CustomLineCapDataTypeAdjustableArrow: Specifies an adjustable arrow custom line cap.
    case adjustableArrow = 0x00000001
}
