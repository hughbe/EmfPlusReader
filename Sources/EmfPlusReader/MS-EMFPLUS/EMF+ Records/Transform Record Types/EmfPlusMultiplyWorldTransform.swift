//
//  EmfPlusMultiplyWorldTransform.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.9.1 EmfPlusMultiplyWorldTransform Record
/// The EmfPlusMultiplyWorldTransform record multiplies the current world space transform by a specified transform matrix.
/// See section 2.3.9 for the specification of additional transform record types.
public struct EmfPlusMultiplyWorldTransform {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let matrixData: EmfPlusTransformMatrix
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusMultiplyWorldTransform from the RecordType
        /// enumeration.
        /// The value MUST be 0x402C.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .multiplyWorldTransform else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        self.flags = try Flags(dataStream: &dataStream)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data. For this record type, the value MUST be 0x00000024.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000024 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of data in the record-specific
        /// data that follows. For this record type, the value MUST be 0x00000018.
        self.dataSize = try dataStream.read(endianess: .littleEndian)
        guard self.dataSize == 0x00000018 else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataStartPosition = dataStream.position
        
        /// MatrixData (24 bytes): An EmfPlusTransformMatrix object that defines the multiplication matrix.
        self.matrixData = try EmfPlusTransformMatrix(dataStream: &dataStream)
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
    /// structure of the record.
    public struct Flags {
        public let reserved1: UInt16
        public let postMultiplied: Bool
        public let reserved2: UInt8
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved1 = flags.readBits(count: 13)
            
            /// A (1 bit): If set, the transform matrix is post-multiplied. If clear, it is pre-multiplied.
            self.postMultiplied = flags.readBit()
            
            self.reserved2 = UInt8(flags.readRemainingBits())
        }
    }
}
