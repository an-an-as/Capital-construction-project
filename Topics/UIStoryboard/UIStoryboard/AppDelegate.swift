//
//  AppDelegate.swift
//  UIStoryboard
//
//  Created by oOPiKACHUoO on 2018/11/20.
//  Copyright © 2018 oOPiKACHUoO. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        addStoryboardAndInitialComtrollerWithID()
        window?.makeKeyAndVisible()
        return true
    }
    // 故事板中有一个带箭头的视图控制器
    func addStoryboardAndInitialComtroller() {
        // UIMainStoryboardFile infoPlist 设置要加载的 Mystoryboard
        let story = UIStoryboard(name: "Mystoryboard", bundle: Bundle.main)
        let viewController = story.instantiateInitialViewController()
        window?.rootViewController = viewController
    }
    // 故事半中存在多个 视图控制器 根据StoryboardID 加载
    func addStoryboardAndInitialComtrollerWithID() {
        let board = UIStoryboard(name: "MyStoryboard001" , bundle: Bundle.main)
        let controller = board.instantiateViewController(withIdentifier: "red")
        window?.rootViewController = controller
    }
}
