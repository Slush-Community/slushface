//
//  HomeView.swift
//  slush
//
//  Created by Kareem Benaissa on 8/5/23.
// View: Represents the UI. In SwiftUI, views are lightweight and often regenerated, so they should be free of app logic.]
// TODO: make the viewfriends button actually link to the FriendsView page

import SwiftUI


struct HomeView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State private var showSlushCreateView = false

    var body: some View {
        ZStack { // Root ZStack
            VStack(spacing: 0) {
                // Profile section
                HStack(spacing: 15) {
                    Image(systemName: "dollarsign.circle")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)

                    VStack(alignment: .leading, spacing: 10) {
                        Text(userViewModel.userData?.username ?? "Default Username")
                            .font(.system(size: 16))
                            .fontWeight(.medium)

                        NavigationLink(destination: FriendsView(userViewModel: userViewModel)) {
                            Text("View Friends")
                                .font(.headline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                    }
                }
                .padding(.top, 85)
                .padding(.bottom, 30)

                // ScrollView for Friends' activity
                NavigationView {
                    ScrollView {
                        VStack(spacing: 20) { // Reduced spacing between vertical stacks
                            // Your other content here...

                            HStack(spacing: 20) { // Reduced spacing between horizontal stacks
                                NavigationLink(destination: ListView(userViewModel: userViewModel)) {
                                    Image(systemName: "")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45) // Increased square size to 45% of screen width
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())

                                NavigationLink(destination: Text("Page 2")) {
                                    Image(systemName: "")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45) // Increased square size to 45% of screen width
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }

                            HStack(spacing: 20) { // Reduced spacing between horizontal stacks
                                NavigationLink(destination: Text("Page 3")) {
                                    Image(systemName: "")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45) // Increased square size to 45% of screen width
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())

                                NavigationLink(destination: Text("Page 4")) {
                                    Image(systemName: "")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45) // Increased square size to 45% of screen width
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            HStack(spacing: 20) { // Reduced spacing between horizontal stacks
                                NavigationLink(destination: Text("Page 5")) {
                                    Image(systemName: "")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45) // Increased square size to 45% of screen width
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())

                                NavigationLink(destination: Text("Page 6")) {
                                    Image(systemName: "")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45) // Increased square size to 45% of screen width
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            HStack(spacing: 20) { // Reduced spacing between horizontal stacks
                                NavigationLink(destination: Text("Page 7")) {
                                    Image(systemName: "")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45) // Increased square size to 45% of screen width
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())

                                NavigationLink(destination: Text("Page 8")) {
                                    Image(systemName: "")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45) // Increased square size to 45% of screen width
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                        }
                        .padding(.horizontal, 10) // Adjusted horizontal padding for the overall ScrollView content
                    }
                }
                Spacer() // Pushes content to the top
            }
            .edgesIgnoringSafeArea(.top) // Only ignore the top safe area
            
            // Tab menu at the bottom
            VStack(spacing: 0) {
                Spacer(minLength: 0) // Let's adjust the spacer to ensure it doesn't cover the entire screen
                ZStack {
                    Circle()
                        .frame(width: 85, height: 85)
                        .foregroundColor(Color.white)
                        .shadow(radius: 5)

                    Button(action: {
                        showSlushCreateView.toggle()
                    }) {
                        Image(systemName: "dollarsign.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    }
                    .sheet(isPresented: $showSlushCreateView) {
                        SlushCreateView()
                    }
                }
                .frame(height: 80) // Explicitly set the height for the ZStack
                .background(Color.white)
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}











