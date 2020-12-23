//
//  RegionNodeDataType.swift
//  
//
//  Created by Hugh Bellamy on 20/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.26 RegionNodeDataType Enumeration
/// The RegionNodeDataType enumeration defines types of region node data.
/// typedef enum
/// {
///  RegionNodeDataTypeAnd = 0x00000001,
///  RegionNodeDataTypeOr = 0x00000002,
///  RegionNodeDataTypeXor = 0x00000003,
///  RegionNodeDataTypeExclude = 0x00000004,
///  RegionNodeDataTypeComplement = 0x00000005,
///  RegionNodeDataTypeRect = 0x10000000,
///  RegionNodeDataTypePath = 0x10000001,
///  RegionNodeDataTypeEmpty = 0x10000002,
///  RegionNodeDataTypeInfinite = 0x10000003
/// } RegionNodeDataType;
/// Region node data is specified by EmfPlusRegionNode objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum RegionNodeDataType: UInt32, DataStreamCreatable {
    /// RegionNodeDataTypeAnd: Specifies a region node with child nodes. A Boolean AND operation SHOULD be applied to the
    /// left and right child nodes specified by an EmfPlusRegionNodeChildNodes object.
    case and = 0x00000001
    
    /// RegionNodeDataTypeOr: Specifies a region node with child nodes. A Boolean OR operation SHOULD be applied to the left and
    /// right child nodes specified by an EmfPlusRegionNodeChildNodes object.
    case or = 0x00000002

    /// RegionNodeDataTypeXor: Specifies a region node with child nodes. A Boolean XOR operation SHOULD be applied to the left
    /// and right child nodes specified by an EmfPlusRegionNodeChildNodes object.
    case xor = 0x00000003

    /// RegionNodeDataTypeExclude: Specifies a region node with child nodes. A Boolean operation, defined as "the part of region 1
    /// that is excluded from region 2", SHOULD be applied to the left and right child nodes specified by an EmfPlusRegionNodeChildNodes object.
    case exclude = 0x00000004
    
    /// RegionNodeDataTypeComplement: Specifies a region node with child nodes. A Boolean operation, defined as "the part of region
    /// 2 that is excluded from region 1", SHOULD be applied to the left and right child nodes specified by an
    /// EmfPlusRegionNodeChildNodes object.
    case complement = 0x00000005

    /// RegionNodeDataTypeRect: Specifies a region node with no child nodes. The RegionNodeData field SHOULD specify a boundary
    /// with an EmfPlusRectF object.
    case rect = 0x10000000

    /// RegionNodeDataTypePath: Specifies a region node with no child nodes. The RegionNodeData field SHOULD specify a boundary
    /// with an EmfPlusRegionNodePath object.
    case path = 0x10000001

    /// RegionNodeDataTypeEmpty: Specifies a region node with no child nodes. The RegionNodeData field SHOULD NOT be present.
    case empty = 0x10000002
    
    /// RegionNodeDataTypeInfinite: Specifies a region node with no child nodes, and its bounds are not defined.
    case infinite = 0x10000003
}
