//
//  OnboardingPageViewController.swift
//  Carol
//
//  Created by Vi Nguyen on 20/07/2022.
//

import UIKit
import RxSwift
import RxRelay

protocol  OnboardingPageViewControllerDelegate: AnyObject {
    func setupPageController(numberOfPage: Int)
    func turnPageController(to index: Int)
}

class OnboardingPageViewController: UIPageViewController, OnboardingPagePresentable {
    
    // MARK: - Properties
    public var viewModel: OnboardingPageViewModel! {
        didSet {
            viewModel?.presenter = self
        }
    }
    var listener: OnboardingPagePresentableListener? { return viewModel }
    private var presenting: OnboardingPagePresentable { return self }
    var items: BehaviorRelay<[OnboardingItem]> = .init(value: [])
    private var onboardingItems: [OnboardingItem] = []
    weak var pageViewControllerDelegate: OnboardingPageViewControllerDelegate?
    var currentIndex = 0
    
    // MARK: - rx
    var disposeBag = DisposeBag()
    
    // MARK: - Life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePresenter()
        viewModel.didBecomeActive()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    private func configureUI() {
        dataSource = self
        delegate = self
        if let firstViewController = contentViewController(at: onboardingItems.first?.index ?? 0) {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func configurePresenter() {
        presenting.items
            .subscribeNext { [weak self] items in
                guard let self = self, items.count != 0 else { return }
                self.onboardingItems = items
            }
            .disposed(by: disposeBag)
    }
    
    private func contentViewController(at index: Int) -> OnboardingContentViewController? {
        guard index > 0 || index < onboardingItems.count else {
            return nil
        }
        guard let currentOnboardingItem = onboardingItems.filter({ $0.index == index }).first else {
            return nil
        }
        let onboardingContentVC = OnboardingContentViewController.instantiate()
        onboardingContentVC.item = currentOnboardingItem
        pageViewControllerDelegate?.setupPageController(numberOfPage: onboardingItems.count)
        return onboardingContentVC
    }
    
    func turnPage(to index: Int) {
        currentIndex = index
        if let currentController = contentViewController(at: index) {
            setViewControllers([currentController], direction: .forward, animated: true)
            self.pageViewControllerDelegate?.turnPageController(to: currentIndex)
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if var index = (viewController as? OnboardingContentViewController)?.item?.index {
            index += 1
            return contentViewController(at: index)
        }
        return UIViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let pageContentViewController = pageViewController.viewControllers?.first as? OnboardingContentViewController {
            if let currentIndex = pageContentViewController.item?.index {
                self.pageViewControllerDelegate?.turnPageController(to: currentIndex)
            }
        }
        return UIViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
}
