//
//  LineStyle.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.19 LineStyle Enumeration
/// The LineStyle enumeration defines styles of lines that are drawn with graphics pens.
/// typedef enum
/// {
///  LineStyleSolid = 0x00000000,
///  LineStyleDash = 0x00000001,
///  LineStyleDot = 0x00000002,
///  LineStyleDashDot = 0x00000003,
///  LineStyleDashDotDot = 0x00000004,
///  LineStyleCustom = 0x00000005
/// } LineStyle;
/// Graphics lines are specified by EmfPlusPen objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum LineStyle: UInt32, DataStreamCreatable {
    /// LineStyleSolid: Specifies a solid line.
    case solid = 0x00000000

    /// LineStyleDash: Specifies a dashed line.
    case dash = 0x00000001

    /// LineStyleDot: Specifies a dotted line.
    case dot = 0x00000002

    /// LineStyleDashDot: Specifies an alternating dash-dot line.
    case dashDot = 0x00000003

    /// LineStyleDashDotDot: Specifies an alternating dash-dot-dot line.
    case dashDotDot = 0x000000004

    /// LineStyleCustom: Specifies a user-defined, custom dashed line.
    case custom = 0x00000005
}
