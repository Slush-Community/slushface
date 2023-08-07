//
//  slushApp.swift
//  slush
//
//  Created by Kareem Benaissa on 7/4/23.
//

import SwiftUI

@main
struct slushApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State private var isAuthenticated: Bool = false

    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                HomeView()
            } else {
                LoginView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}
