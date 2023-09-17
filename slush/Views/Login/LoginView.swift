//
//  LoginView.swift
//  slush
//
//  Created by Kareem Benaissa on 8/5/23.
//
// TODO: Add email verification
import SwiftUI

struct LoginView: View {
    @ObservedObject var userViewModel: UserViewModel

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
                userViewModel.login(username: username, password: password)
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
                userViewModel.signUp(username: username, password: password)
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
