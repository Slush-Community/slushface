//
//  slushApp.swift
//  slush
//
//  Created by Kareem Benaissa on 7/4/23.
//

import SwiftUI

struct CircleProgress: View {
    var progress: Double
    var body: some View {
        Circle()
            .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
            .stroke(Color.black, lineWidth: 5)
            .rotationEffect(Angle(degrees: 270.0))
    }
}

@main
struct SlushApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var userViewModel = UserViewModel()
    @State private var isLoading = true
    @State private var progress = 0.0

    var body: some Scene {
        WindowGroup {
            if isLoading {
                VStack {
                    ZStack {
                        Image(systemName: "dollarsign.circle")
                            .resizable()
                            .frame(width: 120, height: 120)
                            .foregroundColor(Color.green)
                        
                        CircleProgress(progress: progress)
                            .frame(width: 120, height: 120)
                    }
                }
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                        if progress < 1.0 {
                            withAnimation {
                                progress += 0.05
                            }
                        } else {
                            timer.invalidate()
                            isLoading = false
                        }
                    }
                }
            } else if userViewModel.isAuthenticated {
                if userViewModel.isProfileSetupRequired {
                    ProfileSetupView(userViewModel: userViewModel)
                        .transition(.opacity)
                } else {
                    HomeView(userViewModel: userViewModel)
                        .transition(.opacity)
                }
            } else {
                LoginView(userViewModel: userViewModel)
            }
        }
    }
}



