//
//  EmfPlusSerializableObject.swift
//
//
//  Created by Hugh Bellamy on 16/12/2020.
//

import DataStream
import WindowsDataTypes

/// [MS-EMFPLUS] 2.3.5.2 EmfPlusSerializableObject Record
/// The EmfPlusSerializableObject record defines an image effects parameter block that has been serialized into a data buffer.<25>
/// See section 2.3.5 for the specification of additional object record types.
public struct EmfPlusSerializableObject {
    public let type: RecordType
    public let flags: UInt16
    public let size: UInt32
    public let dataSize: UInt32
    public let objectGUID: ImageEffectsIdentifier
    public let bufferSize: UInt32
    public let buffer: Buffer
    
    public init(dataStream: inout DataStream) throws {
        let startPosition = dataStream.position
        
        /// Type (2 bytes): An unsigned integer that identifies this record type as EmfPlusSerializableObject from the RecordType enumeration.
        /// The value MUST be 0x4038.
        self.type = try RecordType(dataStream: &dataStream)
        guard self.type == .serializableObject else {
            throw EmfPlusReadError.corrupted
        }
        
        /// Flags (2 bytes): An unsigned integer that is not used. This field SHOULD be set to zero and MUST be ignored upon receipt.
        self.flags = try dataStream.read(endianess: .littleEndian)
        
        /// Size (4 bytes): An unsigned integer that specifies the 32-bit–aligned number of bytes in the entire record, including the
        /// 12-byte record header and record-specific data. For this record type, the value MUST be computed as follows:
        /// Size = BufferSize + 0x00000020
        let size: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard size >= 0x00000020 && size % 4 == 0 else {
            throw EmfPlusReadError.corrupted
        }
        
        self.size = size
        
        /// DataSize (4 bytes): An unsigned integer that specifies the 32-bit–aligned number of bytes of record-specific data that follows.
        /// For this record type, the value MUST be computed as follows:
        /// DataSize = BufferSize + 0x00000014
        let dataSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard dataSize >= 0x00000014 && dataSize % 4 == 0 && dataSize == size - 0x0000000C else {
            throw EmfPlusReadError.corrupted
        }
        
        self.dataSize = dataSize
        
        let dataStartPosition = dataStream.position
        
        /// ObjectGUID (16 bytes): The GUID packet representation value ([MS-DTYP] section 2.3.4.2) for the image effect.
        /// This MUST correspond to one of the ImageEffects identifiers.
        self.objectGUID = try ImageEffectsIdentifier(dataStream: &dataStream)
        
        /// BufferSize (4 bytes): An unsigned integer that specifies the size in bytes of the 32-bit-aligned Buffer field.
        let bufferSize: UInt32 = try dataStream.read(endianess: .littleEndian)
        guard bufferSize % 4 == 0 &&
                0x00000020 + bufferSize == size &&
                0x00000014 + bufferSize == dataSize else {
            throw EmfPlusReadError.corrupted
        }
        
        self.bufferSize = bufferSize
        
        let bufferStartPosition = dataStream.position
        
        /// Buffer (variable): An array of BufferSize bytes that contain the serialized image effects parameter block that corresponds
        /// to the GUID in the ObjectGUID field. This MUST be one of the Image Effects objects.
        let buffer = try dataStream.readBytes(count: Int(self.bufferSize))
        var bufferDataStream = DataStream(buffer)
        switch self.objectGUID {
        case .blur:
            self.buffer = .blurEffect(try BlurEffect(dataStream: &bufferDataStream, size: self.bufferSize))
        case .brightnessContrast:
            self.buffer = .brightnessContrastEffect(try BrightnessContrastEffect(dataStream: &bufferDataStream, size: self.bufferSize))
        case .colorBalance:
            self.buffer = .colorBalanceEffect(try ColorBalanceEffect(dataStream: &bufferDataStream, size: self.bufferSize))
        case .colorCurve:
            self.buffer = .colorCurveEffect(try ColorCurveEffect(dataStream: &bufferDataStream, size: self.bufferSize))
        case .colorLookupTable:
            /// <9> Section 2.1.3.1: Windows produces corrupt records when the ColorCurve effect is used.
            if self.bufferSize == 0x0000000C {
                self.buffer = .unknown(buffer)
            } else {
                self.buffer = .colorLookupTableEffect(try ColorLookupTableEffect(dataStream: &bufferDataStream, size: self.bufferSize))
            }
        case .colorMatrix:
            self.buffer = .colorMatrixEffect(try ColorMatrixEffect(dataStream: &bufferDataStream, size: self.bufferSize))
        case .hueSaturationLightness:
            self.buffer = .hueSaturationLightnessEffect(try HueSaturationLightnessEffect(dataStream: &bufferDataStream, size: self.bufferSize))
        case .levels:
            self.buffer = .levelsEffect(try LevelsEffect(dataStream: &bufferDataStream, size: self.bufferSize))
        case .redEyeCorrection:
            self.buffer = .redEyeCorrectionEffect(try RedEyeCorrectionEffect(dataStream: &bufferDataStream, size: self.bufferSize))
        case .sharpen:
            self.buffer = .sharpenEffect(try SharpenEffect(dataStream: &bufferDataStream, size: self.bufferSize))
        case .tint:
            self.buffer = .tintEffect(try TintEffect(dataStream: &bufferDataStream, size: self.bufferSize))
        case .unknown:
            self.buffer = .unknown(buffer)
        }
        
        guard dataStream.position - bufferStartPosition == self.bufferSize &&
                dataStream.position - dataStartPosition == self.dataSize &&
                dataStream.position - startPosition == self.size else {
            throw EmfPlusReadError.corrupted
        }
    }
    
    public enum Buffer {
        case blurEffect(_: BlurEffect)
        case brightnessContrastEffect(_: BrightnessContrastEffect)
        case colorBalanceEffect(_: ColorBalanceEffect)
        case colorCurveEffect(_: ColorCurveEffect)
        case colorLookupTableEffect(_: ColorLookupTableEffect)
        case colorMatrixEffect(_: ColorMatrixEffect)
        case hueSaturationLightnessEffect(_ : HueSaturationLightnessEffect)
        case levelsEffect(_: LevelsEffect)
        case redEyeCorrectionEffect(_: RedEyeCorrectionEffect)
        case sharpenEffect(_: SharpenEffect)
        case tintEffect(_: TintEffect)
        case unknown(_: [UInt8])
    }
}
