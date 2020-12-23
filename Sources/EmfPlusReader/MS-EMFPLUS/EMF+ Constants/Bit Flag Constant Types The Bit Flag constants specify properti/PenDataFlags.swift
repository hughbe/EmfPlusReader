//
//  PenDataFlags.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.1.2.7 PenData Flags
/// The PenData flags specify properties of graphics pens, including the presence of optional data fields.
/// These flags can be combined to specify multiple options.
/// Graphics pens are specified by EmfPlusPen objects.
/// See section 2.1.2 for the specification of additional bit flags.
public struct PenDataFlags: OptionSet {
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public init(dataStream: inout DataStream) throws {
        self.rawValue = try dataStream.read(endianess: .littleEndian)
    }
    
    /// PenDataTransform 0x00000001
    /// If set, a 2x3 transform matrix is specified in the OptionalData field of an EmfPlusPenData object.
    public static let transform = PenDataFlags(rawValue: 0x00000001)
    
    /// PenDataStartCap 0x00000002
    /// If set, the style of a starting line cap is specified in the OptionalData field of an EmfPlusPenData object.
    public static let startCap = PenDataFlags(rawValue: 0x00000002)
    
    /// PenDataEndCap 0x00000004
    /// Indicates whether the style of an ending line cap is specified in the OptionalData field of an EmfPlusPenData object.
    public static let endCap = PenDataFlags(rawValue: 0x00000004)

    /// PenDataJoin 0x00000008
    /// Indicates whether a line join type is specified in the OptionalData field of an EmfPlusPenData object.
    public static let join = PenDataFlags(rawValue: 0x00000008)
    
    /// PenDataMiterLimit 0x00000010
    /// Indicates whether a miter limit is specified in the OptionalData field of an EmfPlusPenData object.
    public static let miterLimit = PenDataFlags(rawValue: 0x00000010)
    
    /// PenDataLineStyle 0x00000020
    /// Indicates whether a line style is specified in the OptionalData field of an EmfPlusPenData object.
    public static let lineStyle = PenDataFlags(rawValue: 0x00000020)
    
    /// PenDataDashedLineCap 0x00000040
    /// Indicates whether a dashed line cap is specified in the OptionalData field of an EmfPlusPenData object.
    public static let dashedLineCap = PenDataFlags(rawValue: 0x00000040)
    
    /// PenDataDashedLineOffset 0x00000080
    /// Indicates whether a dashed line offset is specified in the OptionalData field of an EmfPlusPenData object.
    public static let dashedLineOffset = PenDataFlags(rawValue: 0x00000080)
    
    /// PenDataDashedLine 0x00000100
    /// Indicates whether an EmfPlusDashedLineData object is specified in the OptionalData field of an EmfPlusPenData object.
    public static let dashedLine = PenDataFlags(rawValue: 0x00000100)
    
    /// PenDataNonCenter 0x00000200
    /// Indicates whether a pen alignment is specified in the OptionalData field of an EmfPlusPenData object.
    public static let nonCenter = PenDataFlags(rawValue: 0x00000200)
    
    /// PenDataCompoundLine 0x00000400
    /// Indicates whether the length and content of a EmfPlusCompoundLineData object are present in the OptionalData field of an
    /// EmfPlusPenData object.
    public static let compoundLine = PenDataFlags(rawValue: 0x00000400)

    /// PenDataCustomStartCap 0x00000800
    /// Indicates whether an EmfPlusCustomStartCapData object is specified in the OptionalData field of an EmfPlusPenData object.
    public static let customStartCap = PenDataFlags(rawValue: 0x00000800)
    
    /// PenDataCustomEndCap 0x00001000
    /// Indicates whether an EmfPlusCustomEndCapData object is specified in the OptionalData field of an EmfPlusPenData object.
    public static let customEndCap = PenDataFlags(rawValue: 0x00001000)
    
    public static let all: PenDataFlags = [
        .transform,
        .startCap,
        .endCap,
        .join,
        .miterLimit,
        .lineStyle,
        .dashedLineCap,
        .dashedLineOffset,
        .dashedLine,
        .nonCenter,
        .compoundLine,
        .customStartCap,
        .customEndCap
    ]
}
