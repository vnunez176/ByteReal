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
    // Connecting AppDelegate with SwiftUI
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isHomeViewActive = false
    @State private var isLoggedIn = false
    init() {
    

    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(appDelegate.$navigateToHome) { navigateToHome in
                                      if navigateToHome {
                                          isHomeViewActive = true 
                                      }
                                  }
                                  .background(
                                      NavigationLink(destination: HomeView(isLoggedIn: $isLoggedIn), isActive: $isHomeViewActive) {
                                          EmptyView()
                                      }
                                      )
        }
    }
}
