//
//  ChatUser.swift
//  SBChat
//
//  Created by Jakob Mikkelsen on 7/18/18.
//  Copyright © 2018 SecondBook. All rights reserved.
//

import UIKit

struct ChatUser {

    let id: String
    let name: String
    let imageURL: String

    init(withID id: String, name: String, imageURL: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
    }

}
