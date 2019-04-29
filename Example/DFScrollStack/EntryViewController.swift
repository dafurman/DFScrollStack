//
//  EntryViewController.swift
//  DFScrollStack
//
//  Created by David Furman on 4/4/19.
//

import UIKit

/// The entry point of the Example. You can pop back to this to verify that memory deallocations are being performed properly.
final class EntryViewController: UIViewController {
    
    // ========
    // MARK: - Initialization
    // ========

    init() {
        super.init(nibName: EntryViewController.nameOfView, bundle: nil)
        
        title = "Scroll Stack Controller"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    // ========
    // MARK: - Actions
    // ========

    /// Called when the user presses "Go To Example"
    @IBAction private func didPressGoToExample() {
        let vc = ExampleVC()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
