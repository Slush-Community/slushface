// ViewModel: Acts as a bridge between the Model and the View. It holds the presentation logic and might transform the Model data into a format that can be easily displayed.
import SwiftUI
import Combine

class UserViewModel: ObservableObject {
    @Published var userData: User?
    @Published var isAuthenticated: Bool = false
    
    private var authService = AuthenticationService()
    private var firestoreService = FirestoreService()

    func login(username: String, password: String) {
        authService.signIn(email: username, password: password) { [weak self] result in
            switch result {
                case .success(let authResult):
                    let uid = authResult.user.uid
                    self?.fetchUserData(uid: uid)
                case .failure(let error):
                    print("Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchUserData(uid: String) {
        firestoreService.fetchUser(withUID: uid) { [weak self] result in
            switch result {
                case .success(let user):
                    self?.userData = user
                    self?.isAuthenticated = true
                case .failure(let error):
                    print("Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    func signUp(username: String, password: String) {
        authService.signUp(email: username, password: password) { [weak self] result in
            switch result {
            case .success(let authResult):
                print("User signed up successfully.")
                let uid = authResult.user.uid
                self?.firestoreService.setUserData(uid: uid, username: username) { firestoreResult in
                    switch firestoreResult {
                    case .success:
                        print("User data added to Firestore successfully.")
                    case .failure(let error):
                        print("Failed to add user data to Firestore: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }


    // Additional methods for sign up, sign out, etc.
}

// MARK: Freinds ViewModel Operations
extension UserViewModel {

    func addFriend(friendUID: String) {
        guard let currentUserID = userData?.id else { return }
        
        // You might need to decide the order of UIDs based on some criteria like alphabetical order
        let (user1ID, user2ID) = (currentUserID < friendUID) ? (currentUserID, friendUID) : (friendUID, currentUserID)
        
        // use [weak self] before result if you use self in the code somewhere
        firestoreService.establishFriendship(user1ID: user1ID, user2ID: user2ID) { result in
            switch result {
            case .success:
                print("Friendship established successfully.")
                // Optionally, re-fetch user's friends list or other data
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    func removeFriend(friendUID: String) {
        guard let currentUserID = userData?.id else { return }
        
        // You might need to decide the order of UIDs based on some criteria like alphabetical order
        let (user1ID, user2ID) = (currentUserID < friendUID) ? (currentUserID, friendUID) : (friendUID, currentUserID)
        
        // use [weak self] before result if you use self in the code somewhere
        firestoreService.removeFriendship(user1ID: user1ID, user2ID: user2ID) { result in
            switch result {
            case .success:
                print("Friendship removed successfully.")
                // Optionally, re-fetch user's friends list or other data
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }

    // Add a function to fetch a list of friends for the current user
}
