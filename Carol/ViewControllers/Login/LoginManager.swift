//
//  LoginManager.swift
//  Carol
//
//  Created by Vi Nguyen on 21/07/2022.
//

import UIKit

class LoginManager {
    
    static let shared = LoginManager()
    
    public func presentSignInViewController(viewController: UIViewController, completion: ((Bool) -> Void)?) {
        let loginViewController = LoginViewController.instantiate()
        loginViewController.viewModel = LoginViewModel()
        loginViewController.handler = completion
        
        let navigationController = MainNavigationController(rootViewController: loginViewController)
        viewController.present(navigationController, animated: true, completion: nil)
    }
}
