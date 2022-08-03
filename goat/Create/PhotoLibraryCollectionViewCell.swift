//
//  PhotoLibraryCollectionViewCell.swift
//  goat
//
//  Created by Michael Martin on 03/08/2022.
//

import UIKit

class PhotoLibraryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellStyleView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    
    func styleCell() {
        mainImageView.applyCurvedCorners(0.3)
    }
    
}
