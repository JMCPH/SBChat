//
//  FirebaseDriver.swift
//  SBChat
//
//  Created by Jakob Mikkelsen on 5/25/18.
//  Copyright © 2018 SecondBook. All rights reserved.
//

import UIKit
import MessageKit
import FirebaseDatabase

class FirebaseDriver {

    var chatRoomsRef = Database.database().reference().child("chat").child("rooms")
    var chatRecentsRef = Database.database().reference().child("chat").child("recentMessages")

    public func fetchChatConversationsForUserID(userID: String, onSucces: @escaping ([ChatRoom]) -> Void, onError: Error?) {

        chatRoomsRef.queryStarting(atValue: userID).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.children.allObjects)
        }

        chatRoomsRef.queryEnding(atValue: userID).observeSingleEvent(of: .value) { (snapshot) in
            print(snapshot.children.allObjects)
        }

    }

    /*
    public func createChatRoom(withUserIDs userIDs: [String], withMessage message: ChatMessage, completion: @escaping (_ success: Error?) -> Void) {

        let chatRoomData = ["members": userIDs,
                            "lastMessage": message,
                            "lastMessageSent": message.sentDate.timeIntervalSince1970] as [String : Any]

        // Send chat room to firebase
        chatRoomsRef.childByAutoId().updateChildValues(chatRoomData) { (error, ref) in
            completion(error)
        }
    } */
    
    public func sendMessage(message: ChatMessage, forChatRoom chatRoom: ChatRoom, completion: @escaping (_ error: Error?) -> Void) {

        switch message.kind {

            case .text(let value):

                // 1. Send Message
                let messageValue = [
                                    "senderName" : message.sender.displayName,
                                    "senderID" : message.sender.id,
                                    "timestamp": message.sentDate.timeIntervalSince1970,
                                    "type" : "text",
                                    "value" : value] as [String : Any]
                chatRoomsRef.child(chatRoom.id).childByAutoId().setValue(messageValue) { [weak self] (error, ref) in
                    if let err = error {
                        completion(err)
                        return
                    }

                    // 2. Update the recentMessages for ALL members of the chat
                    self?.updateRecentMessages(forChatRoom: chatRoom, messageText: value, senderID: message.sender.id)

                    // 3. Send out push notifications to everyone
                }

        default:
            debugPrint("Not supporting this type of message yet")
        }

    }

    fileprivate func updateRecentMessages(forChatRoom chatRoom: ChatRoom, messageText: String, senderID: String) {

        for user in chatRoom.users {

            guard let otherUser = chatRoom.users.first(where: { $0.id != user.id }) else { return }

            // Update the recentMessage
            let latestMessage = ["timestamp": ServerValue.timestamp() as Any,
                                 "latestMessage" : messageText,
                                 "lastSenderID": senderID,
                                 "userID": user.id,
                                 "roomID": chatRoom.id,
                                 "otherUsername": otherUser.name,
                                 "otherUserID": otherUser.id,
                                 "otherUserImageURL": otherUser.imageURL] as [String : Any]

            chatRecentsRef.queryOrdered(byChild: "userID").queryEqual(toValue: user.id).observeSingleEvent(of: .value) { [weak self] (snapshot) in

                if let childValue = snapshot.value as? [String: Any], let path = childValue.keys.first {
                    self?.chatRecentsRef.child(path).updateChildValues(latestMessage, withCompletionBlock: { (error, ref) in

                    })
                } else {
                    self?.chatRecentsRef.childByAutoId().updateChildValues(latestMessage, withCompletionBlock: { (error, ref) in
                        ref.updateChildValues(["recentID" : ref.key])
                    })
                }

            }
        }
    }

}
