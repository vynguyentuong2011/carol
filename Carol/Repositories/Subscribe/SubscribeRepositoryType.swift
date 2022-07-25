//
//  SubscribeRepositoryType.swift
//  Carol
//
//  Created by Vi Nguyen on 25/07/2022.
//

import Foundation
import RxSwift

protocol SubscribeRepositoryType: AnyObject {
    func getSubscribeItems() -> Observable<[SubscribeModel]>
}

class SubscribeRepository: SubscribeRepositoryType {
    // MARK: - Properties
    private let service: SubscribeServiceType
    
    init(service: SubscribeServiceType = SubscribeService()) {
        self.service = service
    }
    
    func getSubscribeItems() -> Observable<[SubscribeModel]> {
        return self.service.getSubscribeItems()
    }
}
