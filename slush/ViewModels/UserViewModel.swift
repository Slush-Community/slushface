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

// MARK: Friends ViewModel Operations
extension UserViewModel {

    func addFriend(friendUID: String) {
        guard let currentUserID = self.userData?.id else { return }
        firestoreService.addFriend(userUID: currentUserID, friendUID: friendUID) { result in
            switch result {
            case .success:
                print("Friend added successfully.")
                // Optionally, you can update the userData object to include the new friend's UID without having to fetch the entire user data again:
                if self.userData?.friends.contains(friendUID) == false {
                    self.userData?.friends.append(friendUID)
                }
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }

    func removeFriend(friendUID: String) {
        guard let currentUserID = self.userData?.id else { return }
        firestoreService.removeFriend(userUID: currentUserID, friendUID: friendUID) { result in
            switch result {
            case .success:
                print("Friend removed successfully.")
                // Again, optionally, you can update the userData object to remove the friend's UID without having to fetch the entire user data again:
                if let index = self.userData?.friends.firstIndex(of: friendUID) {
                    self.userData?.friends.remove(at: index)
                }
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }
}
