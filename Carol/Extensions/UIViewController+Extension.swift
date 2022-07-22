//
//  UIViewController+Extension.swift
//  Carol
//
//  Created by Vi Nguyen on 22/07/2022.
//

import UIKit

extension UIViewController {
    public var safeLayoutInset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            if let edgeInsets = UIApplication.shared.delegate?.window??.safeAreaInsets {
                return edgeInsets
            }
        }
        
        return UIEdgeInsets.zero
    }
}
