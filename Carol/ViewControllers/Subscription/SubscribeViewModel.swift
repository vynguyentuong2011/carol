//
//  SubscribeViewModel.swift
//  Carol
//
//  Created by Vi Nguyen on 25/07/2022.
//

import Foundation
import RxSwift
import RxRelay
import Action

protocol SubscribePresentableListener: AnyObject {
    func didBecomeActive()
}

protocol SubscribePresentable: AnyObject {
    var sections: BehaviorRelay<[SubscribeFormSection]> { get }
    var showLoading: BehaviorRelay<Bool> { get }
    var submitServerErrorMessage: BehaviorRelay<String?> { get }
}


class SubscribeViewModel: SubscribePresentableListener {
    
    // MARK: - Properties
    weak var presenter: SubscribePresentable?
    internal var listening: SubscribePresentableListener { return self }
    private var disposeBag = DisposeBag()
    var bag = DisposeBag()
    internal let getItemsRepository: SubscribeRepositoryType
    private lazy var getItemsAction = makeGetItemsAction()
    var subscribeModels: [SubscribeModel] = []
    var didSelectedItem: ((SubscribeModel) -> Void)?
    
    init(getItemsRepository: SubscribeRepositoryType = SubscribeRepository()) {
        self.getItemsRepository = getItemsRepository
    }
    
    func didBecomeActive() {
        bag = DisposeBag()
        configureListener()
        configureActions()
        getItemsAction.execute()
    }
    
    private func configureListener() {
        
    }
    
    private func configureActions() {
        guard let presenter = presenter else {
            return
        }
        
        getItemsAction.elements
            .subscribeNext { [weak self] res in
                guard let self = self else { return }
                var items: [SubscribeItem] = []
                for item in res {
                    items.append(self.subscribeItem(item: item))
                }
                let sections = [SubscribeFormSection(header: nil, items: items)]
                self.subscribeModels = res
                presenter.sections.accept(sections)
            }
            .disposed(by: disposeBag)
    }
    
    private func makeGetItemsAction() -> Action<Void, [SubscribeModel]> {
        .init { [unowned self] in
            return self.getItemsRepository.getSubscribeItems()
        }
    }
}

extension SubscribeViewModel {
    fileprivate func subscribeItem(item: SubscribeModel) -> SubscribeItem {
        let vm = SubscribeTableViewViewModel(item: item)
        return .selectItem(vm)
    }
}
