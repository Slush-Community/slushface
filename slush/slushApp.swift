//
//  slushApp.swift
//  slush
//
//  Created by Kareem Benaissa on 7/4/23.
//

import SwiftUI

@main
struct SlushApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var userViewModel = UserViewModel() // Global ViewModel instance

    var body: some Scene {
        WindowGroup {
            if userViewModel.isAuthenticated {
                HomeView(userViewModel: userViewModel)
            } else {
                LoginView()
            }
        }
    }
}
