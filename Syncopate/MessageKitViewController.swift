//
//  MessageKitViewController.swift
//  Syncopate
//
//  Created by Shafer Hess on 4/8/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import Alamofire
import MessageKit
import UIKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class MessageKitViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    var messages: [MessageType] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize MessageKit Collection View
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        getMessages(groupId: 39)
    }

    // MessagKit Required Protocol Stubs
    func currentSender() -> SenderType {
        let userId: String = "18"
        let username: String = "Shafer Hess"
        
        return Sender(senderId: userId, displayName: username)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    // HHTP Request to Retrieve Messages and populate messages array
    func getMessages(groupId: Int) {
        // Request Variables
        let url = "http://18.219.112.140:8000/api/v1/get-messages/"
        let params: [String:Any] = [
            "group_id": groupId
        ]
        
        // Get-Messages Request
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        if(data["status"] as! String == "success") {
                            
                            let retrievedMessages: NSArray = data["messages"] as! NSArray
                            
                            for entry in retrievedMessages {
                                let message = entry as! NSDictionary
                                
                                // Create Sender Struct from Message Content
                                let senderId = String(message["user"] as! Int)
                                let displayName = (message["user__first_name"] as! String) + " " + (message["user__last_name"] as! String)
                                let sender = Sender(senderId: senderId, displayName: displayName)
                                
                                // Create MessageType Struct from Message Content
                                let messageId = String(message["id"] as! Int)
                                let kind: MessageKind
                                if(message["rich_content"] as! Bool) {
                                    kind = .text("Photo")
                                } else {
                                    kind = .text(message["content"] as! String)
                                }
                                
                                let entry = Message(sender: sender, messageId: messageId, sentDate: Date(), kind: kind)
                                self.messages.append(entry)
                                self.messagesCollectionView.reloadData()
                            }
                                                        
                        } else {
                            print("Error retrieving messages")
                        }
                    }
                
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
