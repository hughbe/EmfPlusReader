//
//  EmfPlusCustomLineCapOptionalData.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

import DataStream

/// [MS-EMFPLUS] 2.2.2.14 EmfPlusCustomLineCapOptionalData Object
/// The EmfPlusCustomLineCapOptionalData object specifies optional fill and outline data for a custom line cap.
/// Note: Each field specified for this object is optional and might not be present in the OptionalData field of an
/// EmfPlusCustomLineCapData object, depending on the CustomLineCapData flags set in its CustomLineCapDataFlags field. Although
/// it is not practical to represent every possible combination of fields present or absent, this section specifies their relative order in the
/// object. The implementer is responsible for determining which fields are actually present in a given metafile record, and for unmarshaling
/// the data for individual fields separately and appropriately.
public struct EmfPlusCustomLineCapOptionalData {
    public let fillData: EmfPlusFillPathStructure?
    public let outlineData: EmfPlusLinePath?
    
    public init(dataStream: inout DataStream, flags: CustomLineCapDataFlags, size: UInt32) throws {
        let startPosition = dataStream.position
        
        var remainingSize = size
        
        /// FillData (variable): An optional EmfPlusFillPath object that specifies the path for filling a custom graphics line cap. This
        /// field MUST be present if the CustomLineCapDataFillPath flag is set in the CustomLineCapDataFlags field of the
        /// EmfPlusCustomLineCapData object.
        if flags.contains(.fillPath) {
            self.fillData = try EmfPlusFillPathStructure(dataStream: &dataStream, availableSize: remainingSize)
            remainingSize = size - UInt32(dataStream.position - startPosition)
        } else {
            self.fillData = nil
        }
        
        /// OutlineData (variable): An optional EmfPlusLinePath object that specifies the path for outlining a custom graphics line cap.
        /// This field MUST be present if the CustomLineCapDataLinePath flag is set in the CustomLineCapDataFlags field of the
        /// EmfPlusCustomLineCapData object.
        if flags.contains(.linePath) {
            self.outlineData = try EmfPlusLinePath(dataStream: &dataStream, availableSize: remainingSize)
        } else {
            self.outlineData = nil
        }
        
        guard dataStream.position - startPosition == size else {
            throw EmfPlusReadError.corrupted
        }
    }
}
