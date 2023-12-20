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

                    Button(action: {
                        // Implement your Google Sign-In logic here
                    }) {
                        HStack {
                            Image(systemName: "globe") // Use a Google logo if you have one
                            Text("Sign in with Google")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    // Apple Sign In Button
                    SignInWithAppleButton(.signIn) { request in
                        // Handle the Apple Sign-In request
                    } onCompletion: { result in
                        // Handle the Apple Sign-In result
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 50)
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Spacer()
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
