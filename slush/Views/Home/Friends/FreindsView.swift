//
//  FreindsView.swift
//  slush
//
//  Created by Kareem Benaissa on 10/5/23.
//

import SwiftUI

struct FriendsView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State private var searchQuery: String = ""

    var body: some View {
        VStack {
            // Existing list and add friend functionality...

            // Search for friend by username
            HStack {
                TextField("Enter friend's username", text: $searchQuery)
                    .padding()
                    .border(Color.gray)
                
                Button(action: {
                    userViewModel.searchForUser(username: searchQuery)
                }) {
                    Text("Search")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()

            // Display the search result
            if let user = userViewModel.searchedUser {
                Text("Found: \(user.username)")
                Button(action: {
                    userViewModel.addFriend(friendUID: user.id)
                }) {
                    Text("Add as Friend")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}


