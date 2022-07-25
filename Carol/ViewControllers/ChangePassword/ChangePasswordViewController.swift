//
//  ChangePasswordViewController.swift
//  Carol
//
//  Created by Vi Nguyen on 23/07/2022.
//

import Foundation
import RxSwift
import RxRelay
import UIKit

class ChangePasswordViewController: BaseViewController, ChangePasswordPresentable {
    
    @IBOutlet weak var currentPasswordLabel: UILabel!
    @IBOutlet weak var currentPasswordTextField: AuthenTextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: AuthenTextField!
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    @IBOutlet weak var repeatPasswordTextField: AuthenTextField!
    @IBOutlet weak var changePasswordBtn: UIButton!
    
    static func instantiate() -> ChangePasswordViewController {
        UIStoryboard(
            name: "Authenticate",
            bundle: Bundle(for: ChangePasswordViewController.self)
        ).instantiateViewController(
            withIdentifier: String(describing: ChangePasswordViewController.self)
        ) as! ChangePasswordViewController
    }
    
    var showLoading: BehaviorRelay<Bool> = .init(value: false)
    var submitServerErrorMessage: BehaviorRelay<String?> = .init(value: nil)
    
    public var viewModel: ChangePasswordViewModel! {
        didSet {
            viewModel?.presenter = self
        }
    }
    var listener: ChangePasswordPresentableListener? { return viewModel }
    private var presenting: ChangePasswordPresentable { return self }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didBecomeActive()
        configurePresenter()
        configureAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureIQKeyboard()
        setupBackButtonItem()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()

    }
    
    private func setupUI() {
        currentPasswordLabel.attributedText = LoginViewController.attributedTextTitle(title: "Current Password", required: true)
        passwordLabel.attributedText = LoginViewController.attributedTextTitle(title: "New Password", required: true)
        repeatPasswordLabel.attributedText = LoginViewController.attributedTextTitle(title: "Confirm New Password", required: true)
        
        currentPasswordTextField.atributedTitle = LoginViewController.attributedTitle(title: "Enter current password")
        currentPasswordTextField.isSecureTextEntry = true
        passwordTextField.atributedTitle = LoginViewController.attributedTitle(title: "Enter your password")
        passwordTextField.isSecureTextEntry = true
        repeatPasswordTextField.atributedTitle = LoginViewController.attributedTitle(title: "Confirm your password")
        repeatPasswordTextField.isSecureTextEntry = true
        
        changePasswordBtn.backgroundColor = UIColor(rgb: 0x3D5CFF)
        changePasswordBtn.layer.cornerRadius = 12
        changePasswordBtn.titleLabel?.attributedText = LoginViewController.loginAttributedTitle(title: "Change")
        
    }
    
    private func configurePresenter() {
        guard let viewModel = viewModel else { return }
        
        repeatPasswordTextField.didEndEditing = { [weak self] in
            guard let self = self else { return }
            viewModel.validatePassword(self.passwordTextField.text ?? "", self.repeatPasswordTextField.text ?? "")
        }
        
        viewModel.confirmPasswordState.subscribeNext({ [weak self] state in
            guard let self = self else { return }
            self.handleState(state, self.repeatPasswordTextField)
        })
        .disposed(by: disposeBag)
    }
    
    private func configureAction() {
        changePasswordBtn.rx.tap
            .subscribeNext { [weak self] _ in
                guard let self = self else { return }
                let successViewController = ChangePasswordSuccessViewController.instantiate()
                successViewController.modalPresentationStyle = .fullScreen
                self.navigationController?.present(successViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
