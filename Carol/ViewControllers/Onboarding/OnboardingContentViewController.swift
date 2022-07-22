//
//  OnboardingContentViewController.swift
//  Carol
//
//  Created by Vi Nguyen on 20/07/2022.
//

import Foundation
import UIKit
import RxSwift

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
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    internal var item: OnboardingItem?
    var isLastItem: Bool = false
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    private func setupUI() {
        signUpButton.isHidden = !isLastItem
        loginButton.isHidden = !isLastItem
        
        onboardImageView.image = UIImage(named: item?.image ?? "")
        titleLable.text = item?.title
        descriptionLabel.text = item?.description
        
        signUpButton.backgroundColor = UIColor(rgb: 0x3D5CFF)
        signUpButton.titleLabel?.attributedText = attSetupTitle
        signUpButton.layer.cornerRadius = 12
        signUpButton.sizeToFit()
        loginButton.backgroundColor = UIColor.white
        loginButton.titleLabel?.attributedText = attLoginTitle
        loginButton.layer.cornerRadius = 12
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor(rgb: 0x3D5CFF).cgColor
        loginButton.sizeToFit()
    }
    
    private func configureActions() {
        loginButton.rx.tap
            .subscribeNext { _ in
                if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
                    LoginManager.shared
                        .presentSignInViewController(viewController: rootVC, completion: nil)
                }
            }
            .disposed(by: bag)
    }
    
    private var attSetupTitle: NSAttributedString {
        let att = NSMutableAttributedString.init()
        att.append(NSAttributedString.init(string: "Sign up", attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 16)
        ]))
        return att
    }
    
    private var attLoginTitle: NSAttributedString {
        let att = NSMutableAttributedString.init()
        att.append(NSAttributedString.init(string: "Log in", attributes: [
            .foregroundColor: UIColor(rgb: 0x3D5CFF),
            .font: UIFont.systemFont(ofSize: 16)
        ]))
        return att
    }
}
