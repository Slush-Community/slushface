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
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Image(systemName: "dollarsign.circle")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(Color.green)

                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .autocapitalization(.none)

                Button(action: {
                    isLoading = true
                    userViewModel.login(username: username, password: password)
                    isLoading = false
                }) {
                    Text("Log In")
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                // Apple Sign In
                SignInWithAppleButton(.signIn, onRequest: { request in
                    // Customize the request here
                }, onCompletion: { result in
                    switch result {
                    case .success(let authResults):
                        // Handle success
                        print(authResults)
                    case .failure(let error):
                        // Handle error
                        print(error.localizedDescription)
                    }
                })
                .frame(width: 250, height: 45)
                .cornerRadius(10)

                // You'd similarly add a Google Sign In button here, but the code for it would depend on the library/method you're using to integrate Google Sign In.

                Spacer()

                Button(action: {
                    userViewModel.signUp(username: username, password: password)
                }) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(Color.gray)
                }
                .padding(.bottom)
            }
            .padding()
            .blur(radius: isLoading ? 5 : 0)

            if isLoading {
                ProgressView() // Loading spinner
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    .scaleEffect(2, anchor: .center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white.opacity(0.8).ignoresSafeArea())
            }
        }
    }
}




//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
