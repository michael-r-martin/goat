//
//  MainFeedCollectionViewCell.swift
//  goat
//
//  Created by Michael Martin on 29/07/2022.
//

import UIKit

class MainFeedCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak private var cellBackgroundView: UIView!
    @IBOutlet weak private var mainContentView: UIView!
    @IBOutlet weak private var userImageBackgroundView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak private var optionsButton: UIButton!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentDescriptionLabel: UITextView!
    @IBOutlet weak private var messageButtonView: UIView!
    @IBOutlet weak private var messageButton: UIButton!
    @IBOutlet weak private var reactButtonView: UIView!
    @IBOutlet weak private var reactButton: UIButton!
    
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
