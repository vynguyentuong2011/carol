//
//  String+Extension.swift
//  Carol
//
//  Created by Vi Nguyen on 21/07/2022.
//

import Foundation

extension Swift.Optional where Wrapped == String {

    var orEmpty: String {
        if case .some(let str) = self {
            return str
        }
        return ""
    }
}

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}
