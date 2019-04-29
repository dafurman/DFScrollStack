//
//  NSObject+Extensions.swift
//  DFScrollStack
//
//  Created by David Furman on 4/6/19.
//

import Foundation.NSObject

extension NSObject {
    
    /// The name of this class.
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    /// The name of this class.
    var nameOfClass: String {
        return type(of: self).nameOfClass
    }
}
