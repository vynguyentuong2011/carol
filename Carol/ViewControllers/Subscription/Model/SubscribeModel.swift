//
//  SubscribeModel.swift
//  Carol
//
//  Created by Vi Nguyen on 25/07/2022.
//

import Foundation

class SubscribeModel {
    var title: String?
    var descHead: String?
    var descBody: String?
    
    init(title: String?, descHead: String?, descBody: String?) {
        self.title = title
        self.descHead = descHead
        self.descBody = descBody
    }
}
