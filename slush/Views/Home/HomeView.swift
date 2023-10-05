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
    @State private var forceUpdate = UUID()

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
            // .zIndex(1)

            // Tab menu
            VStack(spacing: 0) {
                Spacer() // Push the tab menu to the bottom
                
                ZStack {
                    // Custom divider
                    Path { path in
                        let start = CGPoint(x: UIScreen.main.bounds.width / 2 - 48, y: 0)
                        let end = CGPoint(x: UIScreen.main.bounds.width / 2 + 48, y: 0)
                        let control1 = CGPoint(x: UIScreen.main.bounds.width / 2 - 30, y: 63)
                        let control2 = CGPoint(x: UIScreen.main.bounds.width / 2 + 30, y: 63)

                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: start)
                        path.addCurve(to: end, control1: control1, control2: control2)
                        path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 0))
                    }
                    .stroke(Color.white, lineWidth: 1)
                    .opacity(0.7)
                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: -3)
                    
                    HStack(spacing: 0) {
                        Button(action: {
                            print("ListView button tapped!")
                            forceUpdate = UUID()
                            selectedPage = 0
                        }) {
                            Image(systemName: "list.bullet")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 21, height: 21)
                                .foregroundColor(selectedPage == 0 ? Color.blue : Color.gray)
                        }
                        .frame(maxWidth: .infinity)

                        ZStack {
                            Circle()
                                .frame(width: 70, height: 70)
                                .foregroundColor(Color.white)
                                .shadow(radius: 5)

                            Button(action: {
                                showSlushCreateView.toggle()
                            }) {
                                Image(systemName: "dollarsign.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                            }
                            .sheet(isPresented: $showSlushCreateView) {
                                SlushCreateView()
                            }
                        }
                        .offset(y: -58)
                        .padding(.bottom, -35)

                        Button(action: {
                            selectedPage = 2
                        }) {
                            Image(systemName: "house")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(selectedPage == 2 ? Color.blue : Color.gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 80)
                .background(Color.white)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .edgesIgnoringSafeArea(.all)
    }
}










