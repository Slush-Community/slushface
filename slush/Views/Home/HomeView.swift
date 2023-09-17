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
        UserInfoView()
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
