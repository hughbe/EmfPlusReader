//
//  HotkeyPrefix.swift
//  
//
//  Created by Hugh Bellamy on 18/12/2020.
//

/// [MS-EMFPLUS] 2.1.1.14 HotkeyPrefix Enumeration
/// The HotkeyPrefix enumeration defines output options for hotkey prefixes in graphics text.
/// typedef enum
/// {
///  HotkeyPrefixNone = 0x00000000,
///  HotkeyPrefixShow = 0x00000001,
///  HotkeyPrefixHide = 0x00000002
/// } HotkeyPrefix;
/// Graphics text is specified by EmfPlusStringFormat objects.
/// See section 2.1.1 for the specification of additional enumerations.
public enum HotkeyPrefix: UInt32, DataStreamCreatable {
    /// HotkeyPrefixNone: Specifies that the hotkey prefix SHOULD NOT be displayed.
    case none = 0x00000000
    
    /// HotkeyPrefixShow: Specifies that no hotkey prefix is defined.
    case show = 0x00000001
    
    /// HotkeyPrefixHide: Specifies that the hotkey prefix SHOULD be displayed.
    case hide = 0x00000002
}
