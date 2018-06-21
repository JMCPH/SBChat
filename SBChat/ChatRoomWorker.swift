//
//  ChatRoomWorker.swift
//  SBChat
//
//  Created by Jakob Mikkelsen on 6/20/18.
//  Copyright © 2018 SecondBook. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ChatRoomWorker {

    let chatRoomsRef = Database.database().reference().child("Chat").child("Rooms")


    // Fetch messages for ChatRoom with roomID
    public func fetchMessages(forRoomID roomID: String, withPagination page: Int, withCompletion completion: @escaping (_ exists:Bool, _ messages:[ChatMessage]?) -> Void)
    {
        // Fetch all messages within this roomID
        // --- TODO: Do it in pagination later on --
        chatRoomsRef.child(roomID).observeSingleEvent(of: .value, with: { (snapshot) in
            
        })

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
        chatRoomsRef.child(roomID).observeSingleEvent(of: .value, with: { (snapshot) in
            completion(snapshot.exists())
        })

    }

    /*
    /// Create ChatRoom with ID
    ///
    /// - Parameters:
    ///   - roomID: The id of the chatroom
    ///   - completion: boolean indicating if chatroom exists
    public func createChatRoom(withRoomID roomID: String, firstMessage: String, completion: @escaping (_ error: Error?, _ success: Bool) -> ()) {

        // Check if ChatRoom with an ID already exists
        chatRoomsRef.child(<#T##pathString: String##String#>).setValue(<#T##value: Any?##Any?#>) { (error, ref) in

            completion(completion)
        }

    } */

}
