import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class FirestoreService {
    
    private var db = Firestore.firestore()


    func fetchUser(withUID uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(uid).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, let data = document.data() {
                let email = data["email"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let phone = data["phone"] as? String ?? ""
                let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                let friends = data["friends"] as? [String] ?? []

                let user = User(id: uid, email: email, username: username, phone: phone, profileImageUrl: profileImageUrl, friends: friends)

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


    func saveUserProfileData(userId: String, email: String, username: String, phone: String, profilePicture: URL, completion: @escaping (Result<Void, Error>) -> Void) {

        // Reference to the users collection
        let userRef = Firestore.firestore().collection("users").document(userId)

        // The data you want to save
        let userData: [String: Any] = [
            "email": email,
            "username": username,
            "phone": phone,
            "profilePicture": profilePicture.absoluteString
            // You might save other data as required
        ]

        // Set the data for the specific user
        userRef.setData(userData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func uploadProfileImage(_ image: UIImage, for uid: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "Invalid Image Data", code: 1001, userInfo: nil)))
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child("profile_images/\(uid).jpg")

        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            storageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let downloadURL = url {
                    completion(.success(downloadURL))
                }
            }
        }
    }

    
    
    func getUserByUsername(username: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").whereField("username", isEqualTo: username).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let documents = snapshot?.documents, let firstDoc = documents.first {
                let data = firstDoc.data()
                let id = firstDoc.documentID
                let email = data["email"] as? String ?? ""
                let phone = data["phone"] as? String ?? ""
                let profileImageUrl = data["profileImageUrl"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let friends = data["friends"] as? [String] ?? []
                
                let user = User(id: id, email: email, username: username, phone: phone, profileImageUrl: profileImageUrl, friends: friends)
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "No user found", code: 404, userInfo: nil)))
            }
        }
    }

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

