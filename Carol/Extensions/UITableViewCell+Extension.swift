//
//  UITableViewCell+Extension.swift
//  Carol
//
//  Created by Vi Nguyen on 25/07/2022.
//

import Foundation
import UIKit

// MARK: - Register cell helper
public extension UITableView {
    func registerNib<T: UITableViewCell>(_ nibClassType: T.Type, bundle: Bundle? = nil) {
        let id = String(describing: nibClassType.self)
        let nib = UINib(nibName: id, bundle: bundle ?? Bundle(for: T.self))
        register(nib, forCellReuseIdentifier: id)
    }
    
    func registerClass<T: UITableViewCell>(_ classType: T.Type) {
        let id = String(describing: classType.self)
        register(classType, forCellReuseIdentifier: id)
    }
    
    func dequeueCell<T: UITableViewCell>(_ classType: T.Type = T.self, for indexPath: IndexPath) -> T {
        let id = String(describing: classType.self)
        return (dequeueReusableCell(withIdentifier: id, for: indexPath) as! T)
    }
}

