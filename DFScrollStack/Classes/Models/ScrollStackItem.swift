//
//  ScrollStackItem.swift
//  DFScrollStack
//
//  Created by David Furman on 3/24/19.
//

import UIKit.UIViewController

/// A ScrollStackItem represents information about an item that's been added to a ScrollStackController.
/// This includes the view controller itself that's been added.
final public class ScrollStackItem {
    
    // ========
    // MARK: - Structures
    // ========

    /// An enumeration of states indicating the visibility of a ScrollStackItem's contents in the ScrollStackController's scrollView's frame. This indicates what part of the contents is visible.
    public enum VisibilityState {
        case top
        case topAndInner
        case inner
        case bottomAndInner
        case bottom
        case all
        case none
    }
    
    
    
    
    
    // ========
    // MARK: - Properties
    // ========
    
    /// This is the desired rect of the ScrollStackItem within the ScrollStackContainer's scrollview. This rect is determined by the ScrollStackContainer, as it considers the `scrollStackContainable`'s frame relative to other items.
    public var rect: CGRect = .zero
    
    /// The ScrollStackContainable instance that the item is the representative of.
    public let scrollStackContainable: ScrollStackContainable
    
    /// Returns the `scrollStackContainable` casted as a UIViewController.
    public var viewController: UIViewController {
        return scrollStackContainable as! UIViewController
    }
    
    
    
    
    
    // ========
    // MARK: - Initialization
    // ========
    
    /// Initialize a new stack item to manage a view controller instance
    ///
    /// - Parameters:
    ///   - viewController: view viewController instance to manage
    init(stackContainable: ScrollStackContainable) {
        self.scrollStackContainable = stackContainable
    }
}
