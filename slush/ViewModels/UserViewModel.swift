// ViewModel: Acts as a bridge between the Model and the View. It holds the presentation logic and might transform the Model data into a format that can be easily displayed.
import SwiftUI
import Combine
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class UserViewModel: ObservableObject {
    @Published var userData: User?
    @Published var isAuthenticated: Bool = false
    @Published var isProfileSetupRequired: Bool = false
    // currently only used for searchForUser
    @Published var searchedUser: User?
    @Published var favoriteUsers: [User] = []
    @Published var friendsActivity: [Activity] = []
    @Published var loginError: String?
    @Published var messages: [Message] = []
    
    @Published var currentUserID: String?
    @Published var notifications: [Notification] = []
    
    private var notificationsListener: ListenerRegistration?
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Fetch the current user's ID from Firebase Authentication
        currentUserID = Auth.auth().currentUser?.uid
    }
    
    private var authService = AuthenticationService()
    private var firestoreService = FirestoreService()

// MARK: User Fetch/Search Functions
    
    private func fetchUserData(uid: String, completion: @escaping (Bool) -> Void) {
        firestoreService.fetchUser(withUID: uid) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.userData = user
                    completion(true)
                case .failure(let error):
                    print("Error occurred: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }


    
    func searchForUser(username: String) {
        firestoreService.getUserByUsername(username: username) { [weak self] result in
            switch result {
            case .success(let user):
                self?.searchedUser = user
            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
                self?.searchedUser = nil
            }
        }
    }
}

// MARK: Login/Signup Functions
extension UserViewModel {
    
    func login(username: String, password: String) {
        authService.signIn(email: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let authResult):
                    let uid = authResult.user.uid
                    self?.fetchUserData(uid: uid) { success in
                        if success {
                            self?.isAuthenticated = true
                        } else {
                            self?.loginError = "Failed to fetch user data."
                        }
                    }
                case .failure(let error):
                    self?.loginError = "Login failed: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func signUp(email: String, password: String, username: String, fullname: String, phone: String?, profilePicture: UIImage?, termsOfServiceAccepted: Bool, privacyPolicyAccepted: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        authService.signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let authResult):
                let uid = authResult.user.uid
                
                if let image = profilePicture {
                    self?.firestoreService.uploadProfileImage(image, for: uid) { uploadResult in
                        switch uploadResult {
                        case .success(let profilePictureURL):
                            if let userData = self?.createUserData(email: email, username: username, fullname: fullname, phone: phone, profilePictureURL: profilePictureURL, termsOfServiceAccepted: termsOfServiceAccepted, privacyPolicyAccepted: privacyPolicyAccepted) {
                                self?.firestoreService.saveUserProfileData(userId: uid, userData: userData, completion: completion)
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    let defaultProfilePictureURL = URL(string: "default_profile_picture_url") // Replace with your default URL
                    if let userData = self?.createUserData(email: email, username: username, fullname: fullname, phone: phone, profilePictureURL: defaultProfilePictureURL, termsOfServiceAccepted: termsOfServiceAccepted, privacyPolicyAccepted: privacyPolicyAccepted) {
                        self?.firestoreService.saveUserProfileData(userId: uid, userData: userData, completion: completion)
                    }
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }



    private func createUserData(email: String, username: String, fullname: String, phone: String?, profilePictureURL: URL?, termsOfServiceAccepted: Bool, privacyPolicyAccepted: Bool) -> [String: Any] {
        var userData: [String: Any] = [
            "email": email,
            "username": username,
            "fullname": fullname,  // Added fullname
            "termsOfServiceAccepted": termsOfServiceAccepted,
            "privacyPolicyAccepted": privacyPolicyAccepted,
            "joinedDate": Date(),
            "privacySettings": ["canBeSearched": true],
            "friends": [],
            "favoriteUserIDs": []
        ]

        if let phone = phone {
            userData["phone"] = phone
        }
        if let profilePictureURL = profilePictureURL {
            userData["profileImageUrl"] = profilePictureURL.absoluteString
        }

        return userData
    }






    // Additional methods for sign up, sign out, etc.
}

// MARK: Update Profile Functions
extension UserViewModel {
    
    func updateUserProfile(displayName: String?, birthdate: Date?, phone: String?, profilePicture: UIImage?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = self.userData?.id else {
            completion(.failure(MyError.noUserIDFound))
            return
        }
        
        var userDataToUpdate: [String: Any] = [:]
        
        // Add non-nil values to the userDataToUpdate dictionary
        if let displayName = displayName {
            userDataToUpdate["displayName"] = displayName
        }
        if let birthdate = birthdate {
            userDataToUpdate["birthdate"] = Timestamp(date: birthdate)
        }
        if let phone = phone {
            userDataToUpdate["phone"] = phone
        }
        
        if let image = profilePicture {
            // Upload the UIImage to Firebase Storage
            self.firestoreService.uploadProfileImage(image, for: uid) { [weak self] result in
                switch result {
                case .success(let imageURL):
                    userDataToUpdate["profileImageUrl"] = imageURL.absoluteString
                    self?.updateFirestoreUser(uid: uid, userData: userDataToUpdate, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            // If no new image is provided, just update the other details
            self.updateFirestoreUser(uid: uid, userData: userDataToUpdate, completion: completion)
        }
    }

    private func updateFirestoreUser(uid: String, userData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreService.saveUserProfileData(userId: uid, userData: userData) { result in
            switch result {
            case .success:
                print("Profile updated successfully.")
                completion(.success(()))
            case .failure(let error):
                print("Error updating profile: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    enum MyError: Error {
        case noUserIDFound
    }


}

// MARK: Friend Mgmnt Functions
extension UserViewModel {

    func addFriend(friendUID: String) {
        guard let currentUserID = self.userData?.id else { return }
        firestoreService.addFriend(uid: currentUserID, friendUID: friendUID) { result in
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
        firestoreService.removeFriend(uid: currentUserID, friendUID: friendUID) { result in
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
    
// MARK: Favorites Functions
    
    func fetchFavoriteUsers() {
        guard let currentUserID = self.userData?.id else { return }

        firestoreService.fetchFavoriteUserIDs(forUserID: currentUserID) { [weak self] result in
            switch result {
            case .success(let favoriteUserIDs):
                self?.loadFavoriteUsersDetails(userIDs: favoriteUserIDs)
            case .failure(let error):
                print("Error fetching favorite user IDs: \(error.localizedDescription)")
            }
        }
    }

    private func loadFavoriteUsersDetails(userIDs: [String]) {
        firestoreService.fetchUsers(byIDs: userIDs) { [weak self] result in
            switch result {
            case .success(let users):
                self?.favoriteUsers = users
            case .failure(let error):
                print("Error fetching favorite users: \(error.localizedDescription)")
            }
        }
    }

    
    func addFavoriteUser(favoriteUserID: String) {
        guard let currentUserID = self.userData?.id else { return }

        firestoreService.addFavoriteUser(currentUserID: currentUserID, favoriteUserID: favoriteUserID) { result in
            switch result {
            case .success:
                self.fetchFavoriteUsers()  // Refresh the favorite users list
            case .failure(let error):
                print("Error adding favorite user: \(error.localizedDescription)")
            }
        }
    }
    
    func removeFavoriteUser(favoriteUserID: String) {
        guard let currentUserID = self.userData?.id else { return }

        firestoreService.removeFavoriteUser(currentUserID: currentUserID, favoriteUserID: favoriteUserID) { result in
            switch result {
            case .success:
                self.fetchFavoriteUsers()  // Refresh the favorite users list
            case .failure(let error):
                print("Error removing favorite user: \(error.localizedDescription)")
            }
        }
    }

    
// MARK: Activity Functions
    
    func fetchFriendsActivity() {
        guard let currentUserID = self.userData?.id else { return }

        firestoreService.fetchFriendsActivity(forUserID: currentUserID) { [weak self] (result: Result<[Activity], Error>) in
            switch result {
            case .success(let activities):
                // Handle successful retrieval of activities
                self?.friendsActivity = activities
            case .failure(let error):
                // Handle failure, possibly set an error state or log the error
                print("Error fetching friends' activities: \(error.localizedDescription)")
            }
        }

    }
    
// MARK: Messaging
    
    func sendMessage(_ text: String, to receiverID: String, inConversation conversationID: String) {
        let message = Message(text: text, senderID: self.userData?.id ?? "", receiverID: receiverID, timestamp: Date())
        firestoreService.sendMessage(message, inConversation: conversationID) { result in
            switch result {
            case .success:
                print("Message sent successfully.")
            case .failure(let error):
                print("Error sending message: \(error.localizedDescription)")
            }
        }
    }

// MARK: Notifications
    
    func fetchNotifications() {
            guard let userID = Auth.auth().currentUser?.uid else { return }

        firestoreService.fetchNotifications(forUserID: userID) { [weak self] result in
            switch result {
            case .success(let fetchedNotifications):
                DispatchQueue.main.async {
                    self?.notifications = fetchedNotifications
                }
            case .failure(let error):
                // Handle any errors
                print("Error fetching notifications: \(error.localizedDescription)")
            }
        }
    }
    
}
