// Model: Represents the data and business logic. It's unaware of the view or the view model.
import FirebaseFirestore
struct User {
    //key
    var id: String
    
    var email: String
    //value
    var username: String
    // stores user friends as list of ids
    var phone: String
    
    var profileImageUrl: String
    
    var friends: [String]
    
    var favoriteUserIDs: [String]
    var initials: String {
        return username.split(separator: " ").reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
    }
    
    static func from(document: DocumentSnapshot) -> User? {
        guard let data = document.data() else { return nil }

        guard let email = data["email"] as? String,
              let username = data["username"] as? String,
              let phone = data["phone"] as? String,
              let profileImageUrl = data["profileImageUrl"] as? String,
              let friends = data["friends"] as? [String],
              let favoriteUserIDs = data["favoriteUserIDs"] as? [String] else {
            return nil
        }

        let id = document.documentID

        // Initialize and return the User struct
        return User(id: id, email: email, username: username, phone: phone, profileImageUrl: profileImageUrl, friends: friends, favoriteUserIDs: favoriteUserIDs)
    }
}
