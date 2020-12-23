//
//  EmfPlusLanguageIdentifier.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.23 EmfPlusLanguageIdentifier Object
/// The EmfPlusLanguageIdentifier object specifies a language code identifier (LCID) that corresponds to the natural language in a
/// locale, including countries, geographical regions, and administrative districts. Each object is an encoding of a primary language
/// and sublanguage identifier, as shown in the following bit field table.
/// The encoded LCID values are defined in [MS-LCID] section 2.2.
/// See section 2.2.2 for the specification of additional structure objects.
public struct EmfPlusLanguageIdentifier {
    public let primaryLanguageId: UInt16
    public let subLanguageId: UInt8
    public let unused: UInt16
    
    public init(dataStream: inout DataStream) throws {
        var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
        
        /// PrimaryLanguageId (10 bits): The natural language.
        /// Primary language identifiers are vendor extensible. Vendor-defined primary language identifiers MUST be in the range
        /// 0x0200 to 0x03FF, inclusive.
        self.primaryLanguageId = UInt16(flags.readBits(count: 10))
        
        /// SubLanguageId (6 bits): The country, geographic region or administrative district for the natural language specified in the
        /// PrimaryLanguageId field.
        /// Sublanguage identifiers are vendor extensible. Vendor-defined sublanguage identifiers MUST be in the range 0x20 to
        /// 0x3F, inclusive.
        self.subLanguageId = UInt8(flags.readBits(count: 6))
        
        self.unused = try dataStream.read(endianess: .littleEndian)
    }
}
