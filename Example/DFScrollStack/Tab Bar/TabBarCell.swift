//
//  TabBarCell.swift
//  DFScrollStack
//
//  Created by David Furman on 3/6/19.
//

import UIKit

class TabBarCell: UICollectionViewCell {
    
    // ========
    // MARK: - Properties
    // ========
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    private var item: TabBarItem!
    
    override var isSelected: Bool {
        didSet {
            imageView.isHighlighted = isSelected
            label.isHighlighted = isSelected
            
            if let item = item {
                setItemSelectionAppearances(item: item)
            }
        }
    }
    
    
    
    
    
    // ========
    // MARK: - Configuration
    // ========
    
    func configure(item: TabBarItem) {
        self.item = item
        
        label.text = item.title
        
        label.textColor = item.colors.textColor
        label.highlightedTextColor = item.colors.highlightedTextColor
        label.font = item.titleFont
        
        backgroundColor = .clear
        
        setItemSelectionAppearances(item: item)
    }
    
    private func setItemSelectionAppearances(item: TabBarItem) {
        label.font = isSelected ? item.highlightedTitleFont : item.titleFont
        imageView.tintColor = isSelected ? item.colors.image : item.colors.highlightedImage
        label.textColor = isSelected ? item.colors.textColor : item.colors.highlightedTextColor
        imageView.image = isSelected ? item.image : item.highlightedImage
    }
}
