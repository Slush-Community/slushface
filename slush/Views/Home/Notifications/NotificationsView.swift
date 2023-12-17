//
//  NotificationsView.swift
//  slush
//
//  Created by Aidan Lynde on 12/16/23.
//

import SwiftUI

struct NotificationsView: View {
    @ObservedObject var userViewModel: UserViewModel

    var body: some View {
        List(userViewModel.notifications) { notification in
            NotificationCell(notification: notification)
        }
        .onAppear {
            userViewModel.fetchNotifications()
        }
    }
}

struct NotificationCell: View {
    let notification: Notification

    var body: some View {
        HStack {
            // Customize this view to match your notification cell UI
            VStack(alignment: .leading) {
                Text(notification.title)
                    .font(.headline)
                Text(notification.description)
                    .font(.subheadline)
                if let amount = notification.amount {
                    Text("$\(amount, specifier: "%.2f") total")
                }
            }
            Spacer()
            if let action = notification.action {
                Button(action: {
                    // Handle the action
                }) {
                    Text(action.rawValue)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
    }
}

