//
//  AuthenTextFieldState.swift
//  Carol
//
//  Created by Vi Nguyen on 22/07/2022.
//

import Foundation

public enum AuthenTextFieldState: Equatable {
    case idle
    case active
    case error(_ msg: String)
    
    public static func == (lhs: AuthenTextFieldState, rhs: AuthenTextFieldState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.active, .active):
            return true
        case (.error(let e1), .error(let e2)):
            return e1 == e2
        default:
            return false
        }
    }
    
    var isError: Bool {
        switch self {
        case .error(_): return true
        default: return false
        }
    }
    
    var isFocusing: Bool {
        switch self {
        case .active: return true
        default: return false
        }
    }
    
    var name: String {
        switch self {
        case .idle: return "idle"
        case .active: return "active"
        case .error(let msg): return "error \(msg)"
        }
    }
}
