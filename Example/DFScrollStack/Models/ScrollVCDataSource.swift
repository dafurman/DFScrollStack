//
//  ScrollVCDataSource.swift
//  DFScrollStack
//
//  Created by David Furman on 3/30/19.
//

import Foundation

/// The delegate that ScrollVCDataSource informs of changes.
protocol ScrollVCDataSourceDelegate: class {
    /// Called when the datasource's `numCells` property changes.
    func numCellsDidChange(numCells: Int)
}





/// The superclass datasource used for different types of scrollViews that are demoed in ExampleVC.
class ScrollVCDataSource: NSObject {
    
    // ========
    // MARK: - Properties
    // ========
    
    /// The cell identifier that's used for dequeuing cells in ScrollVCDataSource's scrollviews.
    static let cellIdentifier = "Cell"
    
    /// The number of cells that the scroll view should have.
    var numCells: Int = 10000 {
        didSet {
            delegate?.numCellsDidChange(numCells: numCells)
        }
    }
    
    /// The delegate that ScrollVCDataSource informs of changes.
    weak var delegate: ScrollVCDataSourceDelegate?
}
