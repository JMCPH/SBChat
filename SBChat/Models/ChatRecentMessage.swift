//
//  ChatRecentMessage.swift
//  SBChat
//
//  Created by Jakob Mikkelsen on 7/22/18.
//  Copyright © 2018 SecondBook. All rights reserved.
//

import FirebaseDatabase

struct ChatRecentMessage {
    let userID: String
    let roomID: String
    let timestamp: String
    let latestMessage: String
    let latestSenderID: String
    let senderUsername: String
    let senderUserID: String
    let senderUserImageURL: String

    init(withSnapshotValue snapshotValue: [String: AnyObject]) {
        self.userID = snapshotValue["userID"] as! String
        self.roomID = snapshotValue["roomID"] as! String
        self.latestMessage = snapshotValue["latestMessage"] as! String
        self.latestSenderID = snapshotValue["latestSenderID"] as! String

        self.senderUsername = snapshotValue["senderUsername"] as! String
        self.senderUserID = snapshotValue["senderUserID"] as! String
        self.senderUserImageURL = snapshotValue["senderUserImageURL"] as! String

        let timestampDate = Date(timeIntervalSince1970: snapshotValue["timestamp"] as! Double / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        self.timestamp = dateFormatter.string(from: timestampDate)
    }

}
