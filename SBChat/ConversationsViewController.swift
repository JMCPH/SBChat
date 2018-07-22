//
//  ConversationsViewController.swift
//  SBChat
//
//  Created by Jakob Mikkelsen on 5/25/18.
//  Copyright © 2018 SecondBook. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ConversationsViewController: UITableViewController {

    let worker = ConversationsWorker()
    var recentMessages: [ChatRecentMessage]?
    var currentUser: ChatUser = ChatUser(withID: "1", name: "1", imageURL: "https://blognumbers.files.wordpress.com/2010/09/\(1).jpg")
    var allUserIDs = ["1", "2", "3", "4", "5"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add new room and change user ID
        self.navigationItem.setLeftBarButton(UIBarButtonItem(title:"New chat", style:.plain, target:self, action: #selector(startNewChat)),
                                             animated: false)
        self.navigationItem.setRightBarButton(UIBarButtonItem(title:"Change user", style:.plain, target:self, action: #selector(changeUserID)),
                                             animated: false)
        self.title = "User: \(currentUser.id)"

        // TableView Design
        tableView.register(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .none

        fetchRecentMessages(forUserID: currentUser.id)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchRecentMessages(forUserID: currentUser.id)
    }

    // Change ID of the current user
    @objc fileprivate func changeUserID() {

        let alert = UIAlertController(title: "Select userID to be used", message: nil, preferredStyle: .actionSheet)
        for userID in allUserIDs {
            let action = UIAlertAction(title: userID, style: .default) { [weak self] (action) in
                guard let selectedUserID = action.title else { return }
                self?.currentUser = ChatUser(withID: selectedUserID, name: selectedUserID, imageURL: "https://blognumbers.files.wordpress.com/2010/09/\(selectedUserID).jpg")
                self?.title = "User: \(selectedUserID)"
                self?.fetchRecentMessages(forUserID: selectedUserID)
            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "cancel", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)

    }

    // Start a new chat room
    @objc fileprivate func startNewChat() {

        let alert = UIAlertController(title: "Select user to start chat with", message: nil, preferredStyle: .actionSheet)
        for userID in allUserIDs {

            let action = UIAlertAction(title: userID, style: .default) { [weak self] (action) in
                guard let selectedUserID = action.title else { return }
                guard let currentUserID = self?.currentUser.id else { return }
                guard currentUserID != selectedUserID else { return }

                // Generate the ChatRoomID for the two users
                guard let chatRoomID = self?.worker.generateChatRoomID(withUserID: selectedUserID, currentUserID: currentUserID) else {
                    debugPrint("Error - Can't chat with the same user!")
                    return
                }

                // Open the ChatRoomVC with roomID
                DispatchQueue.main(delay: 0.0, main: {
                    if let strongSelf = self {
                        let users = [strongSelf.currentUser,
                                     ChatUser(withID: selectedUserID, name: selectedUserID, imageURL: "https://blognumbers.files.wordpress.com/2010/09/\(selectedUserID).jpg")]
                        let chatRoom = ChatRoom(withID: chatRoomID, users: users)
                        strongSelf.openChatRoom(withID: chatRoom)

                    }
                }, completion: nil)

            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "cancel", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)

    }

    fileprivate func openChatRoom(withID chatRoom: ChatRoom) {
        debugPrint("Open a ChatViewController with RoomID: \(chatRoom.id)")
        let chatVC = ChatViewController(withRoom: chatRoom, currentUserID: currentUser.id)
        self.navigationController?.pushViewController(chatVC, animated: true)
    }

    fileprivate func fetchRecentMessages(forUserID userID: String) {

        // Fetch conversations from this userID
        worker.fetchRecentMessages(forUserID: userID) { (recentMessages)  in
            self.recentMessages = recentMessages
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentMessages?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConversationTableViewCell

        // Configure the cell...
        guard let recentMessage = recentMessages?[indexPath.row] else { return cell }
        cell.usernameLabel.text = "UserID: " + recentMessage.senderUsername
        cell.messageLabel.text = recentMessage.latestMessage
        cell.timeLabel.text = recentMessage.timestamp

        // Load image from URL - round corners
        guard let imageURL = URL(string: recentMessage.senderUserImageURL) else { return cell }
        cell.userImageView.downloadedFrom(url: imageURL)
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.height / 2
        cell.userImageView.clipsToBounds = true

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        // Open the ChatRoomVC with roomID and users
        if let recentMessage = recentMessages?[indexPath.row] {
            let users = [currentUser, ChatUser(withID: recentMessage.senderUserID, name: recentMessage.senderUsername, imageURL: recentMessage.senderUserImageURL)]
            let chatRoom = ChatRoom(withID: recentMessage.roomID, users: users)
            self.openChatRoom(withID: chatRoom)
        }

    }

}
