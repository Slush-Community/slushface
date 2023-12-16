//
//  MessageListView.swift
//  slush
//
//  Created by Aidan Lynde on 12/16/23.
//
import SwiftUI

struct MessageListView: View {
    @ObservedObject var userViewModel: UserViewModel
    var conversationID: String
    @State private var messageText: String = ""

    var body: some View {
        VStack {
            // Messages display
            ScrollView {
                ForEach(userViewModel.messages) { message in
                    // Pass the currentUserID to MessageView
                    MessageView(message: message, currentUserID: userViewModel.currentUserID ?? "")
                }
            }

            // Message input field
            HStack {
                TextField("Type a message...", text: $messageText)
                Button("Send") {
                    userViewModel.sendMessage(messageText, to: "receiverUserID", inConversation: conversationID)
                    messageText = ""
                }
            }.padding()
        }
    }
}

