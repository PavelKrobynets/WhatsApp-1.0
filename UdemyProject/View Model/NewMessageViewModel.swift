//
//  NewMessageViewModel.swift
//  UdemyProject
//
//  Created by mac on 20.09.2021.
//

import SwiftUI
import Firebase  

class NewMessageViewModel : ObservableObject{
    @Published var users = [User]()
    
    init() {
        fetchUser()
    }
    func fetchUser(){
        COLLECTION_USERS.getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.users = documents.compactMap({try? $0.data(as: User.self)}).filter({
                $0.id != AuthViewModel.shared.userSession?.uid  })
            }
        }
    }

