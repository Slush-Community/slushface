// Model: Represents the data and business logic. It's unaware of the view or the view model.
struct User {
    //key
    var id: String
    
    //value
    var username: String
    // stores user friends as list of ids
    var friends: [String]
    
    // Add other fields as needed
}
