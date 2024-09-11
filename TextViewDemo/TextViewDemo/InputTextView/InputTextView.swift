//
//  InputTextView.swift
//  TextViewDemo
//
//  Created by ziven on 2024/9/12.
//

import UIKit
import CoreText

enum InputTextViewShowState {
    case showDefault
    case showEditing
    case showError
}


class InputTextView: UIView, UITextViewDelegate {
    
    var viewState = InputTextViewShowState.showDefault
    var isVoiceOverEnabled: Bool {
        return UIAccessibility.isVoiceOverRunning
    }
    
    var mainStackView = {
        let stack = UIStackView(frame: .zero)
        stack.spacing = 20
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var titleLabel = {
        let label = UILabel()
        label.text = "Title string"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var textViewHeightConstraint: NSLayoutConstraint!
    var textView = {
        let textView = UITextView()
        textView.backgroundColor = .yellow
        textView.textColor = .black
        textView.font = UIFont.systemFont(ofSize: 19)
        textView.textContainer.maximumNumberOfLines = 2 // 限制最多2行文本
        textView.textContainer.lineBreakMode = .byTruncatingTail // 超过部分显示省略号
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var errorStackView = {
        let stack = UIStackView(frame: .zero)
        stack.spacing = 12
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var errorIcon = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "drop.triangle.fill")
        icon.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        icon.tintColor = .red
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    var errorLabel = {
        let label = UILabel()
        label.text = "This is a error string......"
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        applySubviews()
        subviewsAddConstraint()
        setupSubviews()
        accessibilitySetting()
        changeAccessibilityLabelString()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applySubviews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(textView)
        
        mainStackView.addArrangedSubview(errorStackView)
        errorStackView.addArrangedSubview(errorIcon)
        errorStackView.addArrangedSubview(errorLabel)
    }
    
    
    func subviewsAddConstraint() {
        addConstraint(NSLayoutConstraint(item: mainStackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 12))
        addConstraint(NSLayoutConstraint(item: mainStackView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 12))
        addConstraint(NSLayoutConstraint(item: mainStackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -12))
        addConstraint(NSLayoutConstraint(item: mainStackView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -12))
        
        textViewHeightConstraint = NSLayoutConstraint(item: textView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 39)
        mainStackView.addConstraint(textViewHeightConstraint)
        
        errorStackView.addConstraint(NSLayoutConstraint(item: errorIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        errorStackView.addConstraint(NSLayoutConstraint(item: errorIcon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
    }
    
    func setupSubviews() {
        textView.addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: nil)
        textView.delegate = self
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "contentSize" {
                let contentSize:CGSize = change?[.newKey] as? CGSize ?? CGSize(width: 0, height: 39)
                let height = contentSize.height > 39 ? contentSize.height : 39
                textViewHeightConstraint.constant = height
                self.layoutIfNeeded()
            }
    }
    
    deinit {
        removeObserver(self, forKeyPath: "contentSize")
    }
    
    func accessibilitySetting() {
        /* 旁白读出的顺序
         •    accessibilityLabel -- 主要的属性，它提供一个简短的描述，告诉用户这个视图的作用
         •    accessibilityHint  -- 为视图提供额外的提示信息，告诉用户该视图的功能或操作结果
         •    accessibilityValue -- 表示控件的当前状态或值。适用于滑块、进度条、开关等
         •    accessibilityTraits -- 定义视图的行为和类型（例如是否是按钮、搜索框等）
         */
//        self.isAccessibilityElement = true
//        textView.shouldGroupAccessibilityChildren = true
//        self.accessibilityTraits = .searchField
        titleLabel.isAccessibilityElement = false
//        textView.isAccessibilityElement = false
//        textView.shouldGroupAccessibilityChildren = false
        errorIcon.isAccessibilityElement = false
        errorLabel.isAccessibilityElement = false
    }
    
    func changeAccessibilityLabelString() {
        
        switch viewState {
        case .showDefault:
            var string = ""
            if let input = textView.text {
                string = "\n" + input
            }
            self.accessibilityLabel = (titleLabel.text ?? "") + string
        case.showEditing:
            self.accessibilityLabel = (titleLabel.text ?? "") + (textView.text ?? "")
        case .showError:
            self.accessibilityLabel = "Input View Error" + (titleLabel.text ?? "") + (textView.text ?? "")
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        changeAccessibilityLabelString()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if isVoiceOverEnabled {
            moveCursorToEnd(textView: textView)
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isVoiceOverEnabled {
            moveCursorToEnd(textView: textView)
        }
    }
    
    // 监听输入内容
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if isVoiceOverEnabled {
            moveCursorToEnd(textView: textView)
        }
        return true
    }
    
    // 移动光标到文本末尾
    func moveCursorToEnd(textView: UITextView) {
        // 更新文本后，光标移动到特定位置
        DispatchQueue.main.async {
            let endPosition = textView.endOfDocument // 获取文档末尾的 UITextPosition
            textView.selectedTextRange = textView.textRange(from: endPosition, to: endPosition) // 设置光标位置到文本末尾
        }
    }
}
