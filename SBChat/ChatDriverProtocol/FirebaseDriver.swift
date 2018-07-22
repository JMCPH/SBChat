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

    public func fetchRecentMessages(forUserID userID: String, onCompletion: @escaping (_ recentMessages: [ChatRecentMessage]) -> Void) {

        Configuration.recentMessagesRef.queryOrdered(byChild: "userID").queryEqual(toValue: userID).observeSingleEvent(of: .value) { (snapshot) in

            var recentMessages = [ChatRecentMessage]()
            for child in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                if let value = child.value as? [String: AnyObject] {
                    let recentMessage = ChatRecentMessage(withSnapshotValue: value)
                    recentMessages.append(recentMessage)
                }
            }

            onCompletion(recentMessages)

        }

    }

    public func fetchMessages(forChatRoom chatRoom: ChatRoom, completion: @escaping (_ messages: [ChatMessage]) -> Void) {

        Configuration.chatsRoomRef.child(chatRoom.id).queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value) { (snapshot) in

            var messages = [ChatMessage]()
            for child in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                if let snapshotValue = child.value as? [String: AnyObject] {

                    let chatMessage = ChatMessage(text: snapshotValue["value"] as! String, sender: Sender(id: snapshotValue["senderID"] as! String, displayName: snapshotValue["senderName"] as! String), messageId: child.key, date: Date(timeIntervalSince1970: snapshotValue["timestamp"] as! Double / 1000))

                    messages.append(chatMessage)
                }
            }
            completion(messages)
        }

    }

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
                Configuration.chatsRoomRef.child(chatRoom.id).childByAutoId().setValue(messageValue) { [weak self] (error, ref) in
                    if let err = error {
                        completion(err)
                        return
                    }

                    // 2. Update the recentMessages for ALL members of the chat
                    self?.updateRecentMessages(forChatRoom: chatRoom, messageText: value, senderID: message.sender.id)

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
                                 "latestSenderID": senderID,
                                 "userID": user.id,
                                 "roomID": chatRoom.id,
                                 "userID_roomID": user.id+chatRoom.id,
                                 "senderUsername": otherUser.name,
                                 "senderUserID": otherUser.id,
                                 "senderUserImageURL": otherUser.imageURL] as [String : Any]

            Configuration.recentMessagesRef.queryOrdered(byChild: "userID_roomID").queryEqual(toValue: user.id+chatRoom.id).observeSingleEvent(of: .value) { (snapshot) in

                // If already existing - use the path
                if let childValue = snapshot.value as? [String: Any], let path = childValue.keys.first {
                    Configuration.recentMessagesRef.child(path).updateChildValues(latestMessage, withCompletionBlock: { (error, ref) in

                    })
                }

                // Else use the childByAutoId() path
                else {
                    Configuration.recentMessagesRef.childByAutoId().updateChildValues(latestMessage, withCompletionBlock: { (error, ref) in

                    })
                }

            }
        }
    }

}
