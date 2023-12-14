//
//  UserProfileView.swift
//  slush
//
//  Created by Aidan Lynde on 12/14/23.
//

import SwiftUI

struct UserProfileView: View {
    var user: User

    var body: some View {
        // Use the user data to display the profile
        VStack {
            Text("Username: \(user.username)")
            // Add more user details as needed
        }
    }
}

