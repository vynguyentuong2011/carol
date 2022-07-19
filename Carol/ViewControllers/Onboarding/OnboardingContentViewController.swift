//
//  OnboardingContentViewController.swift
//  Carol
//
//  Created by Vi Nguyen on 20/07/2022.
//

import Foundation
import UIKit

class OnboardingContentViewController: UIViewController {
    
    static func instantiate() -> OnboardingContentViewController {
        UIStoryboard(
            name: "Main",
            bundle: Bundle(for: OnboardingContentViewController.self)
        ).instantiateViewController(
            withIdentifier: String(describing: OnboardingContentViewController.self)
        ) as! OnboardingContentViewController
    }
    
    
    @IBOutlet weak var onboardImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    internal var item: OnboardingItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardImageView.image = UIImage(named: item?.image ?? "")
        titleLable.text = item?.title
        descriptionLabel.text = item?.description
    }
    
}
