//
//  NonScrollVC.swift
//  DFScrollStack
//
//  Created by David Furman on 3/7/19.
//

import UIKit
import DFScrollStack

/// A ScrollStackContainable that doesn't have a scrollView.
final class NonScrollVC: UIViewController {
    
    // ========
    // MARK: - Properties
    // ========
    
    var scrollingStackController: ScrollStackController!

    
    
    
    
    // ========
    // MARK: - Initialization
    // ========
    
    init() {
        super.init(nibName: NonScrollVC.nameOfView, bundle: nil)
        
        preferredContentSize = CGSize(width: view.frame.width, height: 500)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





// ========
// MARK: - NonScrollVC: ScrollStackContainable
// ========

extension NonScrollVC: ScrollStackContainable {}
