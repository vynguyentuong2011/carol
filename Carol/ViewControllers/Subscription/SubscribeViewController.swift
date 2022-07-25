//
//  SubscribeViewController.swift
//  Carol
//
//  Created by Vi Nguyen on 25/07/2022.
//

import UIKit
import RxSwift
import RxRelay
import RxDataSources

enum SubscribeItem: IdentifiableType, Equatable {
    var identity: String {
        return viewModel.identity
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    case selectItem(_ viewModel: SubscribeTableViewViewModel)
    
    var viewModel: SubscribeTableViewViewModel {
        switch self {
        case .selectItem(let vm):
            return vm
        }
    }
    
}

struct SubscribeFormSection: AnimatableSectionModelType {
    typealias Identity = String
    typealias Item = SubscribeItem
    
    init(original: SubscribeFormSection, items: [SubscribeItem]) {
        self = original
        self.items = items
    }
    
    init(header: String?, items: [SubscribeItem]) {
        self.header = header
        self.items = items
    }
    
    var key: String = ""
    var header: String?
    var items: [SubscribeItem] = []
    var identity: String {
        return header.orEmpty
    }
}

class SubscribeViewController: BaseViewController, SubscribePresentable {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var payButton: UIButton!
    
    var showLoading: BehaviorRelay<Bool> = .init(value: false)
    var submitServerErrorMessage: BehaviorRelay<String?> = .init(value: nil)
    var sections: BehaviorRelay<[SubscribeFormSection]> = .init(value: [])
    var stateDict: [IndexPath : Bool] = [:]
    
    public var viewModel: SubscribeViewModel! {
        didSet {
            viewModel?.presenter = self
        }
    }
    var listener: SubscribePresentableListener? { return viewModel }
    private var presenting: SubscribePresentable { return self }
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<SubscribeFormSection> = makeDataSource()
    
    static func instantiate() -> SubscribeViewController {
        UIStoryboard(
            name: "Authenticate",
            bundle: Bundle(for: SubscribeViewController.self)
        ).instantiateViewController(
            withIdentifier: String(describing: SubscribeViewController.self)
        ) as! SubscribeViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurePresenter()
        configureEvents()
        viewModel.didBecomeActive()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBackButtonItem()
    }
    
    private func configureUI() {
        initTableView()
        payButton.backgroundColor = UIColor(rgb: 0x3D5CFF)
        payButton.layer.cornerRadius = 12
        payButton.titleLabel?.attributedText = LoginViewController.loginAttributedTitle(title: "Pay")
    }
    
    private func configurePresenter() {
        presenting.sections
            .asDriver()
            .drive(tableView.rx.items(dataSource: dataSource))
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
        
        presenting.submitServerErrorMessage
            .asDriver()
            .skip(1)
            .drive(onNext: { [weak self] errorMsg in
                guard let self = self else { return }
                self.showSubmitErrorMessage(errorMsg)
            }).disposed(by: disposeBag)
    }
    
    /// Invalidate layout to begin caching needed cell sizes
    private func reload() {
        self.tableView.reloadData()
    }
    
    private func configureEvents() {
        tableView.rx.itemSelected
            .subscribeNext { [weak self] ip in
                self?.tableView?.visibleCells.forEach { cell in
                    if let cell = cell as? SubscribeTableViewCell,
                       let viewModel = cell.viewModel {
                        viewModel.isSelected.accept(false)
                    }
                }
                
                if let cell = self?.tableView.cellForRow(at: ip) as? SubscribeTableViewCell,
                      let viewModel = cell.viewModel {
                    viewModel.isSelected.accept(!viewModel.isSelected.value)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private final func initTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.registerNib(SubscribeTableViewCell.self)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

// MARK: - RxDelegate
extension SubscribeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 143
    }
}

// MARK: - RxDataSource

extension SubscribeViewController {
    fileprivate func makeDataSource() -> RxTableViewSectionedReloadDataSource<SubscribeFormSection> {
        return .init { [weak self] (_, tableView, indexPath, item) -> UITableViewCell in
            guard self != nil else { return UITableViewCell() }
            switch item {
            case let .selectItem(vm):
                let cell: SubscribeTableViewCell = tableView.dequeueCell(for: indexPath)
                cell.bind(to: vm)
                return cell
            }
        }
    }
    
}
