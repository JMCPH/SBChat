//
//  ChatConversation.swift
//  SBChat
//
//  Created by Jakob Mikkelsen on 5/25/18.
//  Copyright © 2018 SecondBook. All rights reserved.
//

import UIKit

struct ChatRoom {
    let id: String
    let users:[ChatUser]

    init(withID id: String, users: [ChatUser]) {
        self.id = id
        self.users = users
    }
}
