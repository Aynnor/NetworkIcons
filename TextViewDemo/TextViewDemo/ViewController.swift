//
//  ViewController.swift
//  TextViewDemo
//
//  Created by ziven on 2024/9/11.
//

import UIKit

class ViewController: UIViewController {

    lazy var inputTextView = {
        let inputView = InputTextView(frame: .zero)
        inputView.translatesAutoresizingMaskIntoConstraints = false
        return inputView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addInputView()
    }
    
    func addInputView() {
        view.addSubview(inputTextView)
        view.addConstraint(NSLayoutConstraint(item: inputTextView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 150))
        view.addConstraint(NSLayoutConstraint(item: inputTextView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: inputTextView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: inputTextView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 120))
    }
    
    


}

