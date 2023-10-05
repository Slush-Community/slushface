//
//  SlushCreateView.swift
//  slush
//
//  Created by Kareem Benaissa on 9/17/23.
//

import SwiftUI

struct SlushCreateView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            Text("Slush Creation Page")
                .font(.largeTitle)
                .padding()
            
            Button("Go back") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

