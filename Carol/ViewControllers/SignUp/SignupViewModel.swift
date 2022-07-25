//
//  SignupViewModel.swift
//  Carol
//
//  Created by Vi Nguyen on 23/07/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol SignupPresentableListener: AnyObject {
    func didBecomeActive()
}

protocol SignupPresentable: AnyObject {
    var showLoading: BehaviorRelay<Bool> { get }
    var submitServerErrorMessage: BehaviorRelay<String?> { get }
    var isSelected: BehaviorRelay<Bool?> { get }
}

class SignupViewModel: SignupPresentableListener {
    
    // MARK: - Properties
    weak var presenter: SignupPresentable?
    internal var listening: SignupPresentableListener { return self }
    private var disposeBag = DisposeBag()
    private let emailTextRelay = BehaviorRelay<String?>(value: nil)
    private let passwordTextRelay = BehaviorRelay<String?>(value: nil)
    private let beginEditingRelay: PublishRelay<Void> = .init()
    private let endEditingRelay: PublishRelay<Void> = .init()
    
    /// Emits editing changed with value
    var emailEditingChanged: Observable<String?> {
        let begin = beginEditingRelay.map({ self.emailTextRelay.value })
        let textChanged = emailTextRelay.asObservable()
            .map({ $0.orEmpty })
            .mapToOptional()
            .distinctUntilChanged({ $0 == $1 })
        return Observable.of(begin, textChanged).merge()
    }
    
    /// Emits editing changed with value
    var passwordEditingChanged: Observable<String?> {
        let begin = beginEditingRelay.map({ self.passwordTextRelay.value })
        let textChanged = passwordTextRelay.asObservable()
            .map({ $0.orEmpty })
            .mapToOptional()
            .distinctUntilChanged({ $0 == $1 })
        return Observable.of(begin, textChanged).merge()
    }
    
    let emailState = BehaviorRelay<AuthenTextFieldState>(value: .idle)
    var currentEmailText: String? {
        emailTextRelay.value
    }
    
    let passwordState = BehaviorRelay<AuthenTextFieldState>(value: .idle)
    var currentPasswordText: String? {
        passwordTextRelay.value
    }
    
    let confirmPasswordState = BehaviorRelay<AuthenTextFieldState>(value: .idle)
    
    func beginEditEmail() {
        self.emailState.accept(.active)
        beginEditingRelay.accept(())
    }
    
    func endEditEmail() {
        validateEmail()
        endEditingRelay.accept(())
    }
    
    func updateEmailText(_ text: String?) {
        self.emailTextRelay.accept(text)
    }
    
    func beginEditPassword() {
        self.passwordState.accept(.active)
        beginEditingRelay.accept(())
    }
    
    func endEditPassword() {
        validatePassword()
        endEditingRelay.accept(())
    }
    
    func updatePasswordText(_ text: String?) {
        self.passwordTextRelay.accept(text)
    }
    
    func validateEmail() {
        if ValidateHelper.isValidEmail(currentEmailText ?? "") {
            self.emailState.accept(.idle)
        } else {
            self.emailState.accept(.error("Invalid email"))
        }
    }
    
    func validatePassword() {
        if ValidateHelper.isValidPassword(currentPasswordText ?? "") {
            self.passwordState.accept(.idle)
        } else {
            self.passwordState.accept(.error("At least one capital, numeric or special character"))
        }
    }
    
    func validateConfirmPassword(_ old: String, _ new: String) {
        if old == new {
            self.confirmPasswordState.accept(.idle)
        } else {
            self.confirmPasswordState.accept(.error("New password not matched"))
        }
    }
    
    func setCheckboxValue(checked: Bool) {
        presenter?.isSelected.accept(checked)
    }
    
    func didBecomeActive() {
        
    }
}
