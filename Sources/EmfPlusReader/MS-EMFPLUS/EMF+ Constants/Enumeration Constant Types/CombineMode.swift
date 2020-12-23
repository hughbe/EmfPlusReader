//
//  CombineMode.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.4 CombineMode Enumeration
/// The CombineMode enumeration defines modes for combining two graphics regions. In the following descriptions, the regions to
/// be combined are referred to as the "existing" and "new" regions.
/// typedef enum
/// {
///  CombineModeReplace = 0x00000000,
///  CombineModeIntersect = 0x00000001,
///  CombineModeUnion = 0x00000002,
///  CombineModeXOR = 0x00000003,
///  CombineModeExclude = 0x00000004,
///  CombineModeComplement = 0x00000005
/// } CombineMode;
/// Graphics regions are specified by EmfPlusRegion objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum CombineMode: UInt32, DataStreamCreatable {
    /// CombineModeReplace: Replaces the existing region with the new region.
    case replace = 0x00000000
    
    /// CombineModeIntersect: Replaces the existing region with the intersection of the existing region and the new region.
    case intersect = 0x00000001
    
    /// CombineModeUnion: Replaces the existing region with the union of the existing and new regions.
    case union = 0x00000002
    
    /// CombineModeXOR: Replaces the existing region with the XOR of the existing and new regions.
    case xor = 0x00000003
    
    /// CombineModeExclude: Replaces the existing region with the part of itself that is not in the new region.
    case exclude = 0x00000004
    
    /// CombineModeComplement: Replaces the existing region with the part of the new region that is not in the existing region.
    case complement = 0x00000005
}
