//
//  EmfPlusRestore.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.7.4 EmfPlusRestore Record
/// The EmfPlusRestore record restores the graphics state, identified by a specified index, from a stack of saved graphics states.
/// Each graphics state MUST be popped off a stack of saved graphics states. The graphics state information is not written to the EMF+
/// metafile, so its format can be determined by the implementation.
/// See section 2.3.7 for the specification of additional state record types.
public struct EmfPlusRestore {
    public let type: RecordType
    public let flags: UInt16
    public let size: UInt32
    public let dataSize: UInt32
    public let stackIndex: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusRestore from the RecordType enumeration.
        /// The value MUST be 0x4026.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .restore else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that is not used. This field SHOULD be set to zero and MUST be ignored upon receipt.
        self.flags = try dataStream.read(endianess: .littleEndian)
        
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
        
        /// StackIndex (4 bytes): An unsigned integer that specifies the level associated with a graphics state.
        /// The level value was assigned to the graphics state by a previous EmfPlusSave record.
        self.stackIndex = try dataStream.read(endianess: .littleEndian)
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
