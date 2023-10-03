//
//  SlushModel.swift
//  slush
//
//  Created by Kareem Benaissa on 9/17/23.
//

struct Slush {
    //key
    var id: String
    
    //value
    var creator: User
    var product: String
    var price: Double
    var participants: [User]
    var isSpent: Bool
    // ... Any other necessary properties ...
}
