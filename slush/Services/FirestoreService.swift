import FirebaseFirestore

class FirestoreService {
    
    private var db = Firestore.firestore()

    func fetchUser(withUID uid: String, completion: @escaping (Result<User, Error>) -> Void) {
            db.collection("users").document(uid).getDocument { (document, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let document = document, let data = document.data() {
                    let username = data["username"] as? String ?? ""
                    let friends = data["friends"] as? [String] ?? []
                    let user = User(id: uid, username: username, friends: friends)
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
    
    func addFriend(uid: String, friendUID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("users").document(uid)
        let friendRef = db.collection("users").document(friendUID)
        
        // Begin a new write batch
        let batch = db.batch()
        
        // Add friendUID to the friends array of uid
        batch.updateData(["friends": FieldValue.arrayUnion([friendUID])], forDocument: userRef)
        
        // Add uid to the friends array of friendUID
        batch.updateData(["friends": FieldValue.arrayUnion([uid])], forDocument: friendRef)
        
        // Commit the batch
        batch.commit { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func removeFriend(uid: String, friendUID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("users").document(uid)
        let friendRef = db.collection("users").document(friendUID)
        
        // Begin a new write batch
        let batch = db.batch()
        
        // Remove friendUID from the friends array of uid
        batch.updateData(["friends": FieldValue.arrayRemove([friendUID])], forDocument: userRef)
        
        // Remove uid from the friends array of friendUID
        batch.updateData(["friends": FieldValue.arrayRemove([uid])], forDocument: friendRef)
        
        // Commit the batch
        batch.commit { error in
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

