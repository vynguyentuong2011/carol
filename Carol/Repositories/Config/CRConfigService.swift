//
//  CRConfigServiceType.swift
//  Carol
//
//  Created by Vi Nguyen on 20/07/2022.
//

import Foundation
import RxSwift

protocol CRConfigServiceType {
    func getOnboardingConfig() -> Observable<[OnboardingItem]>
}

class CRConfigService: CRConfigServiceType {
    
    // TODO
    func getOnboardingConfig() -> Observable<[OnboardingItem]> {
        return Observable<[OnboardingItem]>.just([
            OnboardingItem(title: "Schedule your working time", image: "illustration", description: "Free courses for you to find your way to learning", index: 0),
            OnboardingItem(title: "Schedule your working time", image: "illustration2", description: "Free courses for you to find your way to learning", index: 1),
            OnboardingItem(title: "Schedule your working time", image: "illustration3", description: "Free courses for you to find your way to learning", index: 2)
        ])
    }
}
