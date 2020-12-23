//
//  EmfPlusSetPageTransform.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.9.5 EmfPlusSetPageTransform Record
/// The EmfPlusSetPageTransform record specifies scaling factors and units for converting page space coordinates to device space
/// coordinates.
/// See section 2.3.9 for the specification of additional transform record types.
public struct EmfPlusSetPageTransform {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let pageScale: Float
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusSetPageTransform from the RecordType
        /// enumeration.
        /// The value MUST be 0x4030.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .setPageTransform else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        self.flags = try Flags(dataStream: &dataStream)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data. For this record type, the value MUST be 0x00000010.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000010 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of data in the record-specific
        /// data that follows. For this record type, the value MUST be 0x00000004.
        self.dataSize = try dataStream.read(endianess: .littleEndian)
        guard self.dataSize == 0x00000004 else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataStartPosition = dataStream.position
        
        /// PageScale (4 bytes): A floating-point value that specifies the scale factor for converting page space coordinates to device
        /// space coordinates.
        self.pageScale = try dataStream.readFloat(endianess: .littleEndian)
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
    /// structure of the record.
    public struct Flags {
        public let reserved: UInt8
        public let pageUnit: UnitType
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved = UInt8(flags.readBits(count: 8))
            
            /// PageUnit (1 byte): The unit of measure for page space coordinates, from the UnitType enumeration.
            /// This value SHOULD NOT be UnitTypeDisplay or UnitTypeWorld.<32>
            guard let pageUnit = UnitType(rawValue: UInt8(flags.readBits(count: 8))) else {
                throw EmfPlusReadError.corrupted
            }
            
            self.pageUnit = pageUnit
        }
    }
}
