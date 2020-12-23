//
//  CustomLineCapData.swift
//
//
//  Created by Hugh Bellamy on 18/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.1.2.2 CustomLineCapData Flags
/// The CustomLineCapData flags specify data for custom line caps. These flags can be combined to specify multiple options.
/// Custom graphics line caps are specified by EmfPlusCustomLineCap objects.
/// See section 2.1.2 for the specification of additional bit flags.
public struct CustomLineCapDataFlags: OptionSet {
    public let rawValue: UInt32
    
    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }
    
    public init(dataStream: inout DataStream) throws {
        self.rawValue = try dataStream.read(endianess: .littleEndian)
    }
    
    /// CustomLineCapDataFillPath 0x00000001
    /// If set, an EmfPlusFillPath object is specified in the OptionalData field of the EmfPlusCustomLineCapData object for filling the
    /// custom line cap.
    public static let fillPath = CustomLineCapDataFlags(rawValue: 0x00000001)
    
    /// CustomLineCapDataLinePath 0x00000002
    /// If set, an EmfPlusLinePath object is specified in the OptionalData field of the EmfPlusCustomLineCapData object for outlining
    /// the custom line cap.
    public static let linePath = CustomLineCapDataFlags(rawValue: 0x00000002)
    
    public static let all: CustomLineCapDataFlags = [.fillPath, .linePath]
}
