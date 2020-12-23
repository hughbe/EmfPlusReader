//
//  BrushId.swift
//  
//
//  Created by Hugh Bellamy on 22/12/2020.
//

import DataStream

public enum BrushId {
    case color(_: EmfPlusARGB)
    case id(_: UInt32)
    
    public init(dataStream: inout DataStream, brushIdIsColor: Bool) throws {
        if brushIdIsColor {
            self = .color(try EmfPlusARGB(dataStream: &dataStream))
        } else {
            let id: UInt32 = try dataStream.read(endianess: .littleEndian)
            guard id >= 0 && id <= 63 else {
                throw EmfPlusReadError.corrupted
            }

            self = .id(id)
        }
    }
}
