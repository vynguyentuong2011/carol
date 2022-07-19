//
//  UIColor+Extention.swift
//  Carol
//
//  Created by Vi Nguyen on 20/07/2022.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.hasPrefix("0x".uppercased()) {
            cString.remove(at: cString.startIndex)
            cString.remove(at: cString.startIndex)
        }
        
        assert((cString.count) == 6, "Invalid color")
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        let rgb = Int(rgbValue)
        
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF),
            green: CGFloat((rgb >> 8) & 0xFF),
            blue: CGFloat(rgb & 0xFF),
            alpha: CGFloat(rgb & 0xFF)
        )
    }
}
