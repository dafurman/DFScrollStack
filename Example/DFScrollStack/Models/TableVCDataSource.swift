//
//  TableVCDataSource.swift
//  DFScrollStack
//
//  Created by David Furman on 3/24/19.
//

import UIKit.UITableView

/// The datasource used for demoing the use of a view controller with a table view in ExampleVC.
final class TableVCDataSource: ScrollVCDataSource {}





// ========
// MARK: - TableVCDataSource: UITableViewDataSource
// ========

extension TableVCDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScrollVCDataSource.cellIdentifier, for: indexPath)
        cell.backgroundColor = .white
        cell.textLabel?.text = "\(indexPath.item)"
        return cell
    }
}
