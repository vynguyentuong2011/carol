//
//  ChangePasswordSuccessViewController.swift
//  Carol
//
//  Created by Vi Nguyen on 23/07/2022.
//

import UIKit
import RxSwift

class ChangePasswordSuccessViewController: BaseViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var descLabel: UILabel!
    
    var desc: String = ""
    
    static func instantiate() -> ChangePasswordSuccessViewController {
        UIStoryboard(
            name: "Authenticate",
            bundle: Bundle(for: ChangePasswordSuccessViewController.self)
        ).instantiateViewController(
            withIdentifier: String(describing: ChangePasswordSuccessViewController.self)
        ) as! ChangePasswordSuccessViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setupUI() {
        loginButton.backgroundColor = UIColor(rgb: 0x3D5CFF)
        loginButton.layer.cornerRadius = 12
        loginButton.titleLabel?.attributedText = LoginViewController.loginAttributedTitle(title: "Log in")
        self.descLabel.text = desc
    }
    
    private func configureAction() {
        loginButton.rx.tap
            .subscribeNext { [weak self] in
                guard let self = self else { return }
                LoginManager.shared.presentSignInViewController(viewController: self, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}
