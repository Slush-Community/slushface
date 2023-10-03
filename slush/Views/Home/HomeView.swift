//
//  HomeView.swift
//  slush
//
//  Created by Kareem Benaissa on 8/5/23.
// View: Represents the UI. In SwiftUI, views are lightweight and often regenerated, so they should be free of app logic.
import SwiftUI

struct HomeView: View {
    @ObservedObject var userViewModel: UserViewModel  // Inject the view model
    @State private var selectedPage = 1  // Start with the HomeView as default
    @State private var showSlushCreateView = false // Control the presentation of SlushCreateView

    var body: some View {
        NavigationView {
            VStack {
                // Main TabView
                TabView(selection: $selectedPage) {
                    // First Page - ListView
                    ListView(userViewModel: userViewModel)
                        .tag(0)
                    // Middle Page - SlushHomeView
                    SlushHomeView(userViewModel: userViewModel)
                        .tag(1)
                    // Right Page - MarketplaceView
                    MarketplaceView(userViewModel: userViewModel)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))  // Hides the default page dots
                .frame(maxHeight: .infinity) // Occupy all available space
                
                HStack {
                    Button(action: {
                        selectedPage = 0
                    }) {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Spacer()
                    Button(action: {
                        showSlushCreateView.toggle()  // Toggle the showSlushCreateView state
                    }) {
                        Image(systemName: "dollarsign.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Spacer()
                    Button(action: {
                        selectedPage = 2
                    }) {
                        Image(systemName: "house")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .padding()
            }
            .sheet(isPresented: $showSlushCreateView) {
                SlushCreateView()  // Present SlushCreateView as a sheet
            }
        }
    }
}






