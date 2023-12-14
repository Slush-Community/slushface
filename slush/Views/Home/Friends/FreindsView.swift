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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(userViewModel.favoriteUsers, id: \.id) { user in
                        NavigationLink(destination: UserProfileView(user: user)) {
                            if let imageUrl = URL(string: user.profileImageUrl), let imageData = try? Data(contentsOf: imageUrl), let image = UIImage(data: imageData) {
                                // Display user's profile picture
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            } else {
                                // Display user's initials in a circle as a placeholder
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 60, height: 60)
                                    .overlay(Text(user.initials))
                            }
                        }
                    }
                }
            }
            .padding()
            
            VStack {
                Text("Friends' Activity")
                    .font(.headline)
                ScrollView {
                    ForEach(userViewModel.friendsActivity, id: \.id) { activity in
                        Text(activity.description) // Replace with actual activity view
                    }
                }
            }
            .padding()
        }
    }
}


