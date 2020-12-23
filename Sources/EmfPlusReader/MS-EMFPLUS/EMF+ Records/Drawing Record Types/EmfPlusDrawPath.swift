//
//  EmfPlusDrawPath.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.4.11 EmfPlusDrawPath Record
/// The EmfPlusDrawPath record specifies drawing a graphics path.
/// See section 2.3.4 for the specification of additional drawing record types.
public struct EmfPlusDrawPath {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let penId: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusDrawPath from the RecordType
        /// enumeration.
        /// The value MUST be 0x4030.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .drawPath else {
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
        
        /// PenId (4 bytes): An unsigned integer that specifies an index in the EMF+ Object Table for an EmfPlusPen object to use
        /// for drawing the EmfPlusPath. The value MUST be zero to 63, inclusive.
        self.penId = try dataStream.read(endianess: .littleEndian)
        guard self.penId >= 0 && self.penId <= 63 else {
            throw EmfPlusReadError.corrupted
        }
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
    /// structure of the record.
    public struct Flags {
        public let objectId: UInt8
        public let reserved: UInt8
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// ObjectId (1 byte): The index of the EmfPlusPath object to draw, in the EMF+ Object Table. The value MUST be zero
            /// to 63, inclusive.
            let objectId = UInt8(flags.readBits(count: 8))
            guard objectId >= 0 && objectId <= 63 else {
                throw EmfPlusReadError.corrupted
            }
            
            self.objectId = objectId
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved = UInt8(flags.readBits(count: 8))
        }
    }
}
