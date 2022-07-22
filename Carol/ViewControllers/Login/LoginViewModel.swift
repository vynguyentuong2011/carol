//
//  LoginViewModel.swift
//  Carol
//
//  Created by Vi Nguyen on 21/07/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol LoginPresentableListener: AnyObject {
    func didBecomeActive()
}

protocol LoginPresentable: AnyObject {
    var showLoading: BehaviorRelay<Bool> { get }
    var submitServerErrorMessage: BehaviorRelay<String?> { get }
}

class LoginViewModel: LoginPresentableListener {
    
    // MARK: - Properties
    weak var presenter: LoginPresentable?
    private var disposeBag = DisposeBag()
    /// Emits editing changed with value
    var editingChanged: Observable<String?> {
        let begin = beginEditingRelay.map({ self.textRelay.value })
        let textChanged = textRelay.asObservable()
            .map({ $0.orEmpty })
            .mapToOptional()
            .distinctUntilChanged({ $0 == $1 })
        return Observable.of(begin, textChanged).merge()
    }
    let emailState = BehaviorRelay<AuthenTextFieldState>(value: .idle)
    
    /// Emits when end editing
    var endEditing: Observable<Void> {
        return endEditingRelay.asObservable()
    }
    
    var currentText: String? {
        textRelay.value
    }
    
    private let textRelay = BehaviorRelay<String?>(value: nil)
    private let beginEditingRelay: PublishRelay<Void> = .init()
    private let endEditingRelay: PublishRelay<Void> = .init()
    
    func beginEdit() {
        self.emailState.accept(.active)
        beginEditingRelay.accept(())
    }
    
    func endEdit() {
        validateEmail()
        endEditingRelay.accept(())
    }
    
    func updateText(_ text: String?) {
        self.textRelay.accept(text)
    }
    
    func didBecomeActive() {
        
    }
    
    func validateEmail() {
        if ValidateHelper.isValidEmail(currentText ?? "") {
            self.emailState.accept(.idle)
        } else {
            self.emailState.accept(.error("Invalid email"))
        }
    }
}
