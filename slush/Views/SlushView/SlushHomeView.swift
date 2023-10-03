//
//  SlushHomeView.swift
//  slush
//
//  Created by Kareem Benaissa on 10/2/23.
//

import SwiftUI

struct SlushHomeView: View {
    @ObservedObject var userViewModel: UserViewModel  // Inject the view model

    var body: some View {
        VStack {
            //do front end shit with userviewmodel
            Text("Welcome, \(userViewModel.userData?.username ?? "User")!")
                .font(.largeTitle)
                .padding()

            // Display more user data or other UI components here
        }
    }
}
