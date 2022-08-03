//
//  UIExtensions.swift
//  goat
//
//  Created by Michael Martin on 29/07/2022.
//

import Foundation
import UIKit

extension UIView {
    func applyCurvedCorners(_ percentageOfViewHeight: CGFloat) {
        layer.cornerRadius = bounds.height*percentageOfViewHeight
        layer.cornerCurve = .continuous
    }
    
    func applyShadow() {
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.1
    }
}
