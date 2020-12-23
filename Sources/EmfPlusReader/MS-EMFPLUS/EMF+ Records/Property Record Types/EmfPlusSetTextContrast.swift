//
//  EmfPlusSetTextContrast.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.6.7 EmfPlusSetTextContrast Record
/// The EmfPlusSetTextContrast record specifies text contrast according to the gamma correction value.
/// See section 2.3.6 for the specification of additional property record types.
public struct EmfPlusSetTextContrast {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusSetTextContrast from the RecordType
        /// enumeration.
        /// The value MUST be 0x4020.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .setTextContrast else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        self.flags = try Flags(dataStream: &dataStream)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data. For this record type, the value MUST be 0x0000000C.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of data in the record-specific
        /// data that follows. For this record type, the value MUST be 0x00000000.
        self.dataSize = try dataStream.read(endianess: .littleEndian)
        guard self.dataSize == 0x00000000 else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataStartPosition = dataStream.position
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
    /// structure of the record.
    public struct Flags {
        public let textContrast: UInt16
        public let reserved: UInt8
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// TextContrast (12 bits): The gamma correction value X 1000, which will be applied to subsequent text rendering
            /// operations. The allowable range is 1000 to 2200, representing text gamma values of 1.0 to 2.2.
            let textContrast = flags.readBits(count: 12)
            guard textContrast >= 1000 && textContrast <= 2200 else {
                throw EmfPlusReadError.corrupted
            }

            self.textContrast = textContrast
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved = UInt8(flags.readRemainingBits())
        }
    }
}
