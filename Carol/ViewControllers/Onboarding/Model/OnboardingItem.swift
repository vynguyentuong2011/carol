//
//  OnboardingItem.swift
//  Carol
//
//  Created by Vi Nguyen on 20/07/2022.
//

import Foundation

class OnboardingItem {
    var title: String?
    var image: String?
    var description: String?
    var index: Int
    
    init(title: String?, image: String?, description: String?, index: Int) {
        self.title = title
        self.image = image
        self.description = description
        self.index = index
    }
}
