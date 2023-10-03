//
//  SettingsView.swift
//  slush
//
//  Created by Aidan Lynde on 10/3/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    Text("Profile")
                    Text("Change Password")
                }
                
                Section(header: Text("Preferences")) {
                    Toggle(isOn: .constant(true), label: {
                        Text("Enable Notifications")
                    })
                    
                    Toggle(isOn: .constant(false), label: {
                        Text("Dark Mode")
                    })
                }
                
                Section(header: Text("Support")) {
                    Text("Feedback")
                    Text("Help & FAQ")
                }
                
                Section(header: Text("Others")) {
                    Text("Log Out")
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

