//
//  HomeView.swift
//  slush
//
//  Created by Kareem Benaissa on 8/5/23.
// View: Represents the UI. In SwiftUI, views are lightweight and often regenerated, so they should be free of app logic.]


import SwiftUI

struct HomeView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State private var selectedPage = 1
    @State private var showSlushCreateView = false

    var body: some View {
        ZStack {
            // This is the main content of your views, which takes up most of the screen.
            
            // TODO: Fix List bug to allow to click on the Icon after inital load
            TabView(selection: $selectedPage) {
                ListView(userViewModel: userViewModel)
                .tag(0)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Profile picture
                        Image(systemName: "dollarsign.circle")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())  // Makes the image circular
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: 4))  // Add a border to the image
                            .shadow(radius: 10)  // Adds a subtle shadow
                        
                        // Username
                        Text(userViewModel.userData?.username ?? "Default Username")
                            .font(.title)
                            .fontWeight(.medium)
                        
                        // Friends' activity
                        Text("Slush Friends Activity")
                            .font(.headline)
                            .padding(.bottom, 10)
                        
                        // Here, you can add more views/components to display the actual friends' activity.
                        // Example:
//                        ForEach(userViewModel.friendsActivity, id: \.self) { activity in
//                            Text(activity)
//                        }
                    }
                    .padding()
                }

                .tag(1)

                MarketplaceView(userViewModel: userViewModel)
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxHeight: .infinity)
            .onChange(of: selectedPage) { _ in
                // Force the view to update
                withAnimation {
                    self.selectedPage = selectedPage
                }
            }
            
            VStack {
                Spacer()  // Push the menu to the bottom
                
                Divider()  // Add a line to visually separate the tab menu

                // This is your fixed tab menu.
                HStack {
                    Button(action: {
                        selectedPage = 0
                    }) {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .frame(width: 21, height: 21)
                            .foregroundColor(selectedPage == 0 ? Color.blue : Color.gray)
                    }
                    
                    Spacer().frame(width: 50)
                    
                    Button(action: {
                        showSlushCreateView.toggle()
                    }) {
                        Image(systemName: "dollarsign.circle")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    .sheet(isPresented: $showSlushCreateView) {
                        SlushCreateView()
                    }
                    
                    Spacer().frame(width: 50)
                    
                    Button(action: {
                        selectedPage = 2
                    }) {
                        Image(systemName: "house")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(selectedPage == 2 ? Color.blue : Color.gray)
                    }
                }
                .padding()
                .zIndex(1)  // This ensures the menu is above the TabView
            }
        }
    }
}








