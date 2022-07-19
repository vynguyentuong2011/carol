//
//  OnboardingPageViewModel.swift
//  Carol
//
//  Created by Vi Nguyen on 20/07/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol OnboardingPagePresentableListener: AnyObject {
    func didBecomeActive()
    
}

protocol OnboardingPagePresentable: AnyObject {
    var items: BehaviorRelay<[OnboardingItem]> { get }
}

class OnboardingPageViewModel: OnboardingPagePresentableListener {
    
    // MARK: - Properties
    weak var presenter: OnboardingPagePresentable?
    private var disposeBag = DisposeBag()
    private let configRepository: CRConfigRepositoryType
    
    func didBecomeActive() {
        disposeBag = DisposeBag()
        loadConfig()
    }
    
    init(configRepository: CRConfigRepositoryType = CRConfigRepository()) {
        self.configRepository = configRepository
    }
    
    private func loadConfig() {
        self.configRepository.getOnboardingConfig()
            .subscribeNext { [weak self] items in
                self?.presenter?.items.accept(items)
            }
            .disposed(by: disposeBag)
    }
}
