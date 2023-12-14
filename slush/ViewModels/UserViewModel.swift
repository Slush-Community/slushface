// ViewModel: Acts as a bridge between the Model and the View. It holds the presentation logic and might transform the Model data into a format that can be easily displayed.
import SwiftUI
import Combine
import FirebaseStorage

class UserViewModel: ObservableObject {
    @Published var userData: User?
    @Published var isAuthenticated: Bool = false
    @Published var isProfileSetupRequired: Bool = false
    // currently only used for searchForUser
    @Published var searchedUser: User?
    @Published var favoriteUsers: [User] = []
    @Published var friendsActivity: [Activity] = []
    
    private var authService = AuthenticationService()
    private var firestoreService = FirestoreService()
    
    private func fetchUserData(uid: String) {
        firestoreService.fetchUser(withUID: uid) { [weak self] result in
            switch result {
                case .success(let user):
                    // Here 'user' is the User object returned from fetchUser
                    self?.userData = user
                case .failure(let error):
                    print("Error occurred: \(error.localizedDescription)")
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

// MARK: Login ViewModel Operations
extension UserViewModel {
    
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
    
    func signUp(email: String, password: String, username: String, phone: String, profilePicture: UIImage?) {
        authService.signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let authResult):
                print("User signed up successfully.")
                let uid = authResult.user.uid
                
                // Check if a profile picture is provided
                if let image = profilePicture, let imageData = image.jpegData(compressionQuality: 0.8) {
                    // Upload to Firebase Storage
                    let storageRef = Storage.storage().reference().child("profile_pictures/\(uid).jpg")
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpeg"

                    storageRef.putData(imageData, metadata: metadata) { result in
                        switch result {
                        case .success(_):
                            // Fetch the download URL of the uploaded image
                            storageRef.downloadURL { result in
                                switch result {
                                case .success(let downloadURL):
                                    // Save the user profile data to Firestore
                                    self?.firestoreService.saveUserProfileData(userId: uid, email: email, username: username, phone: phone, profilePicture: downloadURL) { firestoreResult in
                                        switch firestoreResult {
                                        case .success:
                                            print("User data added to Firestore successfully.")
                                            // Create the User object and assign to userData
                                            self?.userData = User(id: uid, email: email, username: username, phone: phone, profileImageUrl: downloadURL.absoluteString, friends: [], favoriteUserIDs: [])
                                        case .failure(let error):
                                            print("Failed to add user data to Firestore: \(error.localizedDescription)")
                                        }
                                    }
                                case .failure(let error):
                                    print("An error occurred:", error)
                                }
                            }
                        case .failure(let error):
                            print("Failed to upload image to Firebase Storage:", error)
                        }
                    }
                } else {
                    // No profile picture provided, save other user data to Firestore
                    self?.firestoreService.saveUserProfileData(userId: uid, email: email, username: username, phone: phone, profilePicture: URL(string: "default_url")!) { firestoreResult in
                        switch firestoreResult {
                        case .success:
                            print("User data added to Firestore successfully.")
                            // Create the User object with a default or placeholder URL and assign to userData
                            self?.userData = User(id: uid, email: email, username: username, phone: phone, profileImageUrl: "default_url", friends: [], favoriteUserIDs: [])
                        case .failure(let error):
                            print("Failed to add user data to Firestore: \(error.localizedDescription)")
                        }
                    }
                }

            case .failure(let error):
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }



    // Additional methods for sign up, sign out, etc.
}

// MARK: Profile Update ViewModel Operations
extension UserViewModel {
    
    func updateUserProfile(email: String, password: String, username: String, phone: String, profilePicture: UIImage?) {
        guard let uid = self.userData?.id else {
            print("No user ID found.")
            return
        }
        
        if let image = profilePicture {
            // Step 1: Upload the UIImage to Firebase Storage
            firestoreService.uploadProfileImage(image, for: uid) { result in
                switch result {
                case .success(let imageURL):
                    // Step 2: Receive the download URL from Firebase Storage
                    
                    // Step 3: Pass this download URL to saveUserProfileData
                    self.firestoreService.saveUserProfileData(userId: uid, email: email, username: username, phone: phone, profilePicture: imageURL) { result in
                        switch result {
                        case .success:
                            print("Profile data saved successfully.")
                        case .failure(let error):
                            print("Error saving profile data: \(error.localizedDescription)")
                        }
                    }
                    
                case .failure(let error):
                    print("Failed to upload profile image: \(error.localizedDescription)")
                }
            }
        } else {
            // If no image is provided, just save other details
            if let profilePictureURL = URL(string: "https://example.com/path/to/image.jpg") {
                firestoreService.saveUserProfileData(userId: uid, email: email, username: username, phone: phone, profilePicture: profilePictureURL) { result in
                    switch result {
                    case .success:
                        print("Profile data saved successfully.")
                    case .failure(let error):
                        print("Error saving profile data: \(error.localizedDescription)")
                    }
                }

            }
        }
    }

}

// MARK: Friends ViewModel Operations
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

    
    func fetchFriendsActivity() {
        guard let currentUserID = self.userData?.id else { return }

        firestoreService.fetchFriendsActivity(forUserID: currentUserID) { [weak self] result in
            switch result {
            case .success(let activities):
                self?.friendsActivity = activities
            case .failure(let error):
                print("Error fetching friends' activities: \(error.localizedDescription)")
            }
        }
    }

    
}
