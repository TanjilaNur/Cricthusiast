//
//  NotificationHandler.swift
//  Cricthusiast
//
//  Created by Tanjila Nur on 2/24/23.
//

import Foundation
import UserNotifications

struct LocalNotificationModel {
    let id: String
    let title: String
    let subtitle: String
    let notificationTime: String
}

class NotificationHandler {
    static func getAllPendingNotification(completion: @escaping([LocalNotificationModel]) -> ()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            var pendingNotificationList: [LocalNotificationModel] = []
            for request in requests {
                var date = ""
                if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger {
                    let triggerDate = Date(timeIntervalSinceNow: trigger.timeInterval)
                    date = convertToDateAndTime(date: triggerDate)
                    
                }
                let notificationModel = LocalNotificationModel(id: request.identifier, title: request.content.title, subtitle: request.content.subtitle, notificationTime: date)
                pendingNotificationList.append(notificationModel)
            }
            completion(pendingNotificationList)
        }
    }
    
    static func pushToLocalNotification(model: LocalNotificationModel) {
        let content = UNMutableNotificationContent()
        content.title = model.title
        content.subtitle = model.subtitle
        content.sound = .default
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let time = formatter.date(from: model.notificationTime) else { return }
        
        let beforeTime = -15 * 60.0
                
        let notificationTime = time.addingTimeInterval(beforeTime)
        let timeInterval = notificationTime.timeIntervalSince(Date())
        
        if (timeInterval > 0) {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: model.id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    static func showUpcomingNotification(completion: @escaping([LocalNotificationModel]) -> ()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            var upcomingNotificationList: [LocalNotificationModel] = []
            for request in requests {
                let notificationModel = LocalNotificationModel(id: request.identifier, title: request.content.title, subtitle: request.content.subtitle, notificationTime: "")
                upcomingNotificationList.append(notificationModel)
            }
            completion(upcomingNotificationList)
        }
    }
}



