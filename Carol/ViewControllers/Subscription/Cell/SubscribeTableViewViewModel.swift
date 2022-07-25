//
//  SubscribeTableViewViewModel.swift
//  Carol
//
//  Created by Vi Nguyen on 25/07/2022.
//

import RxSwift
import RxRelay
import UIKit

class SubscribeTableViewViewModel {
    
    var identity = ""
    let isSelected = BehaviorRelay<Bool>(value: false)
    let subscribeItem = BehaviorRelay<SubscribeModel?>(value: nil)
    
    init(item: SubscribeModel) {
        self.subscribeItem.accept(item)
    }
    
}
