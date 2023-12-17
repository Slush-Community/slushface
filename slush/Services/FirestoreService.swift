import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class FirestoreService {
    
    private var db = Firestore.firestore()

    
// MARK: Fetch/Set UserProfile Data

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

                let user = User(id: uid, email: email, username: username, phone: phone, profileImageUrl: profileImageUrl, friends: friends, favoriteUserIDs: [])


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
                
                let user = User(id: id, email: email, username: username, phone: phone, profileImageUrl: profileImageUrl, friends: friends, favoriteUserIDs: [])

                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "No user found", code: 404, userInfo: nil)))
            }
        }
    }

}

// MARK: Add/Remove Friend Data
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
    
// MARK: Add/Remove Favorites
    
    func fetchFavoriteUserIDs(forUserID userID: String, completion: @escaping (Result<[String], Error>) -> Void) {
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let document = document, document.exists,
                  let data = document.data(),
                  let favoriteUserIDs = data["favoriteUserIDs"] as? [String] else {
                completion(.failure(NSError(domain: "FirestoreService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No favoriteUserIDs found or invalid data structure"])))
                return
            }
            completion(.success(favoriteUserIDs))
        }
    }
    
    func fetchUsers(byIDs userIDs: [String], completion: @escaping (Result<[User], Error>) -> Void) {
        let group = DispatchGroup()
        var users: [User] = []
        var anyError: Error?

        for userID in userIDs {
            group.enter()
            db.collection("users").document(userID).getDocument { document, error in
                defer { group.leave() }
                if let error = error {
                    anyError = error
                    return
                }
                if let document = document, document.exists, let user = User.from(document: document) {
                    users.append(user)
                }
            }
        }

        group.notify(queue: .main) {
            if let error = anyError {
                completion(.failure(error))
            } else {
                completion(.success(users))
            }
        }
    }
    
    func addFavoriteUser(currentUserID: String, favoriteUserID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("users").document(currentUserID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let userDocument: DocumentSnapshot
            do {
                try userDocument = transaction.getDocument(userRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard var favoriteUserIDs = userDocument.data()?["favoriteUserIDs"] as? [String] else {
                let error = NSError(domain: "FirestoreService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch favorite users."])
                errorPointer?.pointee = error
                return nil
            }

            if !favoriteUserIDs.contains(favoriteUserID) {
                favoriteUserIDs.append(favoriteUserID)
                transaction.updateData(["favoriteUserIDs": favoriteUserIDs], forDocument: userRef)
            }

            return nil
        }) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func removeFavoriteUser(currentUserID: String, favoriteUserID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userRef = db.collection("users").document(currentUserID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let userDocument: DocumentSnapshot
            do {
                try userDocument = transaction.getDocument(userRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }

            guard var favoriteUserIDs = userDocument.data()?["favoriteUserIDs"] as? [String] else {
                let error = NSError(domain: "FirestoreService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch favorite users."])
                errorPointer?.pointee = error
                return nil
            }

            if let index = favoriteUserIDs.firstIndex(of: favoriteUserID) {
                favoriteUserIDs.remove(at: index)
                transaction.updateData(["favoriteUserIDs": favoriteUserIDs], forDocument: userRef)
            }

            return nil
        }) { (_, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

// MARK: Friends Activity
    
    func fetchFriendsActivity(forUserID userID: String, completion: @escaping (Result<[Activity], Error>) -> Void) {
        // Implement the logic to fetch activities from Firebase
        // This is a simplified example. Adapt it based on your Firestore structure.

        db.collection("activities")  // Assuming you have an 'activities' collection
          .whereField("userID", isEqualTo: userID)
          .getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            let activities = querySnapshot?.documents.compactMap { document -> Activity? in
                // Map the Firestore document to an Activity object
                // Adjust this based on your actual data structure
                let data = document.data()
                let typeRawValue = data["type"] as? String ?? ""
                let type = ActivityType(rawValue: typeRawValue) ?? .friendRequest // Adjust default value as needed
                let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                let involvedUserID = data["involvedUserID"] as? String ?? ""
                let involvedUserName = data["involvedUserName"] as? String ?? ""
                let slushID = data["slushID"] as? String
                let slushTitle = data["slushTitle"] as? String
                
                return Activity(id: document.documentID,
                                type: type,
                                date: date,
                                involvedUserID: involvedUserID,
                                involvedUserName: involvedUserName,
                                slushID: slushID,
                                slushTitle: slushTitle)
            }
            completion(.success(activities ?? []))
        }
    }
    
// MARK: Messaging
    
    func fetchMessages(forConversationID conversationID: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        let db = Firestore.firestore()
        let conversationRef = db.collection("conversations").document(conversationID)
        
        conversationRef.getDocument { document, error in
            if let document = document, document.exists, let conversationData = document.data() {
                let messageDictionaries = conversationData["messages"] as? [[String: Any]] ?? []
                let messages = messageDictionaries.map { Message(dictionary: $0) }
                completion(.success(messages))
            } else {
                completion(.failure(error ?? NSError()))
            }
        }
    }


    
    func sendMessage(_ message: Message, inConversation conversationID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let conversationRef = db.collection("conversations").document(conversationID)
        conversationRef.updateData([
            "messages": FieldValue.arrayUnion([message.dictionaryRepresentation])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
// MARK: Notifications
    func fetchNotifications(forUserID userID: String, completion: @escaping (Result<[Notification], Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).collection("notifications").getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else if let documents = snapshot?.documents {
                let notifications = documents.compactMap { document -> Notification? in
                    let data = document.data()
                    let id = document.documentID
                    let title = data["title"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let typeRawValue = data["type"] as? String ?? ""
                    let type = NotificationType(rawValue: typeRawValue) ?? .info
                    let amount = data["amount"] as? Double
                    let actionRawValue = data["action"] as? String ?? ""
                    let action = NotificationAction(rawValue: actionRawValue)
                    let expiresTimestamp = data["expires"] as? Timestamp
                    let expires = expiresTimestamp?.dateValue()
                    
                    return Notification(id: id, title: title, description: description, type: type, amount: amount, action: action, expires: expires)
                }
                completion(.success(notifications))
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

