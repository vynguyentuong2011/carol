//
//  LoginViewController.swift
//  Carol
//
//  Created by Vi Nguyen on 21/07/2022.
//

import Foundation
import RxSwift
import RxRelay
import RxGesture
import UIKit

class LoginViewController: BaseViewController, LoginPresentable {
    
    @IBOutlet weak var emailTextField: AuthenTextField!
    @IBOutlet weak var passwordTextField: AuthenTextField!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountLabel: UILabel!
    @IBOutlet weak var alreadyStackView: UILabel!
    @IBOutlet weak var bottomView: UIStackView!
    
    static func instantiate() -> LoginViewController {
        UIStoryboard(
            name: "Authenticate",
            bundle: Bundle(for: LoginViewController.self)
        ).instantiateViewController(
            withIdentifier: String(describing: LoginViewController.self)
        ) as! LoginViewController
    }
    
    var showLoading: BehaviorRelay<Bool> = .init(value: false)
    var submitServerErrorMessage: BehaviorRelay<String?> = .init(value: nil)
    var handler: ((Bool) -> Void)?
    
    public var viewModel: LoginViewModel! {
        didSet {
            viewModel?.presenter = self
        }
    }
    var listener: LoginPresentableListener? { return viewModel }
    private var presenting: LoginPresentable { return self }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didBecomeActive()
        configurePresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureIQKeyboard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func setupNotification() {
        
    }
    
    private func setupUI() {
        emailTitle.text = "Email"
        passwordTitle.text = "Password"
        
        emailTextField.atributedTitle = LoginViewController.attributedTitle(title: "Enter your email", required: true)
        emailTextField.keyboardType = .emailAddress
        emailTextField.clearButtonMode = .whileEditing
        
        passwordTextField.atributedTitle = LoginViewController.attributedTitle(title: "Enter your password", required: true)
        passwordTextField.keyboardType = .default
        passwordTextField.isSecureTextEntry = true
        
        forgetPasswordButton.setAttributedTitle(LoginViewController.forgetPWAttributedTitle(title: "Forget password?"), for: .normal)
        forgetPasswordButton.titleLabel?.textAlignment = .right
        forgetPasswordButton.sizeToFit()
        
        loginButton.backgroundColor = UIColor(rgb: 0x3D5CFF)
        loginButton.layer.cornerRadius = 12
        loginButton.titleLabel?.attributedText = LoginViewController.loginAttributedTitle(title: "Log In")
        
        alreadyHaveAccountLabel.attributedText = LoginViewController.alreadyAttributedTitle(title: "Don’t have an account?")
        alreadyHaveAccountLabel.rx.tapGesture()
            .when(.recognized)
            .subscribeNext { [weak self] _ in
                guard let self = self else { return }
            }
            .disposed(by: disposeBag)
    }
    
    private func configurePresenter() {
        guard let viewModel = viewModel else { return }
        
        emailTextField.textDidChange = { text in
            if viewModel.currentText != text {
                viewModel.updateText(text)
            }
        }
        
        emailTextField.didBeginEditing = {
            viewModel.beginEdit()
        }
        
        emailTextField.didEndEditing = {
            viewModel.endEdit()
        }
        
        viewModel.editingChanged
            .asDriver(onErrorJustReturn: nil)
            .distinctUntilChanged({ $0 == $1 })
            .drive(emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.emailState.subscribeNext({ [weak self] state in
            guard let self = self else { return }
            self.handleState(state, self.emailTextField)
        }).disposed(by: disposeBag)
    }
    
    override func handleState(_ state: AuthenTextFieldState, _ textField: AuthenTextField) {
        super.handleState(state, textField)
    }
}

extension LoginViewController {
    public static func attributedTitle(title: String, required: Bool) -> NSAttributedString? {
        let att = NSMutableAttributedString(
            string: title,
            attributes: [.foregroundColor: UIColor(rgb: 0x858597)]
        )
        return att
    }
    
    public static func forgetPWAttributedTitle(title: String) -> NSAttributedString? {
        let att = NSMutableAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor(rgb: 0x3D5CFF),
                .font: UIFont.systemFont(ofSize: 14)
            ]
        )
        return att
    }
    
    public static func loginAttributedTitle(title: String) -> NSAttributedString? {
        let att = NSMutableAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 16)
            ]
        )
        return att
    }
    
    public static func alreadyAttributedTitle(title: String) -> NSAttributedString? {
        let att = NSMutableAttributedString(
            string: title,
            attributes: [.foregroundColor: UIColor(rgb: 0x858597)]
        )
        let signUp = NSAttributedString(string: " Sign up", attributes: [.foregroundColor: UIColor(rgb: 0x3D5CFF)])
        att.append(signUp)
        return att
    }
}
