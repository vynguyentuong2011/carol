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

extension UIViewController {
    
    public func show(message: String, title: String?) {
        let alertController = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        let okAction  = UIAlertAction(title: "Close", style: .default) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        self .present(alertController, animated: true, completion: nil)
    }
    
    public func show(message: String, title: String?, completionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        let okAction  = UIAlertAction(title: "Close", style: .default) { (_) in
            completionHandler?()
        }
        alertController.addAction(okAction)
        self .present(alertController, animated: true, completion: nil)
    }
}

