//
//  EmfPlusGraphicsVersion.swift
//  
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.19 EmfPlusGraphicsVersion Object
/// The EmfPlusGraphicsVersion object specifies the version of operating system graphics that is used to create an EMF+ metafile.
public struct EmfPlusGraphicsVersion {
    public let metafileSignature: UInt32
    public let graphicsVersion: GraphicsVersion
    
    public init(dataStream: inout DataStream) throws {
        var flags: BitFieldReader<UInt32> = try dataStream.readBits(endianess: .littleEndian)
        
        /// GraphicsVersion (12 bits): The version of operating system graphics. This value is defined in the GraphicsVersion
        /// enumeration.<11>
        /// Graphics versions are vendor-extensible; however, to ensure inter-operability, any such extension MUST be implemented
        /// in both clients and servers of EMF+ metafiles.
        if let graphicsVersion = GraphicsVersion(rawValue: UInt16(flags.readBits(count: 12))) {
            self.graphicsVersion = graphicsVersion
        } else {
            self.graphicsVersion = .unknown
        }

        /// MetafileSignature (20 bits): A value that identifies the type of metafile. The value for an EMF+ metafile is 0xDBC01.
        self.metafileSignature = flags.readBits(count: 20)
        guard self.metafileSignature == 0xDBC01 else {
            throw EmfPlusReadError.corrupted
        }
    }
}
