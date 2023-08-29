//
//  HomeView.swift
//  slush
//
//  Created by Kareem Benaissa on 8/5/23.
//
import SwiftUI
import Firebase

struct HomeView: View {
    @State private var selectedPage = 1 // Start with the middle page

    var body: some View {
        TabView(selection: $selectedPage) {
            // Left Page - Messaging Interface
            MessagingView()
                .tag(0)
            
            // Middle Page - Basic User Info
            UserInfoView()
                .tag(1)
            
            // Right Page - Network
            NetworkView()
                .tag(2)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hides the default page dots
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
