//
//  ScrollStackContainable.swift
//  DFScrollStack
//
//  Created by David Furman on 3/30/19.
//

import UIKit

/// Conform a UIViewController to ScrollStackContainable to allow it to be placed within a ScrollStackController.
public protocol ScrollStackContainable: class {
    /// The primary scroll view in the stack containable's view. This is expected to be a vertically-scrolling scrollview.
    var scrollView: UIScrollView? { get }
    
    /// Insets of the ScrollStackContainable around the `scrollView`. Set this if you have views below or above the scrollView, to determine how much height they need.
    ///
    /// If you're using this to represent heights of views, it's suggested that you override `insets` as a computable property, and compute the heights using your views' frame heights within the property. Ensure the view has loaded if you're going to do this!
    var insets: UIEdgeInsets { get }
    
    /// You can override this property if you need to specify a custom appearance of the view
    /// controller instance when contained in a ScrollingStackController.
    ///
    /// If the ScrollStackContainable has a scrollView, the height will be determined by adding the height of the `insets` to the contentSize of the `scrollView`.
    /// Otherwise, height is calculated by searching for a non-zero height in this order:
    /// - attempt to use preferredContentSize.height value
    /// - attempt to use view's height constraint
    /// - attempt to use view's frame.height
    var contentHeight: CGFloat { get }
    
    /// Update the preferredContentSize to account for the contentSize of the scrollview and insets.
    func updatePreferredContentSize()
}





public extension ScrollStackContainable where Self: UIViewController {
    var contentHeight: CGFloat {
        // Ensure the view is loaded so that scrollView is non-nil if it is being used.
        loadViewIfNeeded()
        
        // If a scrollView is set, use its contentHeight, and insets below and above it.
        if let scrollView = self.scrollView {
            return scrollView.contentSize.height + insets.height
        }
        
        // Attempt to use the preferredContentSize height
        var height = preferredContentSize.height
        /// Attempt to use the view's height constraint.
        if height == 0 {
            height = view.constraints.first(where: { $0.firstAttribute == .height })?.constant ?? 0
        }
        // Attempt to use view's height
        if height == 0 {
            height = view.frame.size.height
        }
        
        return height
    }
    
    var insets: UIEdgeInsets { return .zero }
    
    var scrollView: UIScrollView? { return nil }
    
    func updatePreferredContentSize() {
        let contentHeight = self.contentHeight
        if preferredContentSize.height != contentHeight {
            preferredContentSize = CGSize(width: view.frame.width, height: contentHeight)
        }
    }
}
