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
