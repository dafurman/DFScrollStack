//
//  CollectionCell.swift
//  DFScrollStack
//
//  Created by David Furman on 2/25/19.
//

import UIKit

/// A cell to be used within CollectionVC.
final class CollectionCell: UICollectionViewCell {
    
    // ========
    // MARK: - Properties
    // ========
    
    @IBOutlet private weak var label: UILabel!
    
    
    
    
    
    // ========
    // MARK: - Configuration
    // ========
    
    func setText(_ text: String) {
        label.text = text
    }
}
