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
    @State private var selectedPage = 1
    @State private var showSlushCreateView = false

    var body: some View {
        ZStack {
            
            // TabView
            TabView(selection: $selectedPage) {
                ListView(userViewModel: userViewModel)
                .tag(0)
                
                VStack {
                    // Profile section
                    HStack(spacing: 15) {
                        ZStack {
                            Image(systemName: "dollarsign.circle")
                                .resizable()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)

                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gearshape")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .padding(5)
                                    .background(Color.clear)
                            }
                            .background(Color.clear.frame(width: 50, height: 50))
                            .offset(x: 45, y: 45)
                            .zIndex(1)
                        }
                        
                        Text(userViewModel.userData?.username ?? "Default Username")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                    }
                    .padding(.top)
                    
                    // Friends' activity
                    ScrollView {
                        VStack(spacing: 20) {
                            Text("Slush Friends Activity")
                                .font(.headline)
                                .padding(.bottom, 10)
                            
                            // Placeholder for friends' activity
                        }
                        .padding()
                    }
                }
                .tag(1)

                MarketplaceView(userViewModel: userViewModel)
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxHeight: .infinity)

            // Tab menu
            VStack {
                Spacer()  // Push the menu to the bottom
                
                Divider()  // Add a line to visually separate the tab menu

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
            }
            .zIndex(2) // Make sure the tab menu is on top
        }
    }
}









