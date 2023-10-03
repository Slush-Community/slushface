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
                    // Your content
                    Text("Slush Friends Activity")
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








