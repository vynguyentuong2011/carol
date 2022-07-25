//
//  SignupManager.swift
//  Carol
//
//  Created by Vi Nguyen on 23/07/2022.
//

import UIKit

class SignupManager {
    
    static let shared = SignupManager()
    
    public func presentSignUpViewController(viewController: UIViewController, completion: ((Bool) -> Void)?) {
        let signUpViewController = SignupViewController.instantiate()
        signUpViewController.viewModel = SignupViewModel()
        signUpViewController.handler = completion
        
        let navigationController = MainNavigationController(rootViewController: signUpViewController)
        viewController.present(navigationController, animated: true, completion: nil)
    }
}
