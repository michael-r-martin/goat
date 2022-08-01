//
//  CustomPropertyWrappers.swift
//  goat
//
//  Created by Michael Martin on 29/07/2022.
//

import Foundation
import UIKit

@propertyWrapper struct DisplayTime {
    var wrappedValue: Double
    
    var projectedValue: String {
        let formattedTime = convertTimestampToTimeAgo(timestamp: wrappedValue)
        
        return formattedTime
    }
    
    func convertTimestampToTimeAgo(timestamp: Double) -> String {
        let currentTime = Date().timeIntervalSince1970
        
        let timeDifference = Int(currentTime-timestamp)
        
        switch timeDifference {
        case 0...59:
            return "\(timeDifference) S"
        case 60...3599:
            return "\(timeDifference/60) Min"
        case 3599...86399:
            return "\(timeDifference/3600) Hr"
        case 86400...:
            return "\(timeDifference/86400) D"
        default: return ""
        }
    }
}

@propertyWrapper struct AutoDefaultString {
    var wrappedValue: String?
    var defaultValue: String
    
    init(defaultValue: String) {
        self.defaultValue = defaultValue
    }
    
    var projectedValue: String {
        get {
            if let wrappedValue = wrappedValue {
                return wrappedValue
            } else {
                return defaultValue
            }
        }
        set {
            wrappedValue = newValue
        }
    }
}

//@propertyWrapper struct CornerRadius {
//    var wrappedValue: UIView
//    var percentage: CGFloat
//    
//    init(cornerPercentage: CGFloat) {
//        self.percentage = cornerPercentage
//    }
//    
//    var projectedValue: CGFloat {
//        return wrappedValue.bounds.width*percentage
//    }
//}
