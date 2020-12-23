//
//  EmfPlusSave.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.7.5 EmfPlusSave Record
/// The EmfPlusSave record saves the graphics state, identified by a specified index, on a stack of saved graphics states.
/// Each saved graphics state MUST be pushed onto a stack of saved graphics states. The graphics state information is not written to
/// the EMF+ metafile, so its format can be determined by the implementation.
/// See section 2.3.7 for the specification of additional state record types.
public struct EmfPlusSave {
    public let type: RecordType
    public let flags: UInt16
    public let size: UInt32
    public let dataSize: UInt32
    public let stackIndex: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusSave from the RecordType enumeration.
        /// The value MUST be 0x4025.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .save else {
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
        
        /// StackIndex (4 bytes): An unsigned integer that specifies a level to associate with the graphics state.
        /// The level value can be used by a subsequent EmfPlusRestore record to retrieve the graphics state.
        self.stackIndex = try dataStream.read(endianess: .littleEndian)
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
