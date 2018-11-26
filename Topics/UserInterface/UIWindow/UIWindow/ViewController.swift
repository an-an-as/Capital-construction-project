//
//  ViewController.swift
//  UIWindow
//
//  Created by oOPiKACHUoO on 2018/11/20.
//  Copyright © 2018 oOPiKACHUoO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        window.backgroundColor = .red
        view.addSubview(window)
        window.isHidden = false
        // 必须要根控制器
        UIApplication.shared.keyWindow
        UIApplication.shared.windows.last
    }
}

