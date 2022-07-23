//
//  ChangePasswordViewModel.swift
//  Carol
//
//  Created by Vi Nguyen on 23/07/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol ChangePasswordPresentableListener: AnyObject {
    func didBecomeActive()
}

protocol ChangePasswordPresentable: AnyObject {
    var showLoading: BehaviorRelay<Bool> { get }
    var submitServerErrorMessage: BehaviorRelay<String?> { get }
}

class ChangePasswordViewModel: ChangePasswordPresentableListener {
    
    // MARK: - Properties
    weak var presenter: ChangePasswordPresentable?
    internal var listening: ChangePasswordPresentableListener { return self }
    private var disposeBag = DisposeBag()
    
    let confirmPasswordState = BehaviorRelay<AuthenTextFieldState>(value: .idle)
    
    /// Emits editing changed with value
    var editingChanged: Observable<String?> {
        let begin = beginEditingRelay.map({ self.textRelay.value })
        let textChanged = textRelay.asObservable()
            .map({ $0.orEmpty })
            .mapToOptional()
            .distinctUntilChanged({ $0 == $1 })
        return Observable.of(begin, textChanged).merge()
    }
    
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
        self.confirmPasswordState.accept(.active)
        beginEditingRelay.accept(())
    }
    
    func endEdit() {
        endEditingRelay.accept(())
    }
    
    func updateText(_ text: String?) {
        self.textRelay.accept(text)
    }
    
    func validatePassword(_ old: String, _ new: String) {
        if old == new {
            self.confirmPasswordState.accept(.idle)
        } else {
            self.confirmPasswordState.accept(.error("New password not matched"))
        }
    }
    
    func didBecomeActive() {
        
    }
}
