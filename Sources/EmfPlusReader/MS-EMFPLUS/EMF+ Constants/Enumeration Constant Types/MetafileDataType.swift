//
//  MetafileDataType.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.20 MetafileDataType Enumeration
/// The MetafileDataType enumeration defines types of metafiles data that can be embedded in an EMF+ metafile.
/// typedef enum
/// {
///  MetafileDataTypeWmf = 0x00000001,
///  MetafileDataTypeWmfPlaceable = 0x00000002,
///  MetafileDataTypeEmf = 0x00000003,
///  MetafileDataTypeEmfPlusOnly = 0x00000004,
///  MetafileDataTypeEmfPlusDual = 0x00000005
/// } MetafileDataType;
/// Embedded metafile data is specified by EmfPlusMetafileData objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum MetafileDataType: UInt32, DataStreamCreatable {
    /// MetafileDataTypeWmf: Specifies that the metafile is a WMF metafile [MS-WMF] that specifies graphics operations with WMF
    /// records.
    case wmf = 0x00000001
    
    /// MetafileDataTypeWmfPlaceable: Specifies that the metafile is a WMF metafile that specifies graphics operations with WMF
    /// records, and which contains additional header information that makes the WMF metafile device-independent.
    case wmfPlaceable = 0x00000002
    
    /// MetafileDataTypeEmf: Specifies that the metafile is an EMF metafile that specifies graphics operations with EMF records
    /// ([MS-EMF] section 2.3).
    case emf = 0x00000003
    
    /// MetafileDataTypeEmfPlusOnly: Specifies that the metafile is an EMF+ metafile that specifies graphics operations with EMF+
    /// records only.
    case emfPlusOnly = 0x00000004
    
    /// MetafileDataTypeEmfPlusDual: Specifies that the metafile is an EMF+ metafile that specifies graphics operations with both
    /// EMF and EMF+ records.
    case emfPlusDual = 0x00000005
}
