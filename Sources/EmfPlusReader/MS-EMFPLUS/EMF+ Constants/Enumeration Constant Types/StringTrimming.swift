//
//  StringTrimming.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.30 StringTrimming Enumeration
/// The StringTrimming enumeration defines how to trim characters from a string that is too large for the text layout rectangle.
/// typedef enum
/// {
///  StringTrimmingNone = 0x00000000,
///  StringTrimmingCharacter = 0x00000001,
///  StringTrimmingWord = 0x00000002,
///  StringTrimmingEllipsisCharacter = 0x00000003,
///  StringTrimmingEllipsisWord = 0x00000004,
///  StringTrimmingEllipsisPath = 0x00000005
/// } StringTrimming;
/// See section 2.1.1 for the specification of additional enumerations.
public enum StringTrimming: UInt32, DataStreamCreatable {
    /// StringTrimmingNone: Specifies that no trimming is done.
    case none = 0x00000000
    
    /// StringTrimmingCharacter: Specifies that the string is broken at the boundary of the last character that is inside the layout
    /// rectangle. This is the default.
    case character = 0x00000001
    
    /// StringTrimmingWord: Specifies that the string is broken at the boundary of the last word that is inside the layout rectangle.
    case word = 0x00000002
    
    /// StringTrimmingEllipsisCharacter: Specifies that the string is broken at the boundary of the last character that is inside the layout
    /// rectangle, and an ellipsis (...) is inserted after the character.
    case ellipsisCharacter = 0x00000003
    
    /// StringTrimmingEllipsisWord: Specifies that the string is broken at the boundary of the last word that is inside the layout
    /// rectangle, and an ellipsis (...) is inserted after the word.
    case ellipsisWord = 0x00000004
    
    /// StringTrimmingEllipsisPath: Specifies that the center is removed from the string and replaced by an ellipsis. The algorithm keeps
    /// as much of the last portion of the string as possible.
    case ellipsisPath = 0x00000005
}
