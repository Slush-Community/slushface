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
    @State private var isSearching: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar with Search Button
                HStack {
                    TextField("Enter friend's username", text: $searchQuery)
                        .padding()
                        .border(Color.gray)

                    Button(action: {
                        userViewModel.searchForUser(username: searchQuery)
                        isSearching = true
                    }) {
                        Text("Search")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()

                Divider()
                    .background(Color.gray)
                    .padding(.vertical)

                if isSearching {
                    // Search Results
                    SearchResultsView(userViewModel: userViewModel, searchQuery: $searchQuery, isSearching: $isSearching)
                } else {
                    // Main Content
                    ScrollView {
                        // 2. Horizontal Favorite Friends Scroll Wheel
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(userViewModel.favoriteUsers, id: \.id) { user in
                                    NavigationLink(destination: UserProfileView(userViewModel: userViewModel)) {
                                        // User representation
                                    }
                                }
                            }
                        }
                        .padding()

                        Divider()
                            .background(Color.gray)
                            .padding(.vertical)

                        // 3. Activity Feed Section
                        VStack(alignment: .leading) {
                            Text("Friends' Activity")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            ForEach(userViewModel.friendsActivity, id: \.id) { activity in
                                // Activity representation
                            }
                        }
                        .padding()
                    }
                                    }
                                }
                                .navigationBarTitle("Slush", displayMode: .inline)
                                .navigationBarItems(trailing: Button(action: {
                                    isSearching = false
                                }) {
                                    if isSearching {
                                        Text("Close")
                                    }
                                })
                                .onAppear {
                                    userViewModel.fetchFavoriteUsers()
                                    userViewModel.fetchFriendsActivity()
                                }
                            }
                        }
                    }

                    struct SearchResultsView: View {
                        @ObservedObject var userViewModel: UserViewModel
                        @Binding var searchQuery: String
                        @Binding var isSearching: Bool

                        var body: some View {
                            List {
                                // Check if a user is found or not
                                if let user = userViewModel.searchedUser {
                                    Text(user.username)
                                } else {
                                    Text("No results found for '\(searchQuery)'")
                                }
                            }
                            .navigationTitle("Search Results")
                        }
                    }
        /*
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
                        .background(Color.blue)
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
                            if let imageUrl = URL(string: user.profileImageUrl) {
                                AsyncImage(url: imageUrl) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
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
                            .padding()
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 2/3)
            }
            .padding()
        }
        .onAppear {
            userViewModel.fetchFavoriteUsers()
            userViewModel.fetchFriendsActivity()
        }
    }
}
*/

