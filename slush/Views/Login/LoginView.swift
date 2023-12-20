//
//  LoginView.swift
//  slush
//
//  Created by Kareem Benaissa on 8/5/23.
//
// TODO: Add email verification
import SwiftUI
import AuthenticationServices // For Apple Sign In

struct LoginView: View {
    @ObservedObject var userViewModel: UserViewModel

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var chosenImage: UIImage?
    @State private var showProfileSetup: Bool = false

    @State private var isLoading: Bool = false

    var body: some View {
        NavigationView {
            ZStack {
                // Match the background color to the Figma design
                Color.white.ignoresSafeArea()

                VStack(spacing: 20) {
                    // Replace 'Image(systemName: "dollarsign.circle")' with the logo from your assets if needed
                    Image("SLogoNoBack")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.orange)
                    
                    // Update the TextFields to match the design
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                    
                    Button(action: {
                        isLoading = true
                        userViewModel.login(username: username, password: password)
                        isLoading = false
                    }) {
                        Text("Log In")
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()

                    // Replace this with your actual sign-in buttons, styled according to your design
                    // ...

                    Spacer()
                    
                    // Update the Sign-up button to match the design
                    NavigationLink(destination: ProfileSetupView(userViewModel: userViewModel)) {
                        Text("Sign-up")
                            .font(.headline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                }
                .padding()
                .blur(radius: isLoading ? 5 : 0)

                // Update the loading spinner to match the design
                if isLoading {
                    ProgressView() // Loading spinner
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(2, anchor: .center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.orange.opacity(0.8).ignoresSafeArea())
                }
            }
        }
    }
}
