//
//  EmfPlusHeader.swift
//  
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.3.3 EmfPlusHeader Record
/// The EmfPlusHeader record specifies the start of EMF+ data in the metafile.
/// The EmfPlusHeader record MUST be embedded in an EMF EMR_COMMENT_EMFPLUS record, which MUST be the record
/// immediately following the EMF header in the metafile.
/// See section 2.3.3 for the specification of additional control record types.
public struct EmfPlusHeader {
    public let type: RecordType
    public let size: UInt32
    public let flags: Flags
    public let dataSize: UInt32
    public let version: EmfPlusGraphicsVersion
    public let emfPlusFlags: EmfPlusFlags
    public let logicalDpiX: UInt32
    public let logicalDpiY: UInt32
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusHeader from the RecordType enumeration.
        /// The value MUST be 0x4001.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .header else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about the structure of the metafile.
        self.flags = try Flags(dataStream: &dataStream)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned size of the entire record in bytes, including the
        /// 12-byte record header and record-specific data. For this record type, the value is 0x0000001C.
        self.size = try dataStream.read(endianess: .littleEndian)
        guard self.size == 0x0000001C else {
            throw EmfPlusReadError.corrupted
        }
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of data in the record-specific
        /// data that follows. This number does not include the size of the invariant part of this record. For this record type, the value
        /// is 0x00000010.
        self.dataSize = try dataStream.read(endianess: .littleEndian)
        guard self.dataSize == 0x00000010 else {
            throw EmfPlusReadError.corrupted
        }

        let dataStartPosition = dataStream.position
        
        /// Version (4 bytes): An EmfPlusGraphicsVersion object that specifies the version of operating system graphics that was
        /// used to create this metafile.
        self.version = try EmfPlusGraphicsVersion(dataStream: &dataStream)
        
        /// EmfPlusFlags (4 bytes): An unsigned integer that contains information about how this metafile was recorded.
        self.emfPlusFlags = try EmfPlusFlags(dataStream: &dataStream)
        
        /// LogicalDpiX (4 bytes): An unsigned integer that specifies the horizontal resolution for which the metafile was recorded,
        /// in units of pixels per inch.
        self.logicalDpiX = try dataStream.read(endianess: .littleEndian)
        
        /// LogicalDpiY (4 bytes): An unsigned integer that specifies the vertical resolution for which the metafile was recorded,
        /// in units of lines per inch.
        self.logicalDpiY = try dataStream.read(endianess: .littleEndian)
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// Flags (2 bytes): An unsigned integer that provides information about the structure of the metafile.
    public struct Flags {
        public let dual: Bool
        public let reserved: UInt16
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// D (1 bit): If set, this flag indicates that this metafile is EMF+ Dual, which means that it contains two sets of records,
            /// each of which completely specifies the graphics content. If clear, the graphics content is specified by EMF+ records,
            /// and possibly EMF records ([MS-EMF] section 2.3) that are preceded by an EmfPlusGetDC record. If this flag is set,
            /// EMF records alone SHOULD suffice to define the graphics content. Note that whether the EMF+ Dual flag is set
            /// or not, some EMF records are always present, namely EMF control records and the EMF records that contain EMF+
            /// records.
            self.dual = flags.readBit()
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved = flags.readRemainingBits()
        }
    }
    
    /// EmfPlusFlags (4 bytes): An unsigned integer that contains information about how this metafile was recorded.
    public struct EmfPlusFlags {
        public let recordedWithReferenceDeviceContextForVideoDisplay: Bool
        public let reserved: UInt32
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt32> = try dataStream.readBits(endianess: .littleEndian)
            
            /// V (1 bit): If set, this flag indicates that the metafile was recorded with a reference device context for a video display.
            /// If clear, the metafile was recorded with a reference device context for a printer.
            self.recordedWithReferenceDeviceContextForVideoDisplay = flags.readBit()
            
            /// X (1 bit): Reserved and MUST be ignored.
            self.reserved = flags.readRemainingBits()
        }
    }
}
