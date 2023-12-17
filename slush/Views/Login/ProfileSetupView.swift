//
//  ProfileSetupView.swift
//  slush
//
//  Created by Aidan Lynde on 10/19/23.
//

import SwiftUI

struct ProfileSetupView: View {
    @ObservedObject var userViewModel: UserViewModel
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
    }
    
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var phone: String = ""
    @State private var profilePicture: UIImage? = nil
    @State private var showingImagePicker: Bool = false
    @State private var isNavigating: Bool = false
    
    
    private var authenticationService = AuthenticationService()
    
    
    func completeSignup(email: String, password: String, username: String, phone: String, profilePicture: UIImage?) {
        authenticationService.signUp(email: email, password: password) { result in
            switch result {
            case .success(_):
                let displayName = username
                let birthdate: Date? = nil  // Or provide a default value if necessary

                userViewModel.updateUserProfile(displayName: displayName, birthdate: birthdate, phone: phone, profilePicture: profilePicture) { updateResult in
                    switch updateResult {
                    case .success:
                        // Handle successful profile update
                        print("Profile updated successfully.")
                    case .failure(let updateError):
                        // Handle error in profile update
                        print("Profile update error: \(updateError.localizedDescription)")
                    }
                }
            case .failure(let error):
                // Handle signup error
                print("Signup error: \(error.localizedDescription)")
            }
        }
    }


    
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let profileImage = profilePicture {
                    Image(uiImage: profileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.green.opacity(0.5))
                }
                
                Button(action: {
                    showingImagePicker.toggle()
                }) {
                    Text("Select Profile Picture")
                        .foregroundColor(.green)
                }
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                TextField("Phone", text: $phone)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.phonePad)
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                
                Button("Save Profile") {
                    let defaultDisplayName = username // Or any default value you deem appropriate
                    let defaultBirthdate = Date()     // Placeholder birthdate, adjust as necessary
                    let defaultTermsAccepted = true   // Assuming terms and privacy policy are accepted for this example
                    let defaultPrivacyAccepted = true

                    userViewModel.signUp(email: email, password: password, username: username, displayName: defaultDisplayName, birthdate: defaultBirthdate, phone: phone, profilePicture: profilePicture, termsOfServiceAccepted: defaultTermsAccepted, privacyPolicyAccepted: defaultPrivacyAccepted) { result in
                        switch result {
                        case .success:
                            if userViewModel.isAuthenticated {
                                isNavigating = true
                            }
                        case .failure(let error):
                            print("Signup error: \(error.localizedDescription)")
                        }
                    }
                }


                
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .sheet(isPresented: $showingImagePicker, content: {
            ImagePicker(isShown: $showingImagePicker, image: $profilePicture)
        })
        if isNavigating {
            HomeView(userViewModel: userViewModel)
        }
    }
}

