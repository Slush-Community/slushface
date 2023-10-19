//
//  ProfileSetupView.swift
//  slush
//
//  Created by Aidan Lynde on 10/19/23.
//

import SwiftUI

struct ProfileSetupView: View {
    @ObservedObject var userViewModel: UserViewModel
    
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var phone: String = ""
    @State private var profilePicture: UIImage? = nil
    @State private var showingImagePicker: Bool = false
    
    var body: some View {
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
            
            Button("Save Profile") {
                userViewModel.updateUserProfile(email: email, username: username, phone: phone, profilePicture: profilePicture)
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
    }
}


