//
//  HomeView.swift
//  slush
//
//  Created by Kareem Benaissa on 8/5/23.
// View: Represents the UI. In SwiftUI, views are lightweight and often regenerated, so they should be free of app logic.]

import SwiftUI

struct HomeView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State private var showSlushCreateView = false

    var body: some View {
        ZStack {
            // MARK: Profile/View Friends
            NavigationView {
                VStack(spacing: 0) {
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
                    .padding(.top, 45)
                    .padding(.bottom, 40)

            // MARK: Widgets
                    ScrollView {
                        VStack(spacing: 20) {
                            HStack(spacing: 20) {
                                NavigationLink(destination: ListView(userViewModel: userViewModel)) {
                                    Image(systemName: "")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())

                                NavigationLink(destination: Text("Page 2")) {
                                    Image(systemName: "")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }

                            HStack(spacing: 20) {
                                NavigationLink(destination: Text("Page 3")) {
                                    Image(systemName: "")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())

                                NavigationLink(destination: Text("Page 4")) {
                                    Image(systemName: "")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            HStack(spacing: 20) {
                                NavigationLink(destination: Text("Page 5")) {
                                    Image(systemName: "")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())

                                NavigationLink(destination: Text("Page 6")) {
                                    Image(systemName: "")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            HStack(spacing: 20) {
                                NavigationLink(destination: Text("Page 7")) {
                                    Image(systemName: "")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())

                                NavigationLink(destination: Text("Page 8")) {
                                    Image(systemName: "")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45)
                                        .background(Color.gray)
                                        .cornerRadius(15)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                        }
                        .padding(.horizontal, 10)
                    }
                }
            }

            // MARK: Slush Button
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                ZStack {
                    Circle()
                        .foregroundColor(Color.white)
                        .frame(width: 85, height: 85)
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
                .frame(height: 85)
                .edgesIgnoringSafeArea(.bottom)
            }

        }
    }
}


