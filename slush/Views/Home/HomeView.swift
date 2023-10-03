//
//  HomeView.swift
//  slush
//
//  Created by Kareem Benaissa on 8/5/23.
// View: Represents the UI. In SwiftUI, views are lightweight and often regenerated, so they should be free of app logic.
import SwiftUI

struct HomeView: View {
    @ObservedObject var userViewModel: UserViewModel
    @State private var selectedPage = 1
    @State private var showSlushCreateView = false

    var body: some View {
        VStack {
            // This is the main content of your views, which takes up most of the screen.
            TabView(selection: $selectedPage) {
                ListView(userViewModel: userViewModel)
                .tag(0)
                
                ScrollView {
                    // Add your content here, for example:
                    Text("Slush Friends Activity")
                    // ... other content
                }
                .tag(1)


                MarketplaceView(userViewModel: userViewModel)
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(maxHeight: .infinity)

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
    }
}







