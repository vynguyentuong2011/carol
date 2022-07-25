//
//  SubscribeManager.swift
//  Carol
//
//  Created by Vi Nguyen on 25/07/2022.
//

import UIKit

class SubscribeManager {
    
    static let shared = SubscribeManager()
    
    public func getSubscribeViewController() -> UIViewController? {
        let subscribeVC = SubscribeViewController.instantiate()
        let subscribeViewModel = SubscribeViewModel()
        subscribeViewModel.didSelectedItem = { item in
            
        }
        subscribeVC.viewModel = subscribeViewModel
        return subscribeVC
    }
}
