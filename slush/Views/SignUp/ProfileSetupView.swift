////
//  ProfileSetupView.swift
//  slush
//
//  Created by Aidan Lynde on 10/19/23.
//

import SwiftUI
import AuthenticationServices

// MARK: Sign up step 1

struct SignUpStep1View: View {
    @ObservedObject var userViewModel: UserViewModel
    @Binding var fullname: String
    @Binding var birthdate: Date
    @Binding var email: String
    @Binding var password: String
    @State private var showLoginView = false
    var onNext: () -> Void
    var onSignIn: () -> Void // Handler for "Already have an account"
    var onGoogleSignIn: () -> Void // Handler for "Continue with Google"
    var onAppleSignIn: () -> Void // Handler for "Continue with Apple"

    let primaryColor = Color.orange
    let secondaryColor = Color.white
    let inputBackgroundColor = Color(UIColor.systemGray6)
    let inputCornerRadius: CGFloat = 10
    let buttonHeight: CGFloat = 50
    let shadowRadius: CGFloat = 3

    var body: some View {
        VStack(spacing: 15) {
            Text("Create Your Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(primaryColor)

            VStack(spacing: 10) {
                CustomTextField(placeholder: "Full Name", text: $fullname)
                CustomDatePicker(placeholder: "Birth Date", date: $birthdate)
                CustomTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                CustomSecureField(placeholder: "Password", text: $password)
            }
            .padding(.horizontal)

            Button(action: onNext) {
                Text("Next")
                    .fontWeight(.semibold)
                    .foregroundColor(secondaryColor)
                    .frame(height: buttonHeight)
                    .frame(maxWidth: .infinity)
                    .background(fullname.isEmpty || email.isEmpty || password.isEmpty ? Color.gray : primaryColor)
                    .cornerRadius(inputCornerRadius)
                    .shadow(radius: shadowRadius)
            }
            .disabled(fullname.isEmpty || email.isEmpty || password.isEmpty)
            .padding(.horizontal)

            Button(action: {
                self.showLoginView = true
            }) {
                Text("Already have an account?")
                    .foregroundColor(primaryColor)
            }
            .padding()

            // Hidden NavigationLink for programmatic navigation
            NavigationLink(destination: LoginView(userViewModel: userViewModel), isActive: $showLoginView) {
                EmptyView()
            }
            .hidden()

            // Continue with Google
            Button(action: onGoogleSignIn) {
                HStack {
                    Image(systemName: "globe")
                    Text("Continue with Google")
                }
                .foregroundColor(secondaryColor)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(inputCornerRadius)
            }
            .padding(.horizontal)

            // Continue with Apple
            SignInWithAppleButton(.signIn) { request in
                // Configure the request here, e.g., request requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                // Handle the authentication result
                switch result {
                case .success( _):
                    // Handle successful authorization
                    onAppleSignIn()
                case .failure(let error):
                    // Handle error
                    print(error.localizedDescription)
                }
            }
            .signInWithAppleButtonStyle(.black) // or .white, .whiteOutline
            .frame(height: buttonHeight)
            .cornerRadius(inputCornerRadius)
            .padding(.horizontal)

            Spacer() // Pushes everything to the top
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Sign Up")
    }
    
    // Custom TextField for uniform styling
    private func CustomTextField(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        TextField(placeholder, text: text)
            .padding()
            .background(inputBackgroundColor)
            .cornerRadius(inputCornerRadius)
            .keyboardType(keyboardType)
            .disableAutocorrection(true)
            .autocapitalization(.none)
    }
    
    // Custom SecureField for uniform styling
    private func CustomSecureField(placeholder: String, text: Binding<String>) -> some View {
        SecureField(placeholder, text: text)
            .padding()
            .background(inputBackgroundColor)
            .cornerRadius(inputCornerRadius)
    }
    
    // Custom DatePicker for uniform styling
    private func CustomDatePicker(placeholder: String, date: Binding<Date>) -> some View {
        DatePicker(placeholder, selection: date, displayedComponents: .date)
            .padding()
            .background(inputBackgroundColor)
            .cornerRadius(inputCornerRadius)
    }
}


// MARK: Sign up step 2
struct SignUpStep2View: View {
    @Binding var phone: String
    @State private var verificationCode: String = ""
    var onNext: () -> Void

    var body: some View {
        VStack {
            TextField("Phone Number", text: $phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.phonePad)
            TextField("Verification Code", text: $verificationCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Verify and Next", action: onNext)
                .disabled(phone.isEmpty || verificationCode.isEmpty)
        }
        .padding()
    }
}

// MARK: Sign up step 3
struct SignUpStep3View: View {
    @Binding var profilePicture: UIImage?
    @Binding var username: String
    var onNext: () -> Void

    @State private var showingImagePicker = false

    var body: some View {
        VStack {
            Button(action: { showingImagePicker = true }) {
                if let profileImage = profilePicture {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 100, height: 100)
                        .overlay(Text("Add Image"))
                }
            }
            .sheet(isPresented: $showingImagePicker, content: {
                ImagePicker(isShown: $showingImagePicker, image: $profilePicture)
            })

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button("Next", action: onNext)
                .disabled(username.isEmpty)
        }
        .padding()
    }
}


// MARK: Sign up step 4
struct SignUpStep4View: View {
    @Binding var termsOfServiceAccepted: Bool
    var onNext: () -> Void

    var body: some View {
        VStack {
            // Display terms of service text
            Toggle("I accept the Terms of Service", isOn: $termsOfServiceAccepted)

            Button("Next", action: onNext)
                .disabled(!termsOfServiceAccepted)
        }
        .padding()
    }
}

// MARK: Sign up step 5
struct SignUpStep5View: View {
    @Binding var privacyPolicyAccepted: Bool
    var onNext: () -> Void

    var body: some View {
        VStack {
            // Display privacy policy text
            Toggle("I accept the Privacy Policy", isOn: $privacyPolicyAccepted)

            Button("Next", action: onNext)
                .disabled(!privacyPolicyAccepted)
        }
        .padding()
    }
}

// MARK: Sign up step 6
struct SignUpStep6View: View {
    @Binding var email: String
    @Binding var username: String
    @Binding var fullname: String
    @Binding var phone: String
    @Binding var birthdate: Date
    @Binding var privacySettings: Bool
    var onComplete: () -> Void
    
    var body: some View {
        VStack {
            Text("Is this information correct?")
            Text("Email: \(email)")
            Text("Username: \(username)")
            Text("Full Name: \(fullname)")
            Text("Phone Number: \(phone)")
            Text("Date of Birth: \(birthdate, formatter: DateFormatter.shortDate)")
            Toggle("Publicly Searchable Profile", isOn: $privacySettings)

            Button("Complete Sign Up", action: onComplete)
        }
        .padding()
    }
}




struct ProfileSetupView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State private var currentStep = 1
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var fullname = ""
    @State private var phone = ""
    @State private var profilePicture: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var isNavigating = false
    @State private var birthdate: Date = Date()
    @State private var termsOfServiceAccepted: Bool = false
    @State private var privacyPolicyAccepted: Bool = false
    @State private var privacySettings: Bool = true
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToLogin = false

    
    
    
    var body: some View {
            VStack {
                if currentStep == 1 {
                    SignUpStep1View(
                        userViewModel: userViewModel, fullname: $fullname,
                        birthdate: $birthdate,
                        email: $email,
                        password: $password, // Pass the UserViewModel instance here
                        onNext: { currentStep = 2 },
                        onSignIn: {
                            // Action to perform when "Already have an account?" is tapped
                        },
                        onGoogleSignIn: {
                            // Action to perform for Google Sign In
                        },
                        onAppleSignIn: {
                            // Action to perform for Apple Sign In
                        }
                    )

                } else if currentStep == 2 {
                    SignUpStep2View(phone: $phone, onNext: { currentStep = 3 })
                } else if currentStep == 3 {
                    SignUpStep3View(profilePicture: $profilePicture, username: $username, onNext: { currentStep = 4 })
                } else if currentStep == 4 {
                    SignUpStep4View(termsOfServiceAccepted: $termsOfServiceAccepted, onNext: { currentStep = 5 })
                } else if currentStep == 5 {
                    SignUpStep5View(privacyPolicyAccepted: $privacyPolicyAccepted, onNext: { currentStep = 6 })
                } else if currentStep == 6 {
                    SignUpStep6View(email: $email, username: $username, fullname: $fullname, phone: $phone, birthdate: $birthdate, privacySettings: $privacySettings) {
                                        completeSignup(email: email, password: password, username: username, fullname: fullname, phone: phone, profilePicture: profilePicture)
                                    }
                                }

                                if currentStep > 1 {
                                    Button("Back") { currentStep -= 1 }
                                }

                                // NavigationLink to LoginView
                                NavigationLink(destination: LoginView(userViewModel: userViewModel), isActive: $navigateToLogin) {
                                    EmptyView()
                                }
                            }
                        }

                        private func completeSignup(email: String, password: String, username: String, fullname: String, phone: String, profilePicture: UIImage?) {
                            userViewModel.signUp(email: email, password: password, username: username, fullname: fullname, phone: phone, profilePicture: profilePicture, termsOfServiceAccepted: true, privacyPolicyAccepted: true) { result in
                                switch result {
                                case .success:
                                    // Trigger navigation to LoginView
                                    navigateToLogin = true
                                case .failure(let error):
                                    print("Signup error: \(error.localizedDescription)")
                                }
                            }
                        }
                    }


extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
}

