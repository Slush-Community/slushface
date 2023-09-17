import FirebaseFirestore

class FirestoreService {
    
    private var db = Firestore.firestore()

    func fetchUser(withUID uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(uid).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, let data = document.data() {
                let user = User(id: uid, username: data["username"] as? String ?? "") // Ensure proper decoding
                completion(.success(user))
            }
        }
    }

    // Additional methods like updateUser, deleteUser, etc.
}

