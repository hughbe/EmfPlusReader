//
//  EmfPlusBeginContainer.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.7.1 EmfPlusBeginContainer Record
/// The EmfPlusBeginContainer record opens a new graphics state container and specifies a transform for it.
/// Each graphics state container MUST be added to an array of saved graphics containers. The graphics state container is not written
/// to the EMF+ metafile, so its format can be determined by the implementation.
/// See section 2.3.7 for the specification of additional state record types.
public struct EmfPlusBeginContainer {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let destRect: EmfPlusRectF
    public let srcRect: EmfPlusRectF
    public let stackIndex: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusBeginContainer from the RecordType enumeration.
        /// The value MUST be 0x4027.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .beginContainer else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        self.flags = try Flags(dataStream: &dataStream)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data. For this record type, the value MUST be 0x00000030.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x00000030 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of data in the record-specific
        /// data that follows. For this record type, the value MUST be 0x00000024.
        self.dataSize = try dataStream.read(endianess: .littleEndian)
        guard self.dataSize == 0x00000024 else {
            throw EmfPlusReadError.corrupted
        }
        
        let dataStartPosition = dataStream.position
        
        /// DestRect (16 bytes): An EmfPlusRectF object that, with SrcRect, specifies a transform for the container.
        /// This transformation results in SrcRect when applied to DestRect.
        self.destRect = try EmfPlusRectF(dataStream: &dataStream)
        
        /// SrcRect (16 bytes): An EmfPlusRectF rectangle that, with DestRect, specifies a transform for the container.
        /// This transformation results in SrcRect when applied to DestRect.
        self.srcRect = try EmfPlusRectF(dataStream: &dataStream)
        
        /// StackIndex (4 bytes): An unsigned integer that specifies the index of a graphics state container.
        /// The index MUST match the value associated with a graphics state container opened by a previous EmfPlusBeginContainer
        /// or EmfPlusBeginContainerNoParams record.
        self.stackIndex = try dataStream.read(endianess: .littleEndian)
        
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
            
            self.reserved = UInt8(flags.readBits(count: 8))
            
            /// PageUnit (1 byte): The unit of measure for page space coordinates, from the UnitType enumeration.
            /// This value SHOULD NOT be UnitTypeDisplay or UnitTypeWorld.<27>
            guard let pageUnit = UnitType(rawValue: UInt8(flags.readBits(count: 8))) else {
                throw EmfPlusReadError.corrupted
            }
            
            self.pageUnit = pageUnit
        }
    }
}
