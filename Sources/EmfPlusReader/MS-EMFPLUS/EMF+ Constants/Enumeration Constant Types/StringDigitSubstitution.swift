//
//  StringDigitSubstitution.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.29 StringDigitSubstitution Enumeration
/// The StringDigitSubstitution enumeration defines ways to substitute digits in a string according to a user's locale or language.
/// typedef enum
/// {
///  StringDigitSubstitutionUser = 0x00000000,
///  StringDigitSubstitutionNone = 0x00000001,
///  StringDigitSubstitutionNational = 0x00000002,
///  StringDigitSubstitutionTraditional = 0x00000003
/// } StringDigitSubstitution;
/// See section 2.1.1 for the specification of additional enumerations.
public enum StringDigitSubstitution: UInt32, DataStreamCreatable {
    /// StringDigitSubstitutionUser: Specifies an implementation-defined substitution scheme.
    case user = 0x00000000
    
    /// StringDigitSubstitutionNone: Specifies to disable substitutions.
    case none = 0x00000001
    
    /// StringDigitSubstitutionNational: Specifies substitution digits that correspond with the official national language of the user's locale.
    case national = 0x00000002
    
    /// StringDigitSubstitutionTraditional: Specifies substitution digits that correspond to the user's native script or language, which can
    /// be different from the official national language of the user's locale.
    case traditional = 0x00000003
}
