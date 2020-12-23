//
//  EmfPlusObject.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.3.5.1 EmfPlusObject Record
/// The EmfPlusObject record specifies an object for use in graphics operations. The object definition can span multiple records, which
/// is indicated by the value of the Flags field.
/// The EmfPlusObject record is generic; it is used for all types of objects. Values that are specific to particular object types are contained
/// in the ObjectData field. A conceptual model for managing graphics objects is described in Managing Graphics Objects.
/// See section 2.3.5 for the specification of additional object record types.
public struct EmfPlusObject {
    public let type: RecordType
    public let flags: Flags
    public let size: UInt32
    public let dataSize: UInt32
    public let totalObjectSize: UInt32?
    public let objectData: ObjectData
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusObject from the RecordType
        /// enumeration.
        /// The value MUST be 0x4008.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .object else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
        /// structure of the record.
        let flags = try Flags(dataStream: &dataStream)
        self.flags = flags
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit-aligned size of the entire record in bytes, including the
        /// 12-byte record header and the record-specific buffer data.
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x0000000C && size % 4 == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit-aligned number of bytes of data in the record-specific
        /// data that follows. This number does not include the size of the invariant part of this record. For this record type, the
        /// value varies based on the size of object.
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize >= 0x00000000 && dataSize % 4 == 0 && dataSize == size - 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        let dataStartPosition = dataStream.position
        
        /// TotalObjectSize (4 bytes): If the record is continuable, when the continue bit is set, this field will be present.
        /// Continuing objects have multiple EMF+ records starting with EmfPlusContineudObjectRecord. Each
        /// EmfPlusContinuedObjectRecord will contain a TotalObjectSize. Once TotalObjectSize number of bytes has been read,
        /// the next EMF+ record will not be treated as part of the continuing object.
        if flags.continues {
            self.totalObjectSize = try dataStream.read(endianess: .littleEndian)
        } else {
            self.totalObjectSize = nil
        }
        
        /// ObjectData (variable): An array of bytes that contains data for the type of object specified in the Flags field.
        /// The content and format of the data can be different for each object type. See the individual object definitions in section
        /// 2.2.1 for additional information.
        let objectDataSize = flags.continues ? self.dataSize - 0x00000004 : self.dataSize
        if flags.continues {
            self.objectData = .continues(try dataStream.readBytes(count: Int(objectDataSize)))
        } else {
            switch self.flags.objectType {
            case .invalid:
                throw EmfPlusReadError.corrupted
            case .brush:
                self.objectData = .brush(try EmfPlusBrush(dataStream: &dataStream, dataSize: dataSize))
            case .pen:
                self.objectData = .pen(try EmfPlusPen(dataStream: &dataStream, dataSize: dataSize))
            case .path:
                self.objectData = .path(try EmfPlusPath(dataStream: &dataStream, dataSize: dataSize))
            case .region:
                self.objectData = .region(try EmfPlusRegion(dataStream: &dataStream, dataSize: dataSize))
            case .image:
                self.objectData = .image(try EmfPlusImage(dataStream: &dataStream, dataSize: dataSize))
            case .font:
                self.objectData = .font(try EmfPlusFont(dataStream: &dataStream, dataSize: dataSize))
            case .stringFormat:
                self.objectData = .stringFormat(try EmfPlusStringFormat(dataStream: &dataStream, dataSize: dataSize))
            case .imageAttributes:
                self.objectData = .imageAttributes(try EmfPlusImageAttributes(dataStream: &dataStream, dataSize: dataSize))
            case .customLineCap:
                self.objectData = .customLineCap(try EmfPlusCustomLineCap(dataStream: &dataStream, dataSize: dataSize))
            }
        }
        
        guard dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// Flags (2 bytes): An unsigned integer that provides information about how the operation is to be performed, and about the
    /// structure of the record.
    public struct Flags {
        public let continues: Bool
        public let objectType: ObjectType
        public let objectID: UInt8
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt16> = try dataStream.readBits(endianess: .littleEndian)
            
            /// ObjectID (1 byte): The index in the EMF+ Object Table to associate with the object created by this record.
            /// The value MUST be zero to 63, inclusive.
            let objectID = UInt8(flags.readBits(count: 8))
            guard objectID >= 0 && objectID <= 63 else {
                throw EmfPlusReadError.corrupted
            }
            
            self.objectID = objectID
            
            /// ObjectType (7 bits): Specifies the type of object to be created by this record, from the ObjectType enumeration.
            guard let objectType = ObjectType(rawValue: UInt32(flags.readBits(count: 7))) else {
                throw EmfPlusReadError.corrupted
            }
            
            self.objectType = objectType
            
            /// C (1 bit): Indicates that the object definition continues on in the next EmfPlusObject record. This flag is never set
            /// in the final record that defines the object.
            self.continues = flags.readBit()
        }
    }
    
    /// ObjectData (variable): An array of bytes that contains data for the type of object specified in the Flags field.
    /// The content and format of the data can be different for each object type. See the individual object definitions in section
    /// 2.2.1 for additional information.
    public enum ObjectData {
        case continues(_: [UInt8])
        case brush(_: EmfPlusBrush)
        case pen(_: EmfPlusPen)
        case path(_: EmfPlusPath)
        case region(_: EmfPlusRegion)
        case image(_: EmfPlusImage)
        case font(_: EmfPlusFont)
        case imageAttributes(_: EmfPlusImageAttributes)
        case stringFormat(_: EmfPlusStringFormat)
        case customLineCap(_: EmfPlusCustomLineCap)
    }
}
