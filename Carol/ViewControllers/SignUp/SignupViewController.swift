//
//  SignupViewController.swift
//  Carol
//
//  Created by Vi Nguyen on 23/07/2022.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class SignupViewController: BaseViewController, SignupPresentable {
    
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var emailTextField: AuthenTextField!
    @IBOutlet weak var usernameTitle: UILabel!
    @IBOutlet weak var usernameTextField: AuthenTextField!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var passwordTextField: AuthenTextField!
    @IBOutlet weak var confirmPasswordTitle: UILabel!
    @IBOutlet weak var confirmPasswordTextField: AuthenTextField!
    @IBOutlet weak var orgTitle: UILabel!
    @IBOutlet weak var orgTextField: AuthenTextField!
    @IBOutlet weak var creatAccountBtn: UIButton!
    @IBOutlet weak var acceptTermBtn: UIButton!
    @IBOutlet weak var loginLabel: UILabel!
    
    static func instantiate() -> SignupViewController {
        UIStoryboard(
            name: "Authenticate",
            bundle: Bundle(for: SignupViewController.self)
        ).instantiateViewController(
            withIdentifier: String(describing: SignupViewController.self)
        ) as! SignupViewController
    }
    
    var showLoading: BehaviorRelay<Bool> = .init(value: false)
    var submitServerErrorMessage: BehaviorRelay<String?> = .init(value: nil)
    var isSelected: BehaviorRelay<Bool?> = .init(value: false)
    var selectedValue: Bool = false
    var handler: ((Bool) -> Void)?
    private lazy var selectedImage = UIImage(named: "checkbox")
    private lazy var unselectedImage = UIImage(named: "uncheck-box")
    
    public var viewModel: SignupViewModel! {
        didSet {
            viewModel?.presenter = self
        }
    }
    var listener: SignupPresentableListener? { return viewModel }
    private var presenting: SignupPresentable { return self }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didBecomeActive()
        configurePresenter()
        configureAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureIQKeyboard()
        setupDismissButtonItem()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()

    }
    
    private func setupUI() {
        emailTitle.attributedText = LoginViewController.attributedTextTitle(title: "Email", required: true)
        usernameTitle.attributedText = LoginViewController.attributedTextTitle(title: "Username", required: false)
        passwordTitle.attributedText = LoginViewController.attributedTextTitle(title: "Password", required: true)
        confirmPasswordTitle.attributedText = LoginViewController.attributedTextTitle(title: "Confirm Password", required: true)
        orgTitle.attributedText = LoginViewController.attributedTextTitle(title: "Organization", required: true)
        
        emailTextField.atributedTitle = LoginViewController.attributedTitle(title: "Enter your email")
        emailTextField.keyboardType = .emailAddress
        emailTextField.clearButtonMode = .whileEditing
        
        usernameTextField.atributedTitle = LoginViewController.attributedTitle(title: "Enter your username")
        usernameTextField.keyboardType = .default
        usernameTextField.clearButtonMode = .whileEditing
        
        passwordTextField.atributedTitle = LoginViewController.attributedTitle(title: "Enter your password")
        passwordTextField.isSecureTextEntry = true
        
        confirmPasswordTextField.atributedTitle = LoginViewController.attributedTitle(title: "Enter your password")
        confirmPasswordTextField.isSecureTextEntry = true
        
        orgTextField.atributedTitle = LoginViewController.attributedTitle(title: "Enter your organization's name")
        orgTextField.keyboardType = .default
        orgTextField.clearButtonMode = .whileEditing
        
        creatAccountBtn.backgroundColor = UIColor(rgb: 0x3D5CFF)
        creatAccountBtn.layer.cornerRadius = 12
        creatAccountBtn.titleLabel?.attributedText = LoginViewController.loginAttributedTitle(title: "Create account")
        
        loginLabel.attributedText = SignupViewController.alreadyAttributedTitle(title: "Already have an account?")
        loginLabel.rx.tapGesture()
            .when(.recognized)
            .mapToVoid()
            .throttle(.milliseconds(250), scheduler: MainScheduler.instance)
            .subscribeNext { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configurePresenter() {
        guard let viewModel = self.viewModel else { return }
        
        viewModel.emailEditingChanged
            .asDriver(onErrorJustReturn: nil)
            .distinctUntilChanged({ $0 == $1 })
            .drive(emailTextField.rx.text)
            .disposed(by: disposeBag)
            
        viewModel.passwordEditingChanged
            .asDriver(onErrorJustReturn: nil)
            .distinctUntilChanged({ $0 == $1 })
            .drive(passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        
        emailTextField.textDidChange = { text in
            if viewModel.currentEmailText != text {
                viewModel.updateEmailText(text)
            }
        }
        
        emailTextField.didBeginEditing = {
            viewModel.beginEditEmail()
        }
        
        emailTextField.didEndEditing = {
            viewModel.endEditEmail()
        }
        
        passwordTextField.textDidChange = { text in
            if viewModel.currentPasswordText != text {
                viewModel.updatePasswordText(text)
            }
        }
                                     
        passwordTextField.didBeginEditing = {
            viewModel.beginEditPassword()
        }
        
        passwordTextField.didEndEditing = {
            viewModel.endEditPassword()
        }
        
        confirmPasswordTextField.didEndEditing = { [weak self] in
            guard let self = self else { return }
            viewModel.validateConfirmPassword(self.passwordTextField.text ?? "", self.confirmPasswordTextField.text ?? "")
        }
        
        viewModel.confirmPasswordState.subscribeNext({ [weak self] state in
            guard let self = self else { return }
            self.handleState(state, self.confirmPasswordTextField)
        })
        .disposed(by: disposeBag)
        
        viewModel.emailState.subscribeNext({ [weak self] state in
            guard let self = self else { return }
            self.handleState(state, self.emailTextField)
        })
        .disposed(by: disposeBag)
        
        viewModel.passwordState.subscribeNext({ [weak self] state in
            guard let self = self else { return }
            self.handleState(state, self.passwordTextField)
        })
        .disposed(by: disposeBag)
        
        presenting.isSelected
            .filter({ $0 != nil })
            .subscribeNext { [weak self] isSelected in
                guard let self = self, let isSelected = isSelected else { return }
                self.selectedValue = isSelected
                self.updateImage()
            }
            .disposed(by: disposeBag)
        
        presenting.showLoading
            .asDriver()
            .drive(onNext: { [weak self] show in
                guard let self = self else { return }
                if show {
                    self.showLoadingView()
                } else {
                    self.dismissLoadingView()
                }
            }).disposed(by: disposeBag)
    }
    
    private func configureAction() {
        creatAccountBtn.rx.tap
            .subscribeNext { [weak self] _ in
                guard let self = self else { return }
                if let subscribeViewController = SubscribeManager.shared.getSubscribeViewController() {
                    self.navigationController?.pushViewController(subscribeViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        acceptTermBtn.rx.tap
            .subscribeNext { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.setCheckboxValue(checked: !self.selectedValue)
            }
            .disposed(by: disposeBag)
    }
    
    private func updateImage() {
        let image = selectedValue ? selectedImage : unselectedImage
        self.acceptTermBtn.setImage(image, for: .normal)
    }
}

extension SignupViewController {
    public static func alreadyAttributedTitle(title: String) -> NSAttributedString? {
        let att = NSMutableAttributedString(
            string: title,
            attributes: [.foregroundColor: UIColor(rgb: 0x858597)]
        )
        let signUp = NSAttributedString(string: " Log in", attributes: [.foregroundColor: UIColor(rgb: 0x5555CB)])
        att.append(signUp)
        return att
    }
}
