//
//  MessageView.swift
//  slush
//
//  Created by Aidan Lynde on 12/16/23.
//

import SwiftUI

import SwiftUI

struct MessageView: View {
    var message: Message
    let currentUserID: String  // Replace this with the actual current user's ID

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if message.senderID != currentUserID {
                // Message bubble for received messages
                messageBubble(color: Color.gray, alignment: .leading)
            }

            Spacer()

            if message.senderID == currentUserID {
                // Message bubble for sent messages
                messageBubble(color: Color.blue, alignment: .trailing)
            }
        }
        .padding(.horizontal)
    }

    private func messageBubble(color: Color, alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 0) {
            Text(message.text)
                .padding()
                .background(color)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// Demo and preview
struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(message: Message(text: "Hello, this is a test message!", senderID: "user123", receiverID: "user456", timestamp: Date()), currentUserID: "user123")
    }
}

