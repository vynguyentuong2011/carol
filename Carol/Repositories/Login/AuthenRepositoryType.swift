//
//  AuthenRepositoryType.swift
//  Carol
//
//  Created by Vi Nguyen on 28/07/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol AuthenRepositoryType: AnyObject {
    func signup(email: String, password: String, completionHandler: SignUpCompletionHandler?)
}

class AuthenRepository: AuthenRepositoryType {
    
    // MARK: - Properties
    private let service: AuthenServiceType
    
    init(service: AuthenServiceType = AuthenService()) {
        self.service = service
    }
    
    func signup(email: String, password: String, completionHandler: SignUpCompletionHandler?) {
        self.service.signup(email: email, password: password, completionHandler: completionHandler)
    }
}
