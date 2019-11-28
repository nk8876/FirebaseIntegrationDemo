//
//  ChatModel.swift
//  FirebaseIntegrationDemo
//
//  Created by Dheeraj Arora on 18/11/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import Foundation

class ChatModel  {
    var name: String?
    var text: String?
    var profileImage: String?
    
    init(name: String, text: String, profileImageUrl: String) {
        self.name = name
        self.text = text
        self.profileImage = profileImageUrl
    }
}
