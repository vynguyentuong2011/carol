//
//  MainNavigationController.swift
//  Carol
//
//  Created by Vi Nguyen on 21/07/2022.
//

import UIKit

open class MainNavigationController: UINavigationController {
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.modalPresentationStyle = .fullScreen
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .fullScreen
    }
    
    open func setupElements() {
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = .black
        self.navigationBar.backgroundColor = .white
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            appearance.backgroundColor = UIColor.white
            self.navigationBar.standardAppearance = appearance
            self.navigationBar.scrollEdgeAppearance = appearance
            self.navigationBar.tintColor = .black
            self.navigationBar.isTranslucent = false
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setupElements()
    }
}
