//
//  ChatRoomWorker.swift
//  SBChat
//
//  Created by Jakob Mikkelsen on 6/20/18.
//  Copyright © 2018 SecondBook. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ConversationsWorker {

    let currentDriver = FirebaseDriver()

    // Fetch messages for ChatRoom with roomID
    public func fetchRecentMessages(forUserID userID: String, withCompletion completion: @escaping (_ recentMessages:[ChatRecentMessage]?) -> Void)    {
        currentDriver.fetchRecentMessages(forUserID: userID) { (recentMessages) in
            // Sort as the newest messages appears first
            completion(recentMessages.sorted(by: { $0.timestamp > $1.timestamp }))
        }

    }

    /// Generate a ChatRoomID
    /// We will be ordering userIDs 'lexicographically' in the compound key globally
    ///
    /// - Parameters:
    ///   - userID: The user ID we want to generate a chatroom with
    ///   - currentUserID: The user ID of the current user who wants to start a chatroom
    /// - Returns: string of the chatroom id
    public func generateChatRoomID(withUserID userID: String, currentUserID: String) -> String? {
        var chatRoomID: String?
        if currentUserID.lexicographicallyPrecedes(userID) {
            chatRoomID = currentUserID + "_" + userID
        } else {
            chatRoomID = userID + "_" + currentUserID
        }
        return chatRoomID
    }

    /// Detect if ChatRoom already exists
    ///
    /// - Parameters:
    ///   - roomID: The id of the chatroom
    ///   - completion: boolean indicating if chatroom exists
    public func isChatRoomValid(withRoomID roomID: String, completion: @escaping (Bool) -> ()) {

        // Check if ChatRoom with an ID already exists
        Configuration.chatsRoomRef.child(roomID).observeSingleEvent(of: .value, with: { (snapshot) in
            completion(snapshot.exists())
        })

    }

}
