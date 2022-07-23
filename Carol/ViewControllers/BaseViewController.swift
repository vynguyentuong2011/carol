//
//  BaseViewController.swift
//  Carol
//
//  Created by Vi Nguyen on 21/07/2022.
//

import UIKit
import RxSwift
import IQKeyboardManagerSwift

public class BaseViewController: UIViewController {
    
    // MARK: - rx
    
    var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setupBackButtonItem() {
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "left"), style: .plain, target: self, action: #selector(backButtonHandle))
        backButtonItem.title = ""
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func backButtonHandle() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setupDismissButtonItem() {
        let backButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(dismissButtonHandle))
        backButtonItem.title = ""
        self.navigationItem.leftBarButtonItem = backButtonItem
    }
    
    @objc func dismissButtonHandle() {
        self.navigationController?.dismiss(animated: true)
    }
    
    // MARK: - keyboard
    
    func configureIQKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.layoutIfNeededOnUpdate = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
        IQKeyboardManager.shared.toolbarBarTintColor = .white
        IQKeyboardManager.shared.toolbarTintColor = UIColor(rgb: 0x3D5CFF)
    }
    
    func disableIQKeyboard() {
        IQKeyboardManager.shared.enable = false
    }
    
    func setupNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    public func handleState(_ state: AuthenTextFieldState, _ textField: AuthenTextField) {
        textField.errorMessage = nil
        switch state {
        case .idle:
            textField.borderColor = UIColor(rgb: 0xB8B8D2)
            textField.isEnabled = true
        case .active:
            textField.borderColor = UIColor(rgb: 0x3D5CFF)
            textField.isEnabled = true
        case .error(let msg):
            textField.isEnabled = true
            textField.errorMessage = msg
            textField.borderColor = UIColor(rgb: 0xFFEBF0)
        }
    }
}

extension BaseViewController {
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
}
