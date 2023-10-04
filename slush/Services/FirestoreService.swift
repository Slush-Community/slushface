import FirebaseFirestore

class FirestoreService {
    
    private var db = Firestore.firestore()

    func fetchUser(withUID uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(uid).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, let data = document.data() {
                let user = User(id: uid, username: data["username"] as? String ?? "", friends: <#T##[User]#>) // Ensure proper decoding
                completion(.success(user))
            }
        }
    }
    
    func setUserData(uid: String, username: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(uid).setData(["username": username]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // Additional methods like updateUser, deleteUser, etc.
}

// MARK: Freind Database Operations
extension FirestoreService {
    
    func establishFriendship(user1ID: String, user2ID: String, completion: @escaping (Result<Void, Error>) -> Void) {
            let friendshipID = "\(user1ID)_\(user2ID)"
            let friendshipData: [String: Any] = [
                "user1ID": user1ID,
                "user2ID": user2ID,
                "dateEstablished": Timestamp(date: Date()),
                "status": "confirmed" // or "pending" based on your use-case
            ]
            
            db.collection("friendships").document(friendshipID).setData(friendshipData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    
    func removeFriendship(user1ID: String, user2ID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let friendshipID = "\(user1ID)_\(user2ID)"
        db.collection("friendships").document(friendshipID).delete() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}



// MARK: - Slush Database Operations
extension FirestoreService {

    func createSlush(slush: Slush, completion: @escaping (Result<Slush, Error>) -> Void) {
        // Logic to add the slush to Firestore
    }

    func inviteToSlush(slushID: String, user: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        // Logic to invite a user to a specific slush
    }

    func spendSlush(slushID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        // Logic to mark a slush as spent and divide the price
    }

    // ... Other necessary methods ...
}

