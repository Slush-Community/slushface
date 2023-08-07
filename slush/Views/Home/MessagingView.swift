//
//  MessagingView.swift
//  slush
//
//  Created by Kareem Benaissa on 8/6/23.
//
/*
 Optimize for Performance: For a production-ready app, remember to paginate the messages using Firestore's limit and startAfter or startAt methods.
 
 Listen to Updates: Firebase provides real-time capabilities. Use addSnapshotListener to listen for real-time changes and update your UI accordingly.

 Additional Features: Implementing a complete messaging system includes handling image/audio messages, online/offline status, read receipts, etc. Consider those features for a comprehensive messaging app.
 */

import SwiftUI
import Firebase

struct MessageRow: Identifiable {
    var id: String
    var name: String
    var lastMessage: String
}

struct MessagingView: View {
    @State private var searchText = ""
    @State private var messageChains: [MessageRow] = [] // Sample data
    
    var filteredChains: [MessageRow] {
        messageChains.filter { $0.name.contains(searchText) || searchText.isEmpty }
    }
    
    var body: some View {
        VStack {
            // Search Bar
            TextField("Search...", text: $searchText)
                .padding(7)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.horizontal)
            
            // Message Chains
            List(filteredChains) { chain in
                NavigationLink(destination: ChatView(chainID: chain.id)) {
                    VStack(alignment: .leading) {
                        Text(chain.name)
                            .font(.headline)
                        Text(chain.lastMessage)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .onAppear {
            fetchChats()
        }
    }
    
    func fetchChats() {
        // Use Firestore to get the chats for the current user and populate the messageChains array.
        let db = Firestore.firestore()
        
        // Sample query (customize based on your needs)
        db.collection("chats")
            .whereField("user1ID", isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .addSnapshotListener { (snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("No documents: \(error!)")
                    return
                }
                
                messageChains = documents.map { (queryDocumentSnapshot) in
                    let data = queryDocumentSnapshot.data()
                    let name = data["name"] as? String ?? ""
                    let lastMessage = data["latestMessage"] as? String ?? ""
                    return MessageRow(id: queryDocumentSnapshot.documentID, name: name, lastMessage: lastMessage)
                }
            }
    }
}

struct ChatView: View {
    var chainID: String
    
    // Add State and logic to load messages associated with this chat
    
    var body: some View {
        Text("Chat screen for \(chainID)")
    }
}

