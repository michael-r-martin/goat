//
//  MainFeedCollectionViewCell.swift
//  goat
//
//  Created by Michael Martin on 29/07/2022.
//

import UIKit

class MainFeedCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var userImageBackgroundView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentDescriptionLabel: UITextView!
    @IBOutlet weak var messageButtonView: UIView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var reactButtonView: UIView!
    @IBOutlet weak var reactButton: UIButton!
    
    required init?(coder: NSCoder) {
        styleCell()
    }
    
    func styleCell() {
        cellBackgroundView.applyCurvedCorners(0.05)
        cellBackgroundView.applyCurvedCorners(0.04)
        
        userImageBackgroundView.applyCurvedCorners(0.8)
        userImageView.applyCurvedCorners(0.8)
        
        contentImageView.applyCurvedCorners(0.8)
        
        messageButtonView.applyCurvedCorners(1)
        reactButtonView.applyCurvedCorners(1)
    }
    
}
