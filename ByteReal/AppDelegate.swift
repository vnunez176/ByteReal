//
//  AppDelegate.swift
//  ByteReal
//
//  Created by Keerthi Pelluru on 10/10/24.
//
import SwiftUI
import UserNotifications
import ParseSwift

class AppDelegate: NSObject, UIApplicationDelegate {
    
    @Published var navigateToHome = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
       
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
        
        sendDailyNotification()
        ParseSwift.initialize(applicationId: "LLljWJoLMXtRvieB5IZAODCGGOoYNDjotzqYm5xW",
                              clientKey: "YpCHLkbnTd5eXzW2Tam2QlC9efbm6xPK4di5JLSV",
                              serverURL: URL(string: "https://parseapi.back4app.com")!)

        return true
    }
    

    func sendDailyNotification(){
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "ByteReal Time!"
        notificationContent.body = "Daily coding post!!"
        notificationContent.sound = UNNotificationSound.default
        
        // Set the notification time to 6 PM
        var dateComponents = DateComponents()
        
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
    
    // Handle notification tap
       func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
           print("Notification tapped")
           
           // Trigger navigation to the home screen
           DispatchQueue.main.async {
               self.navigateToHome = true
           }
        
           completionHandler()
       }
    
    
    
    
    // Show the notification even when the app is in the foreground
       func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           completionHandler([.banner, .sound])
       }

    
    
    
}










