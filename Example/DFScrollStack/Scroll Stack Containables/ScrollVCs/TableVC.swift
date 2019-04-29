//
//  TableVC.swift
//  DFScrollStack
//
//  Created by David Furman on 3/3/19.
//

import UIKit

/// A ScrollStackContainable that has a table view.
final class TableVC: ScrollVC {
    
    // ========
    // MARK: - Properties
    // ========
    
    override var scrollView: UIScrollView? { return tableView }

    /// This table view is used as the ScrollStackContainable's scrollView.
    private(set) var tableView: UITableView! {
        didSet {
            tableView.isScrollEnabled = false
            tableView.dataSource = dataSource
            tableView.delegate = self
            tableView.clipsToBounds = true
            tableView.estimatedRowHeight = 0
            tableView.allowsSelection = false
            
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: ScrollVCDataSource.cellIdentifier)
            
            tableView.backgroundColor = .green
        }
    }
    
    /// The data source used for the `tableView`.
    let dataSource = TableVCDataSource()
    
    // ========
    // MARK: - Initialization
    // ========

    init() {
        super.init(nibName: nil, bundle: nil)

        dataSource.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ========
    // MARK: - Lifecycle
    // ========

    override func addScrollView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
}





// ========
// MARK: - TableVC: UITableViewDelegate
// ========

extension TableVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}





// ========
// MARK: - TableVC: ScrollVCDataSourceDelegate
// ========

extension TableVC: ScrollVCDataSourceDelegate {
    func numCellsDidChange(numCells: Int) {
        tableView?.reloadData()
        tableView?.layoutIfNeeded()
        updatePreferredContentSize()
    }
}
