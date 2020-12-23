//
//  EmfPlusInteger15.swift
//  
//
//  Created by Hugh Bellamy on 19/12/2020.
//

/// [MS-EMFPLUS] 2.2.2.22 EmfPlusInteger15 Object
/// The EmfPlusInteger15 object specifies a 15-bit signed integer in a 16-bit field.
/// Value (15 bits): A 15-bit signed integer between -16,384 and 16,383, inclusive.
/// EmfPlusInteger15 objects are used to specify point coordinates in EmfPlusPointR object.
/// See section 2.2.2 for the specification of additional structure objects.
public typealias EmfPlusInteger15 = Int16
