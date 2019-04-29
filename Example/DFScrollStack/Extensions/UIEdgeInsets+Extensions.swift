//
//  UIEdgeInsets+Extensions.swift
//  DFScrollStack
//
//  Created by David Furman on 4/7/19.
//

import UIKit.UIGeometry

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
