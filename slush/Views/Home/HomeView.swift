//
//  HomeView.swift
//  slush
//
//  Created by Kareem Benaissa on 8/5/23.
// View: Represents the UI. In SwiftUI, views are lightweight and often regenerated, so they should be free of app logic.
import SwiftUI

struct HomeView: View {
    @ObservedObject var userViewModel: UserViewModel  // Inject the view model

    var body: some View {
        VStack {
            Text("Welcome, \(userViewModel.userData?.username ?? "User")!")
                .font(.largeTitle)
                .padding()

            // Display more user data or other UI components here
        }
    }
}
