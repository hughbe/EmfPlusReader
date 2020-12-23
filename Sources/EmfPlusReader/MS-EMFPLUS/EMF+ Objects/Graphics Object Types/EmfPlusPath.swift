//
//  EmfPlusPath.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.1.6 EmfPlusPath Object
/// The EmfPlusPath object specifies a series of line and curve segments that form a graphics path. The order for Bezier data points is
/// the start point, control point 1, control point 2, and end point. For more information see [MSDN-DrawBeziers].
public struct EmfPlusPath {
    public let version: EmfPlusGraphicsVersion
    public let pathPointCount: UInt32
    public let pathPointFlags: PathPointFlags
    public let pathPoints: PathPoints
    public let pathPointTypes: [EmfPlusPathPointType]
    
    public init(dataStream: inout DataStream, dataSize: UInt32) throws {
        let startPosition = dataStream.position
        
        guard dataSize >= 12 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Version (4 bytes): An EmfPlusGraphicsVersion object that specifies the version of operating system graphics that was used
        /// to create this object.
        self.version = try EmfPlusGraphicsVersion(dataStream: &dataStream)
        
        /// PathPointCount (4 bytes): An unsigned integer that specifies the number of points and associated point types that are
        /// defined by this object.
        self.pathPointCount = try dataStream.read(endianess: .littleEndian)
        
        /// PathPointFlags (4 bytes): An unsigned integer that specifies how to interpret the points and associated point types that
        /// are defined by this object.
        self.pathPointFlags = try PathPointFlags(dataStream: &dataStream)
        guard 12 + self.pathPointCount * (self.pathPointFlags.compressedPoints ? 4 : 8) + self.pathPointCount <= dataSize else {
            throw EmfPlusReadError.corrupted
        }
        
        /// PathPoints (variable): An array of PathPointCount points that specify the path. The type of objects in this array is specified
        /// by the PathPointFlags field, as follows:
        ///  If the R flag is set, the points are relative locations specified by EmfPlusPointR objects.
        ///  If the R flag is clear and the C flag is set, the points are absolute locations specified by EmfPlusPoint objects.
        ///  If the R flag is clear and the C flag is clear, the points are absolute locations specified by EmfPlusPointF objects.
        if self.pathPointFlags.relativeAndRunLengthEncoded {
            fatalError("NYI: RLE")
        } else if self.pathPointFlags.compressedPoints {
            var pathPoints: [EmfPlusPoint] = []
            pathPoints.reserveCapacity(Int(self.pathPointCount))
            for _ in 0..<self.pathPointCount {
                pathPoints.append(try EmfPlusPoint(dataStream: &dataStream))
            }

            self.pathPoints = .point(pathPoints)
        } else {
            var pathPoints: [EmfPlusPointF] = []
            pathPoints.reserveCapacity(Int(self.pathPointCount))
            for _ in 0..<self.pathPointCount {
                pathPoints.append(try EmfPlusPointF(dataStream: &dataStream))
            }

            self.pathPoints = .pointF(pathPoints)
        }
        
        /// PathPointTypes (variable): An array of PathPointCount objects that specifies how the points in the PathPoints field are
        /// used to draw the path. The type of objects in this array is specified by the PathPointFlags field, as follows:
        ///  If the R flag is set, the point types are specified by EmfPlusPathPointTypeRLE objects, which use run-length encoding
        /// (RLE) compression ([MS-WMF] section 3.1.6).
        ///  If the R flag is clear, the point types are specified by EmfPlusPathPointType objects.
        if self.pathPointFlags.relativeAndRunLengthEncoded {
            fatalError("NYI: RLE")
        } else {
            var pathPointTypes: [EmfPlusPathPointType] = []
            pathPointTypes.reserveCapacity(Int(self.pathPointCount))
            for _ in 0..<self.pathPointCount {
                pathPointTypes.append(try EmfPlusPathPointType(dataStream: &dataStream))
            }
        
            self.pathPointTypes = pathPointTypes
        }
        
        /// AlignmentPadding (variable): An optional array of up to 3 bytes that pads the record so that its total size is a multiple of
        /// 4 bytes. This field MUST be ignored.
        try dataStream.readFourByteAlignmentPadding(startPosition: startPosition)
        
        guard dataStream.position - startPosition == dataSize else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    /// PathPoints (variable): An array of PathPointCount points that specify the path. The type of objects in this array is specified
    /// by the PathPointFlags field, as follows:
    ///  If the R flag is set, the points are relative locations specified by EmfPlusPointR objects.
    ///  If the R flag is clear and the C flag is set, the points are absolute locations specified by EmfPlusPoint objects.
    ///  If the R flag is clear and the C flag is clear, the points are absolute locations specified by EmfPlusPointF objects.
    public enum PathPoints {
        case pointR(_: [EmfPlusPointR])
        case point(_: [EmfPlusPoint])
        case pointF(_: [EmfPlusPointF])
    }
    
    /// PathPointFlags (4 bytes): An unsigned integer that specifies how to interpret the points and associated point types that
    /// are defined by this object.
    public struct PathPointFlags {
        public let reserved1: UInt16
        public let relativeAndRunLengthEncoded: Bool
        public let reserved2: UInt8
        public let compressedPoints: Bool
        public let reserved3: UInt32
        
        public init(dataStream: inout DataStream) throws {
            var flags: BitFieldReader<UInt32> = try dataStream.readBits(endianess: .littleEndian)
            
            self.reserved1 = UInt16(flags.readBits(count: 11))
            
            /// R (1 bit): If this flag is set, the C flag is undefined and MUST be ignored. The R flag specifies whether the PathPoints
            /// are relative or absolute locations in the coordinate space, and whether the PathPointTypes are run-length encoded.
            /// See PathPoints and PathPointTypes for details.
            self.relativeAndRunLengthEncoded = flags.readBit()
            
            self.reserved2 = UInt8(flags.readBits(count: 2))
            
            /// C (1 bit): If the R flag is clear, this flag specifies the type of objects in the PathPoints array. See PathPoints and
            /// PathPointTypes for details.
            self.compressedPoints = flags.readBit()
            
            self.reserved3 = flags.readRemainingBits()
        }
    }
}
