//
//  NotificationManager.swift
//  168dairy
//
//  Created by Jabin on 2024/11/6.
//

import UserNotifications

func sendEndOfEatingNotification() {
    let content = UNMutableNotificationContent()
    content.title = "进食时间结束"
    content.body = "您的进食时间已结束，请停止进食。"
    content.sound = UNNotificationSound.default
    
    // 设置触发器，立即发送通知
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    
    // 创建通知请求
    let request = UNNotificationRequest(identifier: "EndOfEatingNotification", content: content, trigger: trigger)
    
    // 将通知请求添加到通知中心
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("添加通知请求失败：\(error.localizedDescription)")
        } else {
            print("通知已成功发送")
        }
    }
}
