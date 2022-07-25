//
//  AuthenTextField.swift
//  Carol
//
//  Created by Vi Nguyen on 21/07/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

/// The compenent text input single line with action button
public final class AuthenTextField: UIView {
    
    @IBOutlet weak var titleStackView: UIStackView!
    @IBOutlet weak var borderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var actionStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var internalTextField: InternalTextField!
    @IBOutlet weak var textFieldStack: UIStackView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var buttonStackViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var containerView: UIView!
    
    @IBOutlet weak var borderViewTopInsetConstraint: NSLayoutConstraint!
    @IBOutlet weak var borderViewRightInsetConstraint: NSLayoutConstraint!
    @IBOutlet weak var borderViewLeftInsetConstraint: NSLayoutConstraint!
    @IBOutlet weak var borderViewBottomInsetConstraint: NSLayoutConstraint!
    @IBOutlet weak var borderViewBottomSpacingConstraint: NSLayoutConstraint!
    
    private var isTextFieldVisible: Bool {
        return text.orEmpty.isNotEmpty || isEditing
    }
    /// Underlying placeholder text.
    private var _placeholder: String?
    private var cachedTextColor: UIColor?
    private let animationDuration: TimeInterval = 0.25
    
    /// Set this boolean to enable the internal textField input
    ///
    /// Default is true
    public var isInputEnabled: Bool {
        get { internalTextField.isUserInteractionEnabled }
        set { internalTextField.isUserInteractionEnabled = newValue }
    }
    
    /// The color for main view. Only visible while enabled.
    public var mainBGColor: UIColor = .clear {
        didSet { updateBorderView() }
    }
    
    /// The border color for main view. Only visible while enabled.
    public var disableBackgroundColor: UIColor? {
        didSet { updateBorderView() }
    }
    
    /// The border color for main view. Only visible while enabled.
    public var borderColor: UIColor = UIColor(rgb: 0xB8B8D2) {
        didSet { updateBorderView() }
    }
    
    private(set) var customActions: [Action] = [] {
        didSet {
            updateButtonStackVisibility()
        }
    }
    
    /// The value of text field
    ///
    /// Default value is null
    public var text: String? {
        get { internalTextField.text }
        set {
            updateText(newValue)
            updateView()
        }
    }
    
    /// Prevent new
    public var maxCharacterCount: Int? {
        didSet {
            guard let maxCount = maxCharacterCount else { return }
            text = String(text.orEmpty.prefix(maxCount))
        }
    }
    
    /// The text color of text field
    ///
    /// Default value is null
    public var textColor: UIColor? {
        get { internalTextField.textColor }
        set {
            internalTextField.textColor = newValue
        }
    }
    
    /// The closure text did change
    public var textDidChange: ((String?) -> Void)?
    
    /// The closure text did begin editing
    public var didBeginEditing: (() -> Void)?

    /// The closure text did end editing
    public var didEndEditing: (() -> Void)?

    /// The closure user did tap return key
    public var didTapReturnKey: (() -> Void)?
    
    /// The closure user tap clear text
    public var didTapClearText: ((String?) -> Void)?
    
    /// The closure help determind if should change characters in range with string
    public typealias ShouldChangeCharactersParameters = (currentString: String?, replaceRange: NSRange, replaceString: String)
    public var shouldChangeCharacters: ((ShouldChangeCharactersParameters) -> Bool)?
    
    /// The color for disable mode.
    ///
    /// Default is UIColor.lightGray.
    public var disableTextColor: UIColor = .lightGray
    
    /// The text font of text field
    ///
    /// Default value is null
    public var font: UIFont? {
        get { internalTextField.font }
        set {
            internalTextField.font = newValue
        }
    }
    
    /// The title font applied when text is empty and contol is not responder.
    ///
    /// Default value is UIFont.systemFont(ofSize: 14)
    public var titleFont: UIFont = .systemFont(ofSize: 14) {
        didSet { updateTitleFont() }
    }
    
    /// The title font applied when text is not empty or contol is responder.
    ///
    /// Default value is UIFont.systemFont(ofSize: 10)
    public var activeTitleFont: UIFont = .boldSystemFont(ofSize: 14) {
        didSet { updateTitleFont() }
    }
    
    /// UITextField clear button mode
    public var clearButtonMode: UITextField.ViewMode {
        get { internalTextField.clearButtonMode }
        set { internalTextField.clearButtonMode = newValue }
    }
    
    /// Transform text before displayed.
    private var textFormatter: Formatter?
    
    /// The boolean define if control clear the current text on disabled
    ///
    /// Default value is false
    var clearTextOnDisable: Bool = false
    
    /// The boolean enable or disable component
    /// On disable, error message will be cleared.
    ///
    /// Default value is true
    public var isEnabled: Bool = true {
        didSet {
            if oldValue { cachedTextColor = textColor }
            if clearTextOnDisable { internalTextField.text = isEnabled ? text : "" }
            errorLabel.text = isEnabled ? errorMessage : ""
            textColor = isEnabled ? cachedTextColor : disableTextColor
            isInputEnabled = isEnabled
            
            updateBorderView()
            updateView()
            invalidateIntrinsicContentSize()
        }
    }
    
    /// The title of label
    ///
    /// The Value default is nil
    public var title: String? {
        get { titleLabel.attributedText?.string }
        set {
            let att = NSAttributedString(
                string: newValue.orEmpty,
                attributes: [.font: titleFont]
            )
            titleLabel.attributedText = att
            updateTitleFont()
            titleStackView.isHidden = title.orEmpty.isEmpty
            updateView()
        }
    }
    
    /// The type of keyboard using for component
    public var keyboardType: UIKeyboardType {
        get { internalTextField.keyboardType }
        set { internalTextField.keyboardType = newValue }
    }
    
    /// The visible title of the Return key.
    public var returnKeyType: UIReturnKeyType {
        get { internalTextField.returnKeyType }
        set { internalTextField.returnKeyType = newValue }
    }
    
    /// The technique to use for aligning the text.
    public var textAlignment: NSTextAlignment {
        get { internalTextField.textAlignment }
        set {
            internalTextField.textAlignment = newValue
            updateTitleAlignment(newValue)
        }
    }
    
    private func updateTitleAlignment(_ textAlignment: NSTextAlignment) {
        switch textAlignment {
        case .left:
            titleStackView.alignment = .leading
            titleLabel.textAlignment = .left
        case .center:
            titleStackView.alignment = .center
        case .right:
            titleStackView.alignment = .trailing
            titleLabel.textAlignment = .right
        default:
            break
        }
    }
    
    /// Identifies whether the text object should disable text copying and in some cases hide the text being entered.
    public var isSecureTextEntry: Bool {
        get { internalTextField.isSecureTextEntry }
        set { internalTextField.isSecureTextEntry = newValue }
    }
    
    /// The type of Autocapitalization
    public var autocapitalizationType: UITextAutocapitalizationType {
        get { internalTextField.autocapitalizationType }
        set { internalTextField.autocapitalizationType = newValue }
    }
    
    public var atributedTitle: NSAttributedString? {
        get { titleLabel.attributedText }
        set {
            titleLabel.attributedText = newValue
            updateTitleFont()
            titleStackView.isHidden = title.orEmpty.isEmpty
            updateView()
        }
    }
    
    // MARK: Layout
    /**
     The height of component

     The Value default is .normal
     ````
     /// The height of component is 56
     case normal
     ````
     */
    public var height: Height = .normal {
        didSet {
            borderViewHeightConstraint.constant = height.value
            updateView()
            invalidateIntrinsicContentSize()
            layoutIfNeeded()
        }
    }
    
    /// The natural size for the receiving view, considering only properties of the DSTextField itself.
    override public var intrinsicContentSize: CGSize {
        let errorLabelHeight = isErrorLabelVisible ? errorLabel.intrinsicContentSize.height : 0.0
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: errorLabelHeight + height.value
        )
    }
    
    override public var inputView: UIView? {
        get { internalTextField.inputView }
        set { internalTextField.inputView = newValue }
    }
    
    /**
     The custom inputAccessoryView view to display when the DSTextField becomes the first responder.

     If the value in this property is nil, the text field displays the standard system keyboard when it becomes first responder. Assigning a custom view to this property causes that view to be presented instead. The default value of this property is nil.
     */
    public var customInputAccessoryView: UIView? {
        get { internalTextField.inputAccessoryView }
        set { internalTextField.inputAccessoryView = newValue }
    }
    
    /// The title color in compnent
    ///
    /// Default value is UIFont.lightGray
    public var titleColor: UIColor {
        get { titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }
    
    /// The placeholder font in compnent
    ///
    /// Default value is UIFont.systemFont(ofSize: 13)
    public var placeholderFont: UIFont = .systemFont(ofSize: 13) {
        didSet { updatePlaceholderText() }
    }
    
    /// The placeholder color in compnent
    ///
    /// Default value is UIFont.lightGray
    public var placeholderColor: UIColor = .lightGray {
        didSet { updatePlaceholderText() }
    }
    
    /// The hint text in compnent
    ///
    /// Default value is null
    public var placeholder: String? {
        get { _placeholder }
        set {
            _placeholder = newValue
            updatePlaceholderText()
        }
    }
    
    /// The boolean of component
    ///
    /// The state focus or editing of text field
    public var isEditing: Bool { internalTextField.isEditing }
    
    private func updatePlaceholderText() {
        let att = NSAttributedString(
            string: _placeholder.orEmpty,
            attributes: [.font: placeholderFont, .foregroundColor: placeholderColor]
        )
        internalTextField.attributedPlaceholder = att
    }
    
    private func updateView(_ animated: Bool = false) {
        updateTextFieldVisibility(animated)
        updateButtonStackVisibility()
        updateButtomStackVisibility(animated)
        updateTitleFont()
    }
    
    public weak var delegate: UITextFieldDelegate? {
        didSet {
            internalTextField?.delegate = delegate ?? self
        }
    }
    
    /// The border view insets.
    ///
    /// Default value is (5, 10, 5, 10).
    public var borderViewInsets: UIEdgeInsets = .zero {
        didSet {
            borderViewTopInsetConstraint.constant = borderViewInsets.top
            borderViewLeftInsetConstraint.constant = borderViewInsets.left
            borderViewRightInsetConstraint.constant = borderViewInsets.right
            borderViewBottomInsetConstraint.constant = borderViewInsets.bottom
        }
    }
    
    /// The border view bottom spacing.
    ///
    /// Default value is 2.
    public var borderViewBottomSpacing: CGFloat {
        get { borderViewBottomSpacingConstraint.constant }
        set { borderViewBottomSpacingConstraint.constant = newValue }
    }
    
    /// The autocorrection style for the text object.
    ///
    /// The Value default is .no
    public var autocorrectionType: UITextAutocorrectionType = .no {
        didSet { internalTextField.autocorrectionType = autocorrectionType }
    }
    
    /// Asks UIKit to make this object the first responder in its window.
    @discardableResult
    override public func becomeFirstResponder() -> Bool {
        updateTextFieldVisibility(true)
        return internalTextField.becomeFirstResponder()
    }

    /// Notifies this object that it has been asked to relinquish its status as first responder in its window.
    @discardableResult
    override public func resignFirstResponder() -> Bool {
        internalTextField.resignFirstResponder()
    }
    
    /// The feature format text input when text value change
    /// - Parameter formatter: The closure with param string and return optional string
    public func setFormatter(_ formatter: Formatter?) {
        self.textFormatter = formatter
        internalTextField.fixedAtEndCursorPosition = formatter == nil ? false : true
        updateText(text)
    }
    
    /// Updates the custom input when the object is the first responder.
    override public func reloadInputViews() {
        internalTextField.reloadInputViews()
    }
    
    /// Spacing between action buttons.
    ///
    /// Default is 2.
    public var interbuttonSpacing: CGFloat {
        get { actionStackView.spacing }
        set { actionStackView.spacing = newValue }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    public var rxTextField: Reactive<UITextField> { (internalTextField as UITextField).rx }
    
    /// Add new action to the right of the component.
    /// - Parameter action: The action data structure presenting new button's behavior.
    public func addAction(_ action: Action) {
        let button = UIButton()
        var pAction = action
        button.setImage(action.image, for: .normal)
        button.addTarget(self, action: #selector(performButtonAction(_:event:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: action.buttonHeight).isActive = true
        button.widthAnchor.constraint(equalToConstant: action.buttonWidth).isActive = true
        pAction.referenceButton = button
        
        actionStackView.addArrangedSubview(button)
        customActions.append(pAction)
    }
    
    /// Clear all added action buttons without (default) clear action one.
    public func clearCustomActions() {
        let clearButton = actionStackView.arrangedSubviews.first
        actionStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        actionStackView.addArrangedSubview(clearButton!)
    }
    
    @objc
    private func performButtonAction(_ button: UIButton, event: UIControl.Event) {
        guard let action = customActions.first(where: { $0.referenceButton === button }) else {
            return
        }
        action.handler()
    }
    
    private func configureView() {
        loadNib()
        resetView()
        layoutIfNeeded()
        invalidateIntrinsicContentSize()
        
        titleLabel.text = ""
        errorLabel.text = ""
        internalTextField.text = ""
        internalTextField.placeholder = ""
        backgroundColor = .white
        
        borderView.layer.cornerRadius = 12
        borderView.layer.borderWidth = 1
        borderView.clipsToBounds = true
        
        disableBackgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        titleColor = .lightGray
        titleFont = .systemFont(ofSize: 14)
        activeTitleFont = .boldSystemFont(ofSize: 10)
        
        borderViewInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        interbuttonSpacing = 2.0
        borderViewBottomSpacing = 2.0
        autocorrectionType = .no
        internalTextField.fixedAtEndCursorPosition = false
        internalTextField.delegate = delegate ?? self
        internalTextField.addTarget(self, action: #selector(didBeginEditingTextField(_:)), for: .editingDidBegin)
        internalTextField.addTarget(self, action: #selector(didEndEditingTextField(_:)), for: .editingDidEnd)
        internalTextField.addTarget(self, action: #selector(didValueChangedInTextField(_:)), for: .valueChanged)
        internalTextField.addTarget(self, action: #selector(edittingDidChange(_:)), for: .editingChanged)

        let tapInput = UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder))
        borderView.isUserInteractionEnabled = true
        borderView.addGestureRecognizer(tapInput)
        
        isEnabled = true
        updateView()
    }
    
    // MARK: UITextField events
    
    @objc
    private func didBeginEditingTextField(_: UITextField) {
        if text.orEmpty.isEmpty {
            updateTitleFont()
            textFieldStack.isHidden = false
            textFieldStack.alpha = 1
            UIView.animate(withDuration: animationDuration, animations: {
                self.layoutIfNeeded()
            })
        }
    }

    @objc
    private func didEndEditingTextField(_: UITextField) {
        if text.orEmpty.isEmpty {
            updateTitleFont()
            textFieldStack.isHidden = true
            textFieldStack.alpha = 0
            UIView.animate(withDuration: animationDuration) {
                self.layoutIfNeeded()
            }
        }
    }

    @objc
    private func didValueChangedInTextField(_ textField: UITextField) {
        updateView()
        textDidChange?(textField.text)
    }

    @objc
    private func edittingDidChange(_ textField: UITextField) {
        updateText(textField.text)
    }

    private func resetView() {
        titleStackView.isHidden = true
        textFieldStack.isHidden = true
        internalTextField.isHidden = false
        bottomStackView.isHidden = false
        errorLabel.isHidden = true
    }

    
    private func updateTextFieldVisibility(_ animated: Bool = false, completion: ((_ finished: Bool) -> Void)? = nil) {
        textFieldStack.isHidden = isTextFieldVisible ? false : true
        textFieldStack.alpha = CGFloat(isTextFieldVisible ? 1.0 : 0.0)
        let updateBlock = { self.layoutIfNeeded() }
        if animated {
            UIView.animate(withDuration: animationDuration,
                           animations: updateBlock,
                           completion: completion)
        } else {
            updateBlock()
            completion?(true)
        }
    }
    
    private func updateButtomStackVisibility(_ animated: Bool = false) {
        updateErrorLabelVisibility(animated, completion: nil)
        bottomStackView.isHidden = !isBottomStackVisible
    }
    
    private func updateErrorLabelVisibility(_ animated: Bool = false, completion: ((_ finished: Bool) -> Void)? = nil) {
        let alpha = CGFloat(isErrorLabelVisible ? 1.0 : 0.0)
        let isHidden = isErrorLabelVisible ? false : true
        let updateBlock = { () -> Void in
            self.errorLabel.isHidden = isHidden
            self.errorLabel.alpha = alpha
        }
        updateBlock()
        completion?(true)
    }
    
    private func updateButtonStackVisibility() {
        customActions.forEach({ action in
            action.referenceButton?.isHidden = !action.shouldVisible(self)
        })
        buttonStackViewWidthConstraint.isActive = customActions.isEmpty
    }
    
    private func updateText(_ value: String?) {
        
        var setValue = value
        let currentCursor = internalTextField.selectedTextRange
        if let formatter = textFormatter, let val = setValue {
            setValue = formatter(val)
        }
        
        if let maxCount = maxCharacterCount, let text = setValue, text.count > maxCount {
            setValue = "\(text.prefix(maxCount))"
        }
        
        /*if let cursor = textField.position(from: textField.beginningOfDocument,
                                           offset: textField.text.orEmpty.count) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.textField.selectedTextRange = self.textField.textRange(from: cursor, to: cursor)
            }
        }
        */
        
        internalTextField.text = setValue
        internalTextField.selectedTextRange = currentCursor
        internalTextField.sendActions(for: .valueChanged)
    }
    
    public func sendActions(for controlEvents: UIControl.Event) {
        internalTextField.sendActions(for: controlEvents)
    }
    
    private var isTitleActive: Bool {
        text.orEmpty.isNotEmpty || (text.orEmpty.isEmpty && isEditing)
    }
    
    private func updateTitleFont() {
        titleLabel.font = isTitleActive ? activeTitleFont : titleFont
        titleStackView.setNeedsLayout()
        titleStackView.layoutIfNeeded()
    }
    
    /// `titleStackView`'s visibility.
    /// - Returns: return if the title is being displayed.
    private func isTitleStackViewVisible() -> Bool {
        return title.orEmpty.isNotEmpty
    }
    
    private var isBottomStackVisible: Bool {
        return isErrorLabelVisible
    }
    
    private var isErrorLabelVisible: Bool {
        return errorMessage.orEmpty.isNotEmpty && isEnabled
    }
    
    public var errorTextColor: UIColor = UIColor(rgb: 0xFF6905) {
        didSet { errorLabel.textColor = errorTextColor }
    }
    
    public var errorFont: UIFont {
        get { errorLabel.font }
        set { errorLabel.font = newValue }
    }

    /// The error message when value invalid
    ///
    /// Default value is null
    public var errorMessage: String? {
        didSet {
            let errorText = isEnabled ? errorMessage : ""
            errorLabel.attributedText = NSAttributedString(
                string: errorText.orEmpty,
                attributes: [.font: errorFont, .foregroundColor: errorTextColor]
            )
            updateButtomStackVisibility()
        }
    }
    
    private func updateBorderView() {
        if isEnabled {
            borderView.isUserInteractionEnabled = true
            borderView.layer.borderColor = borderColor.cgColor
            borderView.backgroundColor = mainBGColor
        } else {
            borderView.isUserInteractionEnabled = false
            borderView.layer.borderColor = UIColor.clear.cgColor
            borderView.backgroundColor = disableBackgroundColor
        }
    }
}

fileprivate extension AuthenTextField {
    func loadNib() {
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self, options: nil)
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: containerView.topAnchor),
            self.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}

// MARK: - UITextFieldDelegate

extension AuthenTextField: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapReturnKey?()
        return internalTextField.resignFirstResponder()
    }
    
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditing?()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditing?()
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        didTapClearText?(textField.text)
        return true
    }
}
