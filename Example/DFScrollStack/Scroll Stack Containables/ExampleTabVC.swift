//
//  ExampleTabVC.swift
//  DFScrollStack
//
//  Created by David Furman on 3/7/19.
//

import UIKit
import DFScrollStack

/// An example of a TabVC which is being used in the ScrollStackController, to indicate how the ScrollStackController can handle controlled view controller's needing to change their view sizes.
final class ExampleTabVC: TabVC {
    
    // ========
    // MARK: - Properties
    // ========
    
    override var displayedVC: UIViewController! {
        didSet {
            updatePreferredContentSize()
        }
    }
    
    
    
    
    
    // ========
    // MARK: - Lifecycle
    // ========
    
    override func didMove(toParent parent: UIViewController?) {
        displayedVC?.didMove(toParent: parent)
    }
    
    
    
    
    
    // ========
    // MARK: - TabVC Setup
    // ========
    
    override func setupTabs() {
        for i in 0...5 {
            let tabBarItem = TabBarItem(title: "\(i)")
            tabItems.append(tabBarItem)
        }
    }
    
    override func viewController(for index: Int) -> UIViewController {
        switch index {
        case 0:
            let vc = CollectionVC()
            vc.title = "CollectionVC - Top and Bot"
            vc.dataSource.numCells = (index + 1) * 20
            return vc
        case 1:
            let vc = CollectionVC()
            vc.title = "CollectionVC - Bottomless"
            vc.showsBotLabel = false
            vc.dataSource.numCells = (index + 1) * 20
            return vc
        case 2:
            let vc = CollectionVC()
            vc.title = "CollectionVC - Topless"
            vc.showsTopLabel = false
            vc.dataSource.numCells = (index + 1) * 20
            return vc
        case 3:
            let vc = CollectionVC()
            vc.title = "CollectionVC - No Padding"
            vc.showsTopLabel = false
            vc.showsBotLabel = false
            vc.dataSource.numCells = (index + 1) * 20
            return vc
        case 4:
            let vc = TableVC()
            vc.title = "TableVC - \(index + 1)"
            vc.dataSource.numCells = (index + 1) * 20
            return vc
        case 5:
            let vc = NonScrollVC()
            vc.title = "NonScrollVC - \(index + 1)"
            return vc
        default:
            fatalError()
        }
    }
    
    func updatePreferredContentSize() {
        // Use a custom implementation of updatePreferredContentSize because in the case of a displayedVC without a scrollView, contentHeight calculation alone won't cut it.
        // We need to manually get the displayedVC's preferredContentSize, then add this view controller's insets.
        if scrollView != nil {
            preferredContentSize = CGSize(width: view.frame.width, height: contentHeight)
        } else {
            preferredContentSize = CGSize(width: displayedVC.preferredContentSize.width + insets.width,
                                          height: displayedVC.preferredContentSize.height + insets.height)
        }
    }
}





// ========
// MARK: - ExampleTabVC: ScrollStackContainable
// ========

extension ExampleTabVC: ScrollStackContainable {
    var scrollView: UIScrollView? { return (displayedVC as? ScrollStackContainable)?.scrollView }
    
    var insets: UIEdgeInsets {
        var combinedInsets = UIEdgeInsets(top: buttonBarView.frame.height, left: 0, bottom: 0, right: 0)
        
        if let containable = displayedVC as? ScrollStackContainable {
            combinedInsets += containable.insets
        }
        
        return combinedInsets
    }
}
