//
//  AuthenTextField+Types.swift
//  Carol
//
//  Created by Vi Nguyen on 21/07/2022.
//

import Foundation

import UIKit

// MARK: - Helper types

extension AuthenTextField {
        
    public typealias Formatter = ((String) -> String?)
    public typealias AttributedFormatter = ((NSAttributedString) -> NSAttributedString?)

    /// The mode height of border component
    public enum Height {

        /// The height of component is 48
        case normal
        case custom(_ value: CGFloat)
        
        var value: CGFloat {
            switch self {
            case .normal: return 48.0
            case .custom(let value):
                return value
            }
        }
    }
    
    /// The structure ui and event of action
    public struct Action {
        var image: UIImage
        var handler: () -> Void
        var shouldVisible: (_ textField: AuthenTextField) -> Bool
        weak var referenceButton: UIButton?
        
        var buttonWidth: CGFloat = 12
        var buttonHeight: CGFloat = 12
        
        public init(
            image: UIImage,
            handler: @escaping (() -> Void),
            shouldVisible: @escaping ((_ textField: AuthenTextField) -> Bool) = { _ in true }
        ) {
            self.image = image
            self.handler = handler
            self.shouldVisible = shouldVisible
        }
    }
}

final class InternalTextField: UITextField {

    var fixedAtEndCursorPosition: Bool = false

    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        fixedAtEndCursorPosition ? endOfDocument : super.closestPosition(to: point)
    }
}
