//
//  RedEyeCorrectionEffect.swift
//
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream
import WmfReader

/// [MS-EMFPLUS] 2.2.3.9 RedEyeCorrectionEffect Object
/// The RedEyeCorrectionEffect object specifies areas of an image to which a red-eye correction is applied.
/// Bitmap images are specified by EmfPlusBitmap objects.
/// See section 2.2.3 for the specification of additional image effects parameter objects.
public struct RedEyeCorrectionEffect {
    public let numberOfAreas: Int32
    public let reserved: UInt32
    public let areas: [RectL]
    
    public init(dataStream: inout DataStream, size: UInt32) throws {
        let startPosition = dataStream.position
        
        guard size >= 0x00000008 && size % 4 == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        /// NumberOfAreas (4 bytes): A signed integer that specifies the number of rectangles in the Areas field.
        let numberOfAreas: Int32 = try dataStream.read(endianess: .littleEndian)
        guard numberOfAreas >= 0 &&
                0x00000008 + numberOfAreas * 0x00000010 == size else {
            throw EmfPlusReadError.corrupted
        }
        
        self.numberOfAreas = numberOfAreas
        
        self.reserved = try dataStream.read(endianess: .littleEndian)
        
        /// Areas (variable): An array of NumberOfAreas WMF RectL objects [MS-WMF]. Each rectangle specifies an area of the
        /// bitmap image to which the red-eye correction effect SHOULD be applied.
        var areas: [RectL] = []
        areas.reserveCapacity(Int(self.numberOfAreas))
        for _ in 0..<self.numberOfAreas {
            areas.append(try RectL(dataStream: &dataStream))
        }
        
        self.areas = areas
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
