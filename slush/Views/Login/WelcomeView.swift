//
//  WelcomeView.swift
//  slush
//
//  Created by Aidan Lynde on 12/20/23.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var userViewModel: UserViewModel
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                Text("Welcome to Slush!")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // You can add more content here such as an image or additional text

                Spacer()
                
                NavigationLink(destination: ProfileSetupView(userViewModel: userViewModel)) {
                    Text("Get Started")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                NavigationLink(destination: LoginView(userViewModel: userViewModel)) {
                    Text("I already have an account")
                        .foregroundColor(Color.orange) // Orange text
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white) // White button background
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Rounded rectangle for the border
                                .stroke(Color.orange, lineWidth: 2) // Orange border
                        )
                }

                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
    }
}
