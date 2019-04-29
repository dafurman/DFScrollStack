//
//  UIView+Extensions.swift
//  DFScrollStack
//
//  Created by David Furman on 4/6/19.
//

import UIKit.UIView

extension UIView {
    
    /// The nib represnting this view.
    class func nib() -> UINib {
        return UINib(nibName: nameOfClass, bundle: nil)
    }
    
    /// Constrains a given view to the edges of this view.
    ///
    /// - Warning: Ensure that the passed `view` and `self` are in the same view hierarchy.
    ///
    /// - Parameters:
    ///   - view: The view to add as a subview to this view.
    ///   - constant: An optional constant to use to add margins to the constraints.
    func constrainToEdges(of view: UIView, constant: CGFloat = 0) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: constant),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant),
            ])
    }
}
