//
//  ExampleVC.swift
//  DFScrollStack
//
//  Created by David Furman on 2/25/19.
//

import UIKit
import DFScrollStack

/// The view controller that's used as an example to demonstrate the functionality of a ScrollStackController.
///
/// The ScrollStackController is contained within this ExampleVC, and is inserted into the `scrollStackContainer`. You can subclass ScrollStackController and use that subclass as its own screen if you'd like though.
final class ExampleVC: UIViewController {
    
    // ========
    // MARK: - Properties
    // ========
    
    /// The container for the ScrollStackController being used as an example.
    @IBOutlet private weak var scrollStackContainer: UIView! {
        didSet {            
            scrollStackContainer.layer.borderColor = UIColor.black.cgColor
            scrollStackContainer.layer.borderWidth = 1

            exampleScrollStackController.view.translatesAutoresizingMaskIntoConstraints = false
            
            scrollStackContainer.addSubview(exampleScrollStackController.view)
            
            exampleScrollStackController.view.constrainToEdges(of: scrollStackContainer)
        }
    }
    
    /// Displays info regarding the number of cells that are associated with the view controller that's being viewed in diagnostics table entry.
    @IBOutlet private weak var numCellsLabel: UILabel!
    
    /// Use this to manipulate the number of cells that are associated with the view controller that's being viewed in diagnostics table entry.
    @IBOutlet private weak var numCellsStepper: UIStepper!
    
    /// A stack of buttons used to insert different types of ScrollStackContainables into the ScrollStackController.
    @IBOutlet private weak var scrollStackInsertionButtons: UIStackView!
    
    /// A tableview used to display information about what's going on in the ScrollStackController.
    @IBOutlet private weak var diagnosticsTableView: UITableView! {
        didSet {
            diagnosticsTableView.delegate = self
            diagnosticsTableView.dataSource = diagnosticsTableViewDataSource
            
            diagnosticsTableView.register(DiagnosticsCell.self, forCellReuseIdentifier: DiagnosticsTableDataSource.cellIdentifier)
            
            diagnosticsTableView.layer.borderColor = UIColor.black.cgColor
            diagnosticsTableView.layer.borderWidth = 1
        }
    }
    
    /// The datasource associated with the diagnosticsTableView.
    private let diagnosticsTableViewDataSource = DiagnosticsTableDataSource()
    
    /// The ScrollStackController being used as an example.
    private let exampleScrollStackController = ScrollStackController()

    
    
    
    
    // ========
    // MARK: - Initialization
    // ========
    
    init() {
        super.init(nibName: ExampleVC.nameOfView, bundle: nil)
        
        title = "Scrolling Stack"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    // ========
    // MARK: - Diagnostics Table
    // ========
    
    /// Appends a scrollStackItem to the diagnostics table.
    ///
    /// - Parameter scrollStackItem: The item to append.
    private func addScrollStackItemToDiagnostics(scrollStackItem: ScrollStackItem) {
        diagnosticsTableViewDataSource.scrollStackItems.append(scrollStackItem)
        
        let indexPath = IndexPath(row: diagnosticsTableViewDataSource.scrollStackItems.count - 1, section: 0)
        diagnosticsTableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    /// Selects the last row in the diagnostics table.
    private func selectLastDiagnosticsRow() {
        guard diagnosticsTableView.numberOfRows(inSection: 0) > 0 else { return }
        
        let indexPath = IndexPath(row: diagnosticsTableView.numberOfRows(inSection: 0) - 1, section: 0)
        diagnosticsTableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        tableView(diagnosticsTableView, didSelectRowAt: indexPath)
    }
    
    /// Clears out displayed info regarding the number of cells that are associated with the view controller that's being viewed in diagnostics table entry.
    private func clearNumCellsInfo() {
        numCellsLabel.text = "Num Cells - N/A"
        numCellsStepper.isUserInteractionEnabled = false
        numCellsStepper.value = 0
    }
    
    
    
    
    
    // ========
    // MARK: - Actions
    // ========
    
    /// Used by the `didPressInsert____Button()` functions to insert a type of a ScrollStackContainable into the `scrollStackController` and `diagnosticsTable`. Additionally, this selects the newly inserted item in the `diagnosticsTable`.
    ///
    /// - Parameter type: The ScrollStackContainable to insert into
    private func insertScrollStackContainable(type: ScrollStackContainable.Type) {
        let id = String(UUID().uuidString.prefix(3))
        
        let scrollStackContainable: ScrollStackContainable
        let title: String
        switch type {
        case is TableVC.Type:
            scrollStackContainable = TableVC()
            title = "TVC - \(id)"
        case is CollectionVC.Type:
            scrollStackContainable = CollectionVC()
            title = "CVC - \(id)"
        case is NonScrollVC.Type:
            scrollStackContainable = NonScrollVC()
            title = "NonScroll - \(id)"
        case is ExampleTabVC.Type:
            scrollStackContainable = ExampleTabVC()
            title = "TabVC - \(id)"
        default:
            fatalError("Unsupported type: \(type)")
        }
        
        let viewController = scrollStackContainable as! UIViewController
        viewController.title = title

        // Insert the view controller.
        exampleScrollStackController.viewControllers.append(scrollStackContainable)
        
        let scrollStackItem = exampleScrollStackController.items.last!
        addScrollStackItemToDiagnostics(scrollStackItem: scrollStackItem)
        
        // Select the newly inserted view controller in the diagnostics table.
        selectLastDiagnosticsRow()
    }

    /// Called when the `TableVC` button in the `scrollStackInsertionButtons` is pressed.
    @IBAction private func didPressInsertTableButton() {
        insertScrollStackContainable(type: TableVC.self)
    }
    
    /// Called when the `CollectionVC` button in the `scrollStackInsertionButtons` is pressed.
    @IBAction private func didPressInsertCollectionButton() {
        insertScrollStackContainable(type: CollectionVC.self)
    }
    
    /// Called when the `NonScrollVC` button in the `scrollStackInsertionButtons` is pressed.
    @IBAction private func didPressInsertNonScrollingButton() {
        insertScrollStackContainable(type: NonScrollVC.self)
    }
    
    /// Called when the `TabVC` button in the `scrollStackInsertionButtons` is pressed.
    @IBAction private func didPressInsertTabVCButton() {
        insertScrollStackContainable(type: ExampleTabVC.self)
    }
    
    /// Called when the `numCellsStepper`'s value is changed. This changes the number of cells that are associated with the view controller that's being viewed in diagnostics table entry.
    @IBAction private func didChangeNumCells(_ sender: UIStepper) {
        guard let selectedIndexPath = diagnosticsTableView.indexPathForSelectedRow else { return }
        let vc = exampleScrollStackController.viewControllers[selectedIndexPath.row]
        
        let newNumCells = Int(sender.value)
        
        switch vc {
        case let tableVC as TableVC:
            tableVC.dataSource.numCells = newNumCells
        case let collectionVC as CollectionVC:
            collectionVC.dataSource.numCells = newNumCells
        default:
            return
        }
        
        numCellsLabel.text = "Num Cells of \((vc as! UIViewController).title!): \(newNumCells)"
    }
}





// ========
// MARK: - ExampleVC: UITableViewDelegate
// ========

extension ExampleVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        clearNumCellsInfo()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = exampleScrollStackController.viewControllers[indexPath.row]
        
        let numCells: Int
        
        switch vc {
        case let tableVC as TableVC:
            numCells = tableVC.dataSource.numCells
        case let collectionVC as CollectionVC:
            numCells = collectionVC.dataSource.numCells
        default:
            clearNumCellsInfo()
            return
        }
        
        numCellsLabel.text = "Num Cells - \((vc as! UIViewController).title!): \(numCells)"
        numCellsStepper.isUserInteractionEnabled = true
        numCellsStepper.value = Double(numCells)
    }
    
    
    
    
    
    // ========
    // MARK: - UITableViewDelegate - Swipe Actions
    // ========
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions: [UIContextualAction] = []
        let scrollTopAction = UIContextualAction(style: .normal, title: "Scroll ⬆") { [weak self](action, view, completion) in
            guard let self = self else { return }
            
            self.exampleScrollStackController.scrollToItem(at: indexPath.row, scrollPosition: .top, animated: true)
            
            completion(true)
        }
        actions.append(scrollTopAction)
        
        let scrollBotAction = UIContextualAction(style: .normal, title: "Scroll ⬇") { [weak self](action, view, completion) in
            guard let self = self else { return }
            
            self.exampleScrollStackController.scrollToItem(at: indexPath.row, scrollPosition: .bottom, animated: true)
            
            completion(true)
        }
        actions.append(scrollBotAction)
        
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions: [UIContextualAction] = []
        let deleteAction = UIContextualAction(style: .destructive, title: "Remove") { [weak self](action, view, completion) in
            guard let self = self else { return }
            
            self.exampleScrollStackController.viewControllers.remove(at: indexPath.row)
            
            self.diagnosticsTableViewDataSource.scrollStackItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completion(true)
        }
        actions.append(deleteAction)
        return UISwipeActionsConfiguration(actions: actions)
    }
}
