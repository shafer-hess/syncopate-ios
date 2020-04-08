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

struct PhotoMediaItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage?) {
        self.image = image
        self.size = CGSize(width: image!.size.width, height: image!.size.height)
        self.placeholderImage = UIImage()
    }
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
                                let sender = self.makeSender(message: message)
                                                                
                                // Create MessageType Struct from Message Content
                                if let entry = self.makeMessage(sender: sender, message: message) {
                                    self.messages.append(entry)
                                    self.messagesCollectionView.reloadData()
                                    self.messagesCollectionView.scrollToBottom()
                                }
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
    
    func makeImage(message: NSDictionary) -> UIImage? {
        // Retrieve Base64 Encoded Image
        let base64str: String? = message["content"] as? String
        
        var returnImage: UIImage? = nil
        if let data = base64str {
            let temp = data.components(separatedBy: ",")
            
            var decoded: Data
            if(temp.count == 1) {
                decoded = Data(base64Encoded: temp[0], options: .ignoreUnknownCharacters)!
            } else {
                if let data = Data(base64Encoded: temp[1], options: .ignoreUnknownCharacters) {
                    decoded = data
                } else {
                    return nil
                }
            }
            
            returnImage = UIImage(data: decoded)
        }
        
        return returnImage
    }
    
    func makeSender(message: NSDictionary) -> Sender {
        let senderId = String(message["user"] as! Int)
        let displayName = (message["user__first_name"] as! String) + " " + (message["user__last_name"] as! String)
        
        return Sender(senderId: senderId, displayName: displayName)
    }
    
    func makeMessage(sender: Sender, message: NSDictionary) -> Message? {
        let messageId = String(message["id"] as! Int)
       
        let kind: MessageKind
        if(message["rich_content"] as! Bool) {
            //if let photo: PhotoMediaItem = PhotoMediaItem(image: makeImage(message: message)) {
            if let img: UIImage = makeImage(message: message) {
                let photo = PhotoMediaItem(image: img)
                kind = .photo(photo)
            } else {
                // kind = .attributedText(NSAttributedString(string: "There was an error loading this image"))
                return nil
            }
            
        } else {
            let attrStr = NSAttributedString(string: message["content"] as! String)
            kind = .attributedText(attrStr)
        }
        
        return Message(sender: sender, messageId: messageId, sentDate: Date(), kind: kind)
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
