//
//  ContentView.swift
//  ByteReal
//
//  Created by Victoria Nunez on 10/9/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        if isLoggedIn {
            HomeView()
        } else {
           // LoginView(isLoggedIn: $isLoggedIn)
            HomeView()
        }
    }
}

#Preview {
    ContentView()
}
