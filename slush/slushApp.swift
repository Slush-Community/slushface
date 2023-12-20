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
            .stroke(Color.white, lineWidth: 5)
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
                ZStack {
                    // Match the background color to the Figma design
                    Color.orange.ignoresSafeArea()

                    // Create a white circular progress indicator
                    Circle()
                        .strokeBorder(Color.white.opacity(0), lineWidth: 4)
                        .frame(width: 120, height: 120)

                    // Add the dollar sign image in white
                    Image("SLogoNoBack")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    // Assuming CircleProgress is a custom view that you want to use for the actual progress
                    CircleProgress(progress: progress)
                        .frame(width: 120, height: 120)
                }
                .onAppear {
                    // Timer to increment progress
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



