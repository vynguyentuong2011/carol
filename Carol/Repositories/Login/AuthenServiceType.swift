//
//  AuthenServiceType.swift
//  Carol
//
//  Created by Vi Nguyen on 28/07/2022.
//

import Foundation
import RxSwift
import RxRelay
import FirebaseAuth

typealias SignUpCompletionHandler = (_ result: Swift.Result<Any, Error>) -> Void

protocol AuthenServiceType {
    func signup(email: String, password: String, completionHandler: SignUpCompletionHandler?)
}

class AuthenService: AuthenServiceType {
    var completion: SignUpCompletionHandler?
    
    func signup(email: String, password: String, completionHandler: SignUpCompletionHandler?) {
        self.completion = completionHandler
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let result = result {
                self.completion?(.success(result))
            } else if let error = error {
                self.completion?(.failure(error))
            }
        }
    }
}
