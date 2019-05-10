//
//  DFScrollStack.swift
//  DFScrollStack
//
//  Created by David Furman on 2/25/19.
//

import UIKit

/// A ScrollStackController can be used to create a stack of scrollable content.
///
/// This can be performed by setting the `viewControllers` property with UIViewControllers that conform to `ScrollStackContainable`.
/// View controllers can be freely added and removed through modification of this array.
///
/// - Note: If a view controller's size has been changed, call `updateItemsLayout()` to ensure that the new size is accounted for.
public class ScrollStackController: UIViewController {
    
    // ========
    // MARK: - Structures
    // ========

    /// Positions of a a ScrollStackItem that can be scrolled to.
    ///
    /// This is used to mimic functionality of UITableView's `scrollToRow(at:, at:, animated:)` in `ScrollStackController`'s similar function: `scrollToItem(at index: Int, scrollPosition:, animated:)`
    public enum ScrollPosition {
        case top
        case bottom
    }
    
    
    
    
    
    // ========
    // MARK: - Properties
    // ========

	/// This is the parent scroll view which all of the `viewControllers`' views are placed in.
    private let scrollView = UIScrollView()
    
	/// The `items` are used to manage each view controller being used in the scrollView.
    public var items: [ScrollStackItem] = []
    
	/// Use this property to set the ordered list of UIViewController instances you want to set into the scroll view.
	public var viewControllers: [ScrollStackContainable] {
		set {
            // Remove any view controllers that no longer exist in the newValue.
            for vc in viewControllers.compactMap({ $0 as? UIViewController }) {
                if !newValue.contains(where: { $0 === vc }) {
                    items.removeAll(where: { $0.scrollStackContainable === vc })
                    vc.removeFromParent()
                    vc.view.removeFromSuperview()
                }
            }
            
            items = newValue.map { ScrollStackItem(stackContainable: $0) }
            updateItemsLayout()
		}
		get { return self.items.map { $0.scrollStackContainable } }
	}
    
    /// The visible portion of the scrollView
    private var visibleRect: CGRect {
        get {
            return CGRect(x: scrollView.contentOffset.x,
                          y: scrollView.contentOffset.y,
                          width: scrollView.frame.size.width,
                          height: scrollView.frame.size.height)
        }
    }
    
    
    
    
    
    // ========
    // MARK: - Lifecycle
    // ========

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        addScrollView()
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Whenever subviews are laid out, the items positions need to be recalculated and relaid out too.
        self.updateItemsLayout()
    }
    
    override public func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        
        // If a childContentContainer's preferredContentSize changes, we need to honor that change by laying out items.
        updateItemsLayout()
    }
    
    
    
    
    
    // ========
    // MARK: - Lifecycle Helpers
    // ========
    
    /// Adds the scrollView to the view.
    private func addScrollView() {
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        scrollView.constrainToEdges(of: view)
    }
    
    
    
    
    
    // ========
    // MARK: - Layout Management
    // ========
    
    /// This function is used to calculate the rect of each item into the stack
    /// and put it in place. It must be called whenever the contents of `items` changes.
    private func updateItemsLayout() {
        var itemYOffset: CGFloat = 0.0
        let width = view.frame.size.width
        
        // Update the y offsets of each item's rect.
        for item in items {
            let itemHeight = item.scrollStackContainable.contentHeight
            item.rect = CGRect(x: 0.0, y: itemYOffset, width: width, height: itemHeight)
            itemYOffset += itemHeight // calculate the new offset
        }
        
        // update the content size to fit all of the items.
        scrollView.contentSize = CGSize(width: width, height: itemYOffset)
        
        adjustContentOnScroll()
    }
	
	/// This function is used to adjust the frame of the object as the parent
	/// scroll view did scroll.
	/// How it works:
	/// - Standard UIViewController's with `view` appearance are showed as is. No changes are
	///   applied to the frame of the view itself.
	/// - UIViewController with `scroll` appearance are managed by adjusting the specified
	///   scrollview's offset and frame in order to take care of the visibility region into the
	///   parent scroll view.
	///   When scroll reaches the top of the scrollview it's pinned on top and the offset is adjusted
	///   on scroll in order to simulate a continous scrolling of the parent scrollview.
	///   The frame of the inner scroll is adjusted in order to occupy at the max the entire region
	///   of the parent, and when partially visible, only the visible region.
	////  In this way we can maximize the memory usage by using table/collection's caching architecture.
	private func adjustContentOnScroll() {
		for item in items {
            let scrollState = getItemVisibilityState(item: item)
            
            // Update the item's scroll's offset in accordance with its scrollState.
            if item.scrollStackContainable.scrollView != nil {
                setItemScrollViewOffset(item: item, scrollState: scrollState)
            }
            
            // Remove or add the item's view controller and view depending on whether it is expected to be visible in the frame of the scrollView.
            if scrollState == .none {
                if item.viewController.view.superview != nil {
                    item.viewController.view.removeFromSuperview()
                }
                item.viewController.removeFromParent()
            } else {
                if item.viewController.parent == nil {
                    addChild(item.viewController)
                    item.viewController.didMove(toParent: self)
                }
                if item.viewController.view.superview == nil {
                    scrollView.addSubview(item.viewController.view)
                }
            }

            // Set the new frame of the item's view.
            let newFrame = getRequiredFrame(item: item, scrollState: scrollState)
            item.viewController.view.frame = newFrame
            item.viewController.view.layoutIfNeeded()
		}
	}
    
    /// Get the visibility state of an item, with respect to the scrollView's current content offset, and the item's rect.
    ///
    /// - Parameter item: The item to get the visibility state for.
    /// - Returns: The visibility state of the item.
    public func getItemVisibilityState(item: ScrollStackItem) -> ScrollStackItem.VisibilityState {
        let insets = item.scrollStackContainable.insets
        
        let topViewRect = CGRect(x: item.rect.minX,
                                 y: item.rect.minY,
                                 width: item.rect.width,
                                 height: insets.top)
        let bottomViewRect = CGRect(x: item.rect.minX,
                                    y: item.rect.maxY - insets.bottom,
                                    width: item.rect.width,
                                    height: insets.bottom)
        
        let showsTopRect = visibleRect.intersects(topViewRect)
        let showsBottomRect = (bottomViewRect.height != 0) ? visibleRect.intersects(bottomViewRect) : false
        let showsInnerScroll = visibleRect.maxY > topViewRect.maxY && visibleRect.minY < bottomViewRect.minY
        let itemVisibleRect = visibleRect.intersection(item.rect)
        
        // Determine the visibility state of the item based upon what's been determined to be currently shown.
        let visibilityState: ScrollStackItem.VisibilityState
        if itemVisibleRect.height == 0 {
            visibilityState = .none
        } else {
            if showsTopRect {
                if showsBottomRect {
                    visibilityState = .all
                } else if showsInnerScroll {
                    visibilityState = .topAndInner
                } else {
                    visibilityState = .top
                }
            } else if showsBottomRect {
                if showsInnerScroll {
                    visibilityState = .bottomAndInner
                } else {
                    visibilityState = .bottom
                }
            } else {
                visibilityState = .inner
            }
        }
        return visibilityState
    }
    
    /// Sets the contentOffset of a given item's scrollView based upon its scrollState, and the current contentOffset of the overall scrollView.
    ///
    /// If the item doesn't have a scrollView, this function will do nothing.
    ///
    /// - Parameters:
    ///   - item: The item to set its scrollView's content offset.
    ///   - scrollState: The visibility state of the item.
    private func setItemScrollViewOffset(item: ScrollStackItem, scrollState: ScrollStackItem.VisibilityState) {
        guard let innerScrollView = item.scrollStackContainable.scrollView else { return }
        
        switch scrollState {
        case .all, .top, .topAndInner:
            innerScrollView.setContentOffset(.zero, animated: false)
        case .inner, .bottomAndInner:
            // adjust the offset to simulate the scroll
            // This is necessary to recycle cells that have been scrolled up out of the visible frame. Otherwise, they'll end up not being recycled.
            let mainOffsetY = scrollView.contentOffset.y
            let innerScrollOffsetY = mainOffsetY - item.rect.minY - item.scrollStackContainable.insets.top
            innerScrollView.setContentOffset(CGPoint(x: 0, y: innerScrollOffsetY), animated: false)
        case .bottom, .none:
            return
        }
    }
    
    /// Get the frame for an item to set to set its view's frame.
    /// This value is based upon the item's rect and its current scrollState.
    /// If a scrollState isn't passed, it'll be calculated.
    ///
    /// - Parameters:
    ///   - item: The item to calculate the required view frame for.
    ///   - scrollState: The scrollstate of the item. If the scrollState isn't passed, it'll be calculated within the function.
    /// - Returns: The frame to set the item's view's frame.
    private func getRequiredFrame(item: ScrollStackItem, scrollState: ScrollStackItem.VisibilityState?) -> CGRect {
        let frame: CGRect
        if let innerScroll = item.scrollStackContainable.scrollView {
            let insets = item.scrollStackContainable.insets
            let scrollState: ScrollStackItem.VisibilityState = scrollState ?? getItemVisibilityState(item: item)
            
            let bottomCutoff = item.rect.minY + insets.top + innerScroll.contentSize.height
            let remainingSpaceForItem = item.rect.maxY - visibleRect.maxY
            let heightToExpose = view.frame.height
            let mainOffsetY = scrollView.contentOffset.y
            
            switch scrollState {
            case .all:
                frame = item.rect
            case .top:
                frame = CGRect(x: item.rect.origin.x,
                               y: item.rect.origin.y,
                               width: item.rect.width,
                               height: insets.height)
            case .topAndInner:
                let innerScrollHeight = visibleRect.maxY - (item.rect.minY + insets.top)
                let height: CGFloat = insets.height + innerScrollHeight
                
                frame = CGRect(x: item.rect.origin.x,
                               y: item.rect.origin.y,
                               width: item.rect.width,
                               height: height)
            case .inner:
                // Stop scrolling, instead, adjust the frame to include any content below the scrollview
                frame = CGRect(x: item.rect.origin.x,
                               y: mainOffsetY - insets.top,
                               width: visibleRect.width,
                               height: visibleRect.height + insets.height)
            case .bottomAndInner:
                // Stop scrolling, instead, adjust the frame to include any content below the scrollview
                frame = CGRect(x: item.rect.origin.x,
                               y: mainOffsetY - insets.top,
                               width: visibleRect.width,
                               height: heightToExpose + remainingSpaceForItem + insets.top)
            case .bottom:
                frame = CGRect(x: item.rect.origin.x,
                               y: bottomCutoff - insets.top,
                               width: item.rect.width,
                               height: insets.height)
            case .none:
                frame = CGRect(x: item.rect.origin.x,
                               y: item.rect.origin.y,
                               width: item.rect.width,
                               height: insets.height)
            }
        } else {
            frame = item.rect
        }
        
        return frame
    }
    
    
    
    
    
    // ========
    // MARK: - Public Utility functions
    // ========
    
    /// This is used to mimic functionality of UITableView's `scrollToRow(at:, at:, animated:)`
    ///
    /// - Parameters:
    ///   - index: The index of the ScrollStackItem to scroll to.
    ///   - scrollPosition: the position of the item to scroll to.
    ///   - animated: Whether or not the scroll should be animated.
    public func scrollToItem(at index: Int, scrollPosition: ScrollPosition, animated: Bool) {
        let item = items[index]
        
        let y: CGFloat
        switch scrollPosition {
        case .top:
            y = item.rect.origin.y
        case .bottom:
            y = item.rect.origin.y + item.rect.height - scrollView.frame.height
        }
        
        let frame = CGRect(x: item.rect.origin.x,
                           y: y,
                           width: scrollView.frame.width,
                           height: scrollView.frame.height)
        scrollView.scrollRectToVisible(frame, animated: true)
    }
}





// ========
// MARK: - ScrollStackController: UIScrollViewDelegate
// ========

extension ScrollStackController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === self.scrollView else { return }
        
        self.adjustContentOnScroll()
    }
}
