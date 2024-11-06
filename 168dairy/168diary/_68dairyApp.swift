//
//  _68dairyApp.swift
//  168dairy
//
//  Created by Jabin on 2024/11/5.
//

import SwiftUI
import UserNotifications



@main
struct _68dairyApp: App {
    
    init(){
        requestNotificationAuthorization() //请求用户通知
        }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    // 定义通知授权请求函数
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("用户授权成功")
            } else {
                print("用户授权失败")
            }
        }
    }
}
