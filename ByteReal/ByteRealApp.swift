//
//  ByteRealApp.swift
//  ByteReal
//
//  Created by Victoria Nunez on 10/9/24.
//

import SwiftUI
import ParseSwift

@main
struct ByteRealApp: App {
    init() {
        // Connecting AppDelegate with SwiftUI
        @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
        let serverConfigUrl = URL(filePath: "https://parseapi.back4app.com")
//        ParseConfiguration(applicationId: "LLljWJoLMXtRvieB5IZAODCGGOoYNDjotzqYm5xW", clientKey: "YpCHLkbnTd5eXzW2Tam2QlC9efbm6xPK4di5JLS", serverURL: serverConfigUrl)
//        
        ParseSwift.initialize(applicationId: "LLljWJoLMXtRvieB5IZAODCGGOoYNDjotzqYm5xW",
                                      clientKey: "YpCHLkbnTd5eXzW2Tam2QlC9efbm6xPK4di5JLS",
                                      serverURL: URL(string: "https://parseapi.back4app.com")!)
        print("Parse initialized: \(ParseSwift.configuration)")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
