//
//  CollectionVCDataSource.swift
//  DFScrollStack
//
//  Created by David Furman on 3/24/19.
//

import UIKit.UICollectionView

/// The datasource used for demoing the use of a view controller with a collection view in ExampleVC.
final class CollectionVCDataSource: ScrollVCDataSource {}





// ========
// MARK: - CollectionVCDataSource: UICollectionViewDataSource {
// ========

extension CollectionVCDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numCells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrollVCDataSource.cellIdentifier, for: indexPath) as! CollectionCell
        cell.backgroundColor = .red
        cell.setText("\(indexPath.item)")
        return cell
    }
}
