//
//  ViewController.swift
//  AutoLayout
//
//  Created by oOPiKACHUoO on 2018/11/20.
//  Copyright © 2018 oOPiKACHUoO. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let redView = UIView()
        redView.backgroundColor = .red
        self.view .addSubview(redView)
        /**
         constraintWithItem 第一个视图 self.redView
         attribute          属性      NSLayoutAttributeLeft
         relatedBy          关系      NSLayoutRelationEqual
         toItem             第二个视图 self.view
         attribute          属性      NSLayoutAttributeLeft
         multiplier:        乘数      1.0f
         constant           常数      0.0f
         */
        redView.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint(item: redView, attribute: .height,
                           relatedBy: .equal, toItem: view,
                           attribute: .height, multiplier: 0.5, constant: 0)
        let weight = NSLayoutConstraint(item: redView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: 0)
        let centerX = NSLayoutConstraint(item: redView, attribute: .centerX,
                           relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: redView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        view .addConstraints([height, weight, centerX, centerY])
        

        UIView.animate(withDuration: 5) {
            self.view.constraints.forEach {
                if $0.firstAttribute == NSLayoutConstraint.Attribute.width {
                    $0.constant = 200
                }
            }
            self.view.layoutIfNeeded()
        }
    }
}
