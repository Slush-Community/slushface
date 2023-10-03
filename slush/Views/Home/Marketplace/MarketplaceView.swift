//
//  MarketplaceView.swift
//  slush
//
//  Created by Kareem Benaissa on 10/2/23.
//
import SwiftUI

struct MarketplaceView: View {
    @ObservedObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack {
            Text("\(userViewModel.userData?.username ?? "User")'s Marketplace")
                .font(.largeTitle)
                .padding()

            // Add more content or UI components specific to the MarketplaceView here
        }
    }
}
