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

    let chatRoomWorker = ChatRoomWorker()
    var currentUserID: String = "1"
    var allUserIDs = ["1", "2", "3", "4", "5"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add new room and change user ID
        self.navigationItem.setLeftBarButton(UIBarButtonItem(title:"New chat", style:.plain, target:self, action: #selector(startNewChat)),
                                             animated: false)
        self.navigationItem.setRightBarButton(UIBarButtonItem(title:"Change user", style:.plain, target:self, action: #selector(changeUserID)),
                                             animated: false)
        self.title = "User: \(currentUserID)"

        // TableView Design
        tableView.tableFooterView = UIView(frame: .zero)
        clearsSelectionOnViewWillAppear = false

        // Fetch conversations for userID
        fetchConversations(forUserID: currentUserID)
        
    }

    // Change ID of the current user
    @objc fileprivate func changeUserID() {

        let alert = UIAlertController(title: "Select userID to be used", message: nil, preferredStyle: .actionSheet)
        for userID in allUserIDs {
            let action = UIAlertAction(title: userID, style: .default) { [weak self] (action) in
                guard let selectedUserID = action.title else { return }
                self?.currentUserID =  selectedUserID
                self?.title = "User: \(selectedUserID)"
                self?.fetchConversations(forUserID: selectedUserID)
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
                guard let currentUserID = self?.currentUserID else { return }
                guard currentUserID != selectedUserID else { return }

                // Generate the ChatRoomID for the two users
                guard let chatRoomID = self?.chatRoomWorker.generateChatRoomID(withUserID: selectedUserID, currentUserID: currentUserID) else {
                    assert(true)
                    return
                }

                // Open a ChatViewController with this roomID

            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "cancel", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)

    }

    fileprivate func createChatRoom(withID roomID: String, openChatAfter: Bool) {

        self.chatRoomWorker

    }

    fileprivate func fetchConversations(forUserID userID: String) {

        // Loading conversations from this userID
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
