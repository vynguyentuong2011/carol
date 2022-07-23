//
//  ChangePasswordManager.swift
//  Carol
//
//  Created by Vi Nguyen on 23/07/2022.
//

import UIKit

class ChangePasswordManager {
    
    static let shared = ChangePasswordManager()
    
    public func getChangePasswordViewController() -> UIViewController? {
        let changePasswordVC = ChangePasswordViewController.instantiate()
        let changePasswordViewModel = ChangePasswordViewModel()
        changePasswordVC.viewModel = changePasswordViewModel
        return changePasswordVC
    }
}
