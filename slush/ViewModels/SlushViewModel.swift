//
//  SlushViewModel.swift
//  slush
//
//  Created by Kareem Benaissa on 9/17/23.
//
import SwiftUI

class SlushViewModel: ObservableObject {
    @Published var slushes: [Slush] = []
    // ... Other Observable properties ...

    // Service to interact with Firestore
    private var firestoreService = FirestoreService()

    // Functions to create, edit, invite, and spend a slush.
    func createSlush(/*... parameters ...*/) {
        // Call firestoreService to create a new slush
    }

    func inviteToSlush(/*... parameters ...*/) {
        // Call firestoreService to invite a user to a slush
    }

    // ... Other necessary functions ...
}
