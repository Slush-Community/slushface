//
//  LoginView.swift
//  slush
//
//  Created by Kareem Benaissa on 8/5/23.
//
// TODO: Add email verification
import SwiftUI
import Firebase

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding()
                .autocapitalization(.none)
            SecureField("Password", text: $password)
                .padding()
                .autocapitalization(.none)
            Button(action: {
                Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
                    if let error = error {
                        print("Error occurred: \(error.localizedDescription)")
                    } else {
                        print("User signed in successfully.")
                        self.isAuthenticated = true
                    }
                }
            }) {
                Text("Log In")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            
            // Sign Up button
                Button(action: {
                    Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
                        if let error = error {
                            print("Error occurred: \(error.localizedDescription)")
                        } else {
                            print("User signed up successfully.")
                        }
                    }
                }) {
                    Text("Sign Up")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
