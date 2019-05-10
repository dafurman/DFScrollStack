//
//  DiagnosticsCell.swift
//  DFScrollStack
//
//  Created by David Furman on 3/31/19.
//

import UIKit
import DFScrollStack

/// A cell that displays diagnostic information about a single ScrollStackItem in a ScrollingStackController.
final class DiagnosticsCell: UITableViewCell {
    
    // ========
    // MARK: - Properties
    // ========
    
    /// An observer that's triggered when the frame of view controller managed by the scrollStackItem is changed.
    /// This triggers an update to the cell's displayed information.
    private var frameObserver: NSKeyValueObservation?
    
    
    
    
    
    // ========
    // MARK: - Initialization
    // ========

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        detailTextLabel?.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    // ========
    // MARK: - Configure
    // ========

    /// Sets up a DiagnosticsCell to display information about and observe changes to a scrollStackItem.
    ///
    /// - Parameters:
    ///   - scrollStackItem: The item to display information about and observe changes to its view controller's view's frame.
    func configure(scrollStackItem: ScrollStackItem) {
        let scrollStackItemView = scrollStackItem.viewController.view!
        
        frameObserver = scrollStackItemView.observe(\.frame) { [weak self, weak scrollStackItem](_, change) in
            if let self = self, let scrollStackItem = scrollStackItem {
                self.update(scrollStackItem: scrollStackItem)
            }
        }
        update(scrollStackItem: scrollStackItem)
    }
    
    /// Updates a DiagnosticsCell to display the latest information about a scrollStackItem.
    ///
    /// - Parameters:
    ///   - scrollStackItem: The item to display information about.
    private func update(scrollStackItem: ScrollStackItem) {
        let viewController = scrollStackItem.viewController
        let stackContainable = scrollStackItem.scrollStackContainable
        let visibility: ScrollStackItem.VisibilityState = scrollStackItem.viewController.scrollStackController?.getItemVisibilityState(item: scrollStackItem) ?? .none

        var detailText = """
        Frame: \(viewController.view.frame)
        Insets: \(String(describing: stackContainable.insets.description))
        Visibility: \(String(describing: visibility))
        Stack Containable Height: \(stackContainable.contentHeight)
        Item Rect: \(scrollStackItem.rect)
        """
        switch viewController {
        case let collectionVC as CollectionVC:
            detailText += """
            Content Size: \(collectionVC.collectionView.contentSize)
            Visible Size: \(collectionVC.collectionView.visibleSize)
            Visible Cells: \(collectionVC.collectionView.visibleCells.count)
            """
        case let tableVC as TableVC:
            detailText += """
            Content Size: \(tableVC.tableView.contentSize)
            Visible Size: \(tableVC.tableView.visibleSize)
            Visible Cells: \(tableVC.tableView.visibleCells.count)
            """
        default:
            break
        }
        
        detailTextLabel?.text = detailText
        textLabel?.text = viewController.title
    }
}
