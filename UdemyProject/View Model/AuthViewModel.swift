//
//  AuthViewModel.swift
//  UdemyProject
//
//  Created by mac on 08.09.2021.
//

import Firebase
import UIKit
import CloudKit

class AuthViewModel: NSObject , ObservableObject {
    @Published var didAuthenticateUser = false
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser : User?
    private var tempCurrentUser: FirebaseAuth.User?

    
    static let shared = AuthViewModel()
    
    override init (){
        super.init()
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    func login(withEmail email: String, password: String){
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error{
                print("DEBUG: Failed login with error \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else { return }
            self.userSession = user
            
            self.fetchUser()
        }
    }
    
    
    func register (withEmail email: String , username: String, fullname: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: failed register with error \(error.localizedDescription )")
                return
            }
            guard let user = result?.user else { return }
            
            let data:[String: Any] = ["email": email,
                                      "username": username,
                                      "fullname": fullname]
            COLLECTION_USERS.document(user.uid).setData(data) { _ in
                self.tempCurrentUser = user
                self.didAuthenticateUser = true
            }
        }
    }
    func addStatus(_ status : String){
        guard let uid = tempCurrentUser?.uid else { return }
        COLLECTION_USERS.document(uid).setData(["status" : status])
        print("status cucesfuly uploaded to firestore")
        
    }

    
    
    func uploadProfileImage(_ image: UIImage){
        guard let uid = tempCurrentUser?.uid else { return }
        ImageUploader.uploadImage(image: image) { imageUrl in
            COLLECTION_USERS.document(uid).updateData(["profileImageUrl" : imageUrl]) { _ in
                self.userSession = self.tempCurrentUser
            }
        }
    }
    func updateImage(_ image: UIImage){
        guard let uid = tempCurrentUser?.uid else { return }
        ImageUploader.uploadImage(image: image) { imageUrl in
            COLLECTION_USERS.document(uid).setData(["profileImage" : imageUrl])
        }
    }
    
    func logout(){
        self.userSession = nil
        try? Auth.auth().signOut()
    }
    
    func fetchUser(){
        guard let uid = userSession?.uid else { return }
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
            guard let user = try? snapshot?.data(as: User.self) else { return }
            self.currentUser = user
        }
    }
}

