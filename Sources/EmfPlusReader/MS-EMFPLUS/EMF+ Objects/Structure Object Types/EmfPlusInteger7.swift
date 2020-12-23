//
//  EmfPlusInteger7.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

/// [MS-EMFPLUS] 2.2.2.21 EmfPlusInteger7 Object
/// The EmfPlusInteger7 object specifies a 7-bit signed integer in an 8-bit field.
/// EmfPlusInteger7 objects are used to specify point coordinates in EmfPlusPointR object.
/// See section 2.2.2 for the specification of additional structure objects.
/// Value (7 bits): A 7-bit signed integer between -64 and 63, inclusive.
public typealias EmfPlusInteger7 = Int8
