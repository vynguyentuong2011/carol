//
//  CRConfigRepository.swift
//  Carol
//
//  Created by Vi Nguyen on 20/07/2022.
//

import Foundation
import RxSwift

protocol CRConfigRepositoryType: AnyObject {
    func getOnboardingConfig() -> Observable<[OnboardingItem]>
}

class CRConfigRepository: CRConfigRepositoryType {
    
    // MARK: - Properties
    private let configService: CRConfigServiceType
    
    
    init(configService: CRConfigServiceType = CRConfigService()) {
        self.configService = configService
    }
    
    func getOnboardingConfig() -> Observable<[OnboardingItem]> {
        return configService.getOnboardingConfig()
    }
}


