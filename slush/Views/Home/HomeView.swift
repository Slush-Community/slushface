//
//  HomeView.swift
//  slush
//
//  Created by Kareem Benaissa on 8/5/23.
// View: Represents the UI. In SwiftUI, views are lightweight and often regenerated, so they should be free of app logic.]
// TODO: Fix bug where you can't select the list page when the page loads
// TODO: Make settings wheel lead to SettingsView onclick

import SwiftUI

struct HomeView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State private var showSlushCreateView = false

    var body: some View {
        VStack(spacing: 0) {
            // Profile section
            HStack(spacing: 15) {
                Spacer()
                Image(systemName: "dollarsign.circle")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    

                Text(userViewModel.userData?.username ?? "Default Username")
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding(.top, 85)
            .padding(.bottom, 30) // This will add some space between the profile and the ScrollView

            
            
            
            
            
            
            
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



            
            
            
            
            
            
            

            // Tab menu at the bottom
            ZStack {
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
                .offset(y: -45) // This moves the button halfway above the bottom
                .padding(.bottom, -35)
            }
            .frame(height: 80)
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
        }
        .edgesIgnoringSafeArea(.all)
    }
}










