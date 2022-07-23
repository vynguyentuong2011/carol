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
    internal var listening: LoginPresentableListener { return self }
    private var disposeBag = DisposeBag()
//    private lazy var getLoginAction = makeLoginAction()
    
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
        disposeBag = DisposeBag()
        configureActions()
        configureListener()
    }
    
    func validateEmail() {
        if ValidateHelper.isValidEmail(currentText ?? "") {
            self.emailState.accept(.idle)
        } else {
            self.emailState.accept(.error("Invalid email"))
        }
    }
    
    private func configureActions() {
        guard let presenter = presenter else { return }
        
    }
    
    private func configureListener() {
        
    }
}

extension LoginViewModel {
//    func makeLoginAction() -> Action<Void, [AbuseReason]> {
//        .init { [unowned self] args in
//            return self.formRepository.requestFormConfig(category: categoryId, adType: adType)
//        }
//    }
}
