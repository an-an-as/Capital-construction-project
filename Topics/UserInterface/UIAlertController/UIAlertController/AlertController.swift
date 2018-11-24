//
//  AlertController.swift
//  UIAlertController
//
//  Created by oOPiKACHUoO on 2018/11/21.
//  Copyright © 2018 oOPiKACHUoO. All rights reserved.
//

import UIKit
final class AlertController: UIViewController {
    
}
extension AlertController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let alert = UIAlertController(title: "底部警告", message: "超过三个按钮了", preferredStyle: .actionSheet)
        let cancle = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let delete = UIAlertAction(title: "删除", style: .destructive, handler: nil)
        let enter = UIAlertAction(title: "确认", style: .default, handler: nil)
        alert.addAction(cancle)
        alert.addAction(delete)
        alert.addAction(enter)
        alert.preferredAction = enter
        self.present(alert, animated: true, completion: nil)
    }
}
