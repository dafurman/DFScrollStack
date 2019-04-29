//
//  IBVC.swift
//  DFScrollStackView
//
//  Created by David Furman on 2/20/19.
//

import UIKit

/// A ScrollStackContainable that has a collection view.
final class CollectionVC: ScrollVC {
    
    // ========
    // MARK: - Properties
    // ========
    
    override var scrollView: UIScrollView? { return collectionView }
    
    /// This collection view view is used as the ScrollStackContainable's scrollView.
    private(set) var collectionView: UICollectionView! {
        didSet {
            collectionView.isScrollEnabled = false
            collectionView.dataSource = dataSource
            collectionView.clipsToBounds = true
            collectionView.allowsSelection = false
            
            collectionView.register(CollectionCell.nib(), forCellWithReuseIdentifier: ScrollVCDataSource.cellIdentifier)

            collectionView.backgroundColor = .yellow
        }
    }

    /// The data source used for the `collectionView`.
    let dataSource = CollectionVCDataSource()
    
    
    
    
    
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
        let layout: UICollectionViewFlowLayout = {
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            layout.itemSize = CGSize(width: 50, height: 50)
            return layout
        }()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
}





// ========
// MARK: - CollectionVC: ScrollVCDataSourceDelegate
// ========

extension CollectionVC: ScrollVCDataSourceDelegate {
    func numCellsDidChange(numCells: Int) {
        collectionView?.reloadData()
        collectionView?.layoutIfNeeded()
        updatePreferredContentSize()
    }
}
