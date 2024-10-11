//
//  AppDelegate.swift
//  ByteReal
//
//  Created by Keerthi Pelluru on 10/10/24.
//
import SwiftUI
import UserNotifications


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        //asks user for notification permission only first time when app is launced
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
        
        sendDailyNotification() // Schedule the 6 PM notification
    
        return true
    }
    
    //function to schedule notification at 6pm everyday
    func sendDailyNotification(){
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "ByteReal Time!"
        notificationContent.body = "Daily coding post!!"
        notificationContent.sound = UNNotificationSound.default
        
        // Set the notification time to 6 PM
        var dateComponents = DateComponents()
        dateComponents.hour = 2
        dateComponents.minute = 0
        
        // Create a trigger for every day at 6 PM
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
               
        // Create the notification request
        let request = UNNotificationRequest(identifier: "daily6PMNotification", content: notificationContent, trigger: trigger)
               
        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                    print("Error scheduling notification: \(error)")
                } else {
                    print("Daily notification scheduled at 6 PM")
                   }
               }
        
        
    }
    
    // Show the notification even when the app is in the foreground
       func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           completionHandler([.banner, .sound])
       }

    
    
    
}










