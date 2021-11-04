//
//  ListCollectionViewDelegate.swift
//  Friends
//
//  Created by Emiray Nakip on 4.11.2021.
//

import UIKit

public protocol ListCollectionLoadMoreDelegate {
    func laodMore(value:Bool)
    func didSelect(selectedIndex:Int)
}

class ListCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
    
    let numberOfItemsPerRow: CGFloat
    let interItemSpacing: CGFloat
    let itemHeight : CGFloat
    var resultsViewModel : ResultsViewModel?
    
    var loadMoreDelegate : ListCollectionLoadMoreDelegate?
    
    init(numberOfItemPerRow: CGFloat, interItemSpacing: CGFloat, itemHeight: CGFloat) {
        self.numberOfItemsPerRow = numberOfItemPerRow
        self.interItemSpacing = interItemSpacing
        self.itemHeight = itemHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let maxWidth = UIScreen.main.bounds.width
        let totalSpacing = interItemSpacing * numberOfItemsPerRow
        
        let itemWidth = (maxWidth - totalSpacing)/numberOfItemsPerRow
        
        return CGSize(width: itemWidth - 14.0, height: itemHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 14, bottom: interItemSpacing/2, right: 14)
        }
        else {
            return UIEdgeInsets(top: interItemSpacing/2, left: 0, bottom: interItemSpacing/2, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = self.resultsViewModel?.numberOfRowsInSection(indexPath.section) else { return }
       
        if indexPath.row == count - 1 {
            loadMoreDelegate?.laodMore(value: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.loadMoreDelegate?.didSelect(selectedIndex: indexPath.row)
    }
}
