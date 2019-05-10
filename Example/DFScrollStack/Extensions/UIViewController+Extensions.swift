//
//  UIViewController+Extensions.swift
//  DFScrollStack
//
//  Created by David Furman on 4/6/19.
//

import UIKit.UIViewController
import DFScrollStack

extension UIViewController {
    
    /// The name of the view associated with this view controller.
    ///
    /// This property makes the assumption that the view is suffixed with `view`, and that this view controller is suffixed with either `VC` or `ViewController`.
    class var nameOfView: String {
        var name = nameOfClass
        name = name.replacingOccurrences(of: "VC", with: "View")
        name = name.replacingOccurrences(of: "ViewController", with: "View")
        return name
    }
    
    /// If this viewController belongs to a ScrollStackController, return it.
    var scrollStackController: ScrollStackController? {
        var parentVC = parent
        while parentVC != nil {
            if let scrollStackController = parentVC as? ScrollStackController {
                return scrollStackController
            }
            parentVC = parentVC?.parent
        }
        return nil
    }
}
