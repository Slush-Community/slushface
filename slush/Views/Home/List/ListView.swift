//
//  ListView.swift
//  slush
//
//  Created by Kareem Benaissa on 10/2/23.
//
import SwiftUI

struct ListView: View {
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack {
            Text("\(userViewModel.userData?.username ?? "User")'s List")
                .font(.largeTitle)
                .padding()
            
            // Add more content or UI components specific to the ListView here
        }
    }
}
