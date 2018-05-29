//
//  FirebaseDriver.swift
//  SBChat
//
//  Created by Jakob Mikkelsen on 5/25/18.
//  Copyright © 2018 SecondBook. All rights reserved.
//

import UIKit
import FirebaseDatabase

class FirebaseDriver {

    var chatRoomsRef = Database.database().reference().child("Chat").child("Rooms")
    var chatMessagesRef = Database.database().reference().child("Chat").child("Messages")

    public func fetchChatConversationsForUserID(userID: String, onSucces: @escaping ([ChatConversation]) -> Void, onError: Error?) {

    }

    public func createChatRoom(withUserIDs userIDs: [String], withMessage message: ChatMessage, completion: @escaping (_ success: Error?) -> Void) {

        let chatRoomData = ["members": userIDs,
                            "lastMessage": message,
                            "lastMessageSent": message.sentDate.timeIntervalSince1970] as [String : Any]

        // Send chat room to firebase
        chatRoomsRef.childByAutoId().updateChildValues(chatRoomData) { (error, ref) in


            completion(error)
        }
    }

    public func createMessage(withMessage message: ChatMessage, forRoomID roomID: String, completion: @escaping (_ success: Error?) -> Void) {

        /*

        chatMessagesRef.childByAutoId().setValue(<#T##value: Any?##Any?#>, withCompletionBlock: <#T##(Error?, DatabaseReference) -> Void#>)
        Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                let data = snapshot.value as! [String: String]
                let location = data["location"]!
                Database.database().reference().child("conversations").child(location).childByAutoId().setValue(withValues, withCompletionBlock: { (error, _) in
                    if error == nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                })
            } else {
                Database.database().reference().child("conversations").childByAutoId().childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in
                    let data = ["location": reference.parent!.key]
                    Database.database().reference().child("users").child(currentUserID).child("conversations").child(toID).updateChildValues(data)
                    Database.database().reference().child("users").child(toID).child("conversations").child(currentUserID).updateChildValues(data)
                    completion(true)
                })
            }
        })

        // Send to firebase
        chatRef.childByAutoId().updateChildValues(chatRoomData) { (error, ref) in


            completion(error)
        }

         */
    }

}
