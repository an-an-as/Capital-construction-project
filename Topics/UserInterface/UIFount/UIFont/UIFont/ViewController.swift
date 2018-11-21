//
//  ViewController.swift
//  UIFont
//
//  Created by oOPiKACHUoO on 2018/11/20.
//  Copyright © 2018 oOPiKACHUoO. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        testPreferredFontStyle()
        testPreferredFontNotification()
    }
    /// 字体设置
    func testPreferredFontStyle() {
        addFontStyle(.largeTitle)
        addFontStyle(.title1)
        addFontStyle(.title2)
        addFontStyle(.title3)
        addFontStyle(.headline)
        addFontStyle(.subheadline)
        addFontStyle(.body)
        addFontStyle(.callout)
        addFontStyle(.caption1)
        addFontStyle(.caption2)
        addFontStyle(.footnote)
    }
    func addFontStyle(_ style: UIFont.TextStyle) {
        let lable = UILabel(frame: CGRect(x: 5, y: 80 + index * 40  , width: 400, height: 25))
        lable.text = String(style.rawValue)
        lable.font = UIFont.preferredFont(forTextStyle: style)
        view.addSubview(lable)
        index += 1
    }
    /// 适配系统字体(通用-辅助-字体)
    func testPreferredFontNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(resetLableStyle(notification:)), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    // ios10* lable.adjustsFontForContentSizeCategory = true
    @objc func resetLableStyle(notification: Notification) {
        view.subviews.forEach {
            if $0 is UILabel {
                let lable = $0 as! UILabel
                let style = lable.font.fontDescriptor.object(forKey: UIFontDescriptor.AttributeName.textStyle) as! String
                lable.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle(rawValue: style))
            }
        }
    }
}
