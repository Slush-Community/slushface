////
//  ProfileSetupView.swift
//  slush
//
//  Created by Aidan Lynde on 10/19/23.
//

import SwiftUI

struct ProfileSetupView: View {
    @ObservedObject var userViewModel: UserViewModel

    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var phone = ""
    @State private var profilePicture: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var isNavigating = false

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
                    completeSignup(email: email, password: password, username: username, phone: phone, profilePicture: profilePicture)
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
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

    private func completeSignup(email: String, password: String, username: String, phone: String, profilePicture: UIImage?) {
        userViewModel.signUp(email: email, password: password, username: username, displayName: username, birthdate: nil, phone: phone, profilePicture: profilePicture, termsOfServiceAccepted: true, privacyPolicyAccepted: true) { result in
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
}
