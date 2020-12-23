//
//  EmfPlusSetClipRect.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.1.4 EmfPlusSetClipRect Record
/// The EmfPlusSetClipRect record combines the current clipping region with a rectangle
/// The new current clipping region is set to the result of the CombineMode operation.
/// See section 2.3.1 for the specification of additional clipping record types.
public struct EmfPlusSetClipRect {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let clipRect: EmfPlusRectF
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusSetClipRect from the RecordType
        /// enumeration.
        /// The value MUST be 0x4032.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .setClipRect else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        self.flags = try Flags(dataStream: &dataStream)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data. For this record type, the value MUST be 0x0000001C.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000001C else {
            throw EmfPlusReadError.corrupted
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of data in the record-specific
        /// data that follows. For this record type, the value MUST be 0x00000010.
        self.dataSize = try dataStream.read(endianess: .littleEndian)
        guard self.dataSize == 0x00000010 else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataStartPosition = dataStream.position
        
        /// ClipRect (16 bytes): An EmfPlusRectF object that defines the rectangle to use in the CombineMode operation.
        self.clipRect = try EmfPlusRectF(dataStream: &dataStream)
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
    /// structure of the record.
    public struct Flags {
        public let reserved1: UInt8
        public let combineMode: CombineMode
        public let reserved2: UInt8
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            self.reserved1 = UInt8(flags.readBits(count: 8))
            
            /// CM (4 bits): Specifies the logical operation for combining two regions. See the CombineMode enumeration for the
            /// meanings of the values.
            guard let combineMode = CombineMode(rawValue: UInt32(flags.readBits(count: 4))) else {
                throw EmfPlusReadError.corrupted
            }
            
            self.combineMode = combineMode
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved2 = UInt8(flags.readRemainingBits())
        }
    }
}
