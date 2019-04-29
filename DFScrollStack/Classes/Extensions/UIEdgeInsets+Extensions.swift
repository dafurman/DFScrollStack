//
//  UIEdgeInsets+Extensions.swift
//  DFScrollStack
//
//  Created by David Furman on 4/7/19.
//

import UIKit

extension UIEdgeInsets {
    /// A convenient means of retrieving top + bottom.
    var height: CGFloat {
        return top + bottom
    }
    
    /// A convenient means of retrieving left + right.
    var width: CGFloat {
        return left + right
    }
}

extension UIEdgeInsets: CustomStringConvertible {
    public var description: String {
        return "(t: \(top), l: \(left), b: \(bottom), r: \(right))"
    }
}

public func + (left: UIEdgeInsets, right: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(top: left.top + right.top,
                        left: left.left + right.left,
                        bottom: left.bottom + right.bottom,
                        right: left.right + right.right)
}

public func += (left: inout UIEdgeInsets, right: UIEdgeInsets) {
    left = left + right
}
