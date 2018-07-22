//
//  Configuration.swift
//  SBChat
//
//  Created by Jakob Mikkelsen on 7/22/18.
//  Copyright © 2018 SecondBook. All rights reserved.
//

import FirebaseDatabase

struct Configuration {

    // - Reference for ChatRooms
    static let chatsRoomRef = Database.database().reference().child("chat_rooms")

    // - Reference for RecentMessages
    static let recentMessagesRef = Database.database().reference().child("chat_rooms").child("recentMessages")

}
