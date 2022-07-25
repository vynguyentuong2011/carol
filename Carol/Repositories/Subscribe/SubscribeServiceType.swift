//
//  SubscribeServiceType.swift
//  Carol
//
//  Created by Vi Nguyen on 25/07/2022.
//

import Foundation
import RxSwift
import RxRelay

protocol SubscribeServiceType {
    func getSubscribeItems() -> Observable<[SubscribeModel]>
}

class SubscribeService: SubscribeServiceType {
    func getSubscribeItems() -> Observable<[SubscribeModel]> {
        return Observable<[SubscribeModel]>.just([
            SubscribeModel(title: "Premier",
                           descHead: "Peace of mind",
                           descBody: "Chill out and drive happy with the maximum coverage plan."),
            SubscribeModel(title: "Standard",
                           descHead: "Dependable",
                           descBody: "Hit the road confidently with solid protection."),
            SubscribeModel(title: "Minimum",
                           descHead: "Cost-effective",
                           descBody: "Stay covered while punching some pennies.")
        ])
    }
}
