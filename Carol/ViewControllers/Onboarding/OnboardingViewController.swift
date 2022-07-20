//
//  OnboardingViewController.swift
//  Carol
//
//  Created by Vi Nguyen on 20/07/2022.
//

import UIKit
import CHIPageControl

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var pageControl: CHIPageControlPuya!
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: - Properties
    weak var onBoardingPageViewController: OnboardingPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customPageControl()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let onBoardingViewController = segue.destination as? OnboardingPageViewController {
            onBoardingViewController.viewModel = OnboardingPageViewModel()
            onBoardingViewController.pageViewControllerDelegate = self
            onBoardingPageViewController = onBoardingViewController
        }
    }
    
    private func customPageControl() {
        pageControl.tintColor = UIColor(rgb: 0xEAEAFF)
        pageControl.currentPageTintColor = UIColor(rgb: 0x3D5CFF)
        pageControl.padding = 6
    }
}

extension OnboardingViewController: OnboardingPageViewControllerDelegate {
    func setupPageController(numberOfPage: Int) {
        pageControl.numberOfPages = numberOfPage
    }
    
    func turnPageController(to index: Int) {
        pageControl.progress = 0.5
        pageControl.set(progress: index, animated: true)
    }
}
