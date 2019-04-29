//
//  DiagnosticsTableDataSource.swift
//  DFScrollStack
//
//  Created by David Furman on 3/30/19.
//

import UIKit.UITableView
import DFScrollStack

/// The datasource used for the diagnostics table that displays information about the state of the ScrollStackController in ExampleVC.
final class DiagnosticsTableDataSource: NSObject {
    
    // ========
    // MARK: - Properties
    // ========
    
    /// The items that are being observed by this `DiagnosticsTableDataSource`.
    /// Each cell represents information about a different scroll stack item.
    var scrollStackItems: [ScrollStackItem] = []
    
    /// The cell identifier that's used for dequeuing cells in DiagnosticsTableDataSource
    static let cellIdentifier = "Cell"
}





// ========
// MARK: - DiagnosticsTableDataSource: UITableViewDataSource
// ========

extension DiagnosticsTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scrollStackItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let scrollStackItem = scrollStackItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DiagnosticsTableDataSource.cellIdentifier, for: indexPath) as! DiagnosticsCell
        
        cell.configure(scrollStackItem: scrollStackItem)
        
        return cell
    }
}
