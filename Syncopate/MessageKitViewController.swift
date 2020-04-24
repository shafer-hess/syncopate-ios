//
//  MessageKitViewController.swift
//  Syncopate
//
//  Created by Shafer Hess on 4/8/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import Alamofire
import AlamofireImage
import InputBarAccessoryView
import MessageKit
import SocketIO
import UIKit

// MARK: - MessageKit Structs

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    var profileUrl: String?
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

class MessageKitViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {

    // Data passed from Chats Page
    var group: NSDictionary = [:]
    var groupId: Int = -1
    var currUser: NSDictionary = [:]
    
    // Array to hold formatted messages retrieved from database
    var messages: [MessageType] = []
    
    var defaultAvatar: UIImage = UIImage()

    // SocketIO Manager and Socket
    let manager = SocketManager(socketURL: URL(string: "http://18.219.112.140:3001")!, config: [])
    var socket: SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get Group ID
        groupId = group["group__id"] as! Int
        
        // Initialize MessageKit Collection View
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        
        messageInputBar.delegate = self
        
        messagesCollectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapView(_:))))
        
        getMessages(groupId: groupId)
        
        // Cache Default Profile Picture
        let urlRequest: String = "http://18.219.112.140/images/avatars/default.png"
        AF.request(urlRequest).responseImage { (response) in
            if case .success(let image) = response.result {
                self.defaultAvatar = image
            }
        }
        
        // SocketIO Setup
        socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { data, ack in
            print("socket connected")
        }
        
        socket.on("push to clients") { data, ack in
            self.receiveData(data: data)
        }
        
        socket.connect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        socket.emit("subscribeToRoom", String(groupId))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func onTapView(_ sender: Any) {
        self.messageInputBar.inputTextView.resignFirstResponder()
    }

    //MARK: -  MessagKit Protocol Stubs and Customization
    func currentSender() -> SenderType {
        // Retrieve current user information and establish as currentSender
        let userId: String = String(currUser["id"] as! Int)
        let username: String = (currUser["first_name"] as! String) + " " + (currUser["last_name"] as! String)
        
        return Sender(senderId: userId, displayName: username)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        let string = NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        
        // Check if message is not first message
        if(indexPath.section != 0) {
            // Check if previous message sender is the same as current message sender, add name if different
            let prev = messages[indexPath.section - 1]
            if(prev.sender.displayName != message.sender.displayName) {
                return string
            }
        } else {
            return string
        }
        
        return nil
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if(indexPath.section != 0) {
            let prev = messages[indexPath.section - 1]
            if(prev.sender.displayName != message.sender.displayName) {
                return 35
            }
        } else {
            return 35
        }
        
        return 0
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        //Check if avatar should be displayed -> Display at bottom of user's message chain
        if(indexPath.section < messages.count - 1) {
            if(message.sender.displayName == messages[indexPath.section + 1].sender.displayName) {
                avatarView.isHidden = true
                return
            }
        }
        
        avatarView.isHidden = false
        
        let msg = message as! Message
        if let url = msg.profileUrl {
            if(url == "default.png" || url == "18.219.112.140/images/avatars/default.png") {
                avatarView.image = defaultAvatar
            } else {
                AF.request(url).responseImage { (response) in
                    if case .success(let image) = response.result {
                        avatarView.image = image
                    }
                }
            }
        }
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let closure = { (view: MessageContainerView) in
           view.layer.cornerRadius = 15.0
            
            let currSender = self.currentSender()
            if(currSender.displayName == message.sender.displayName) {
                view.layer.backgroundColor = UIColor.systemBlue.cgColor
            } else {
                // Check system mode
                if(self.traitCollection.userInterfaceStyle == .dark) {
                    view.layer.backgroundColor = UIColor.darkGray.cgColor
                } else {
                    view.layer.backgroundColor = UIColor.lightGray.cgColor
                }
            }
        }
        return .custom(closure)
    }
    
    // MARK: - Helper Functions
    
    func randomString(length: Int) -> String {
      let letters = "0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
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
    
    // MARK: - MessageKit Functions
    
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
        let baseUrl: String = "http://18.219.112.140/images/avatars/"
        let imageUrl: String = baseUrl + (message["user__profile_pic_url"] as! String)
        
        let messageId = String(message["id"] as! Int)
        
        let kind: MessageKind
        if(message["rich_content"] as! Bool) {
            if let img: UIImage = makeImage(message: message) {
                let photo = PhotoMediaItem(image: img)
                kind = .photo(photo)
            } else {
                return nil
            }
            
        } else {

            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .left
            
            let attrs = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium)
            ]
            
            let attrStr = NSAttributedString(string: message["content"] as! String, attributes: attrs)
            kind = .attributedText(attrStr)
            // kind = .text(message["content"] as! String)
        }
        
        return Message(sender: sender, messageId: messageId, sentDate: Date(), kind: kind, profileUrl: imageUrl)
    }
    
    // MARK: - Functions to Receive and Send Data
    
    func receiveData(data: Any) {
        // Retrieve Message Content
        let message = data as! NSArray
        let messageContent = message[0] as! NSDictionary
        let user = messageContent["user"] as! NSDictionary
        
        var profileUrl: String = user["profile_pic_url"] as! String
        
        let split: [String]
        if(profileUrl.contains("http://18.219.112.140/images/avatars/")) {
            split = profileUrl.components(separatedBy: "http://18.219.112.140/images/avatars/")
            profileUrl = split[1]
        }
        
        // Create MessageKit Message From Received Socket Data
        let newMessage = [
            "id": Int(randomString(length: 10)),
            "user": user["id"],
            "rich_content": messageContent["rich_content"],
            "content": messageContent["content"],
            "user__first_name": user["first_name"],
            "user__last_name": user["last_name"],
            "user__profile_pic_url": profileUrl
        ]
        
        // Try to create MessageType entry
        let sender = makeSender(message: newMessage as NSDictionary)
        if let entry = makeMessage(sender: sender, message: newMessage as NSDictionary) {
            self.messages.append(entry)
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        // Format Message for MessageKit
        var profileUrl: String = currUser["profile_pic_url"] as! String
        
        let split: [String]
        if(profileUrl.contains("http://18.219.112.140/images/avatars/")) {
            split = profileUrl.components(separatedBy: "http://18.219.112.140/images/avatars/")
            profileUrl = split[1]
        }
        
        let newMessage = [
            "id": Int(randomString(length: 10)) as Any,
            "group_id": groupId,
            "rich_content": false,
            "content": text,
            "message": text,
            "user__first_name": currUser["first_name"] as! String,
            "user__last_name": currUser["last_name"] as! String,
            "user__profile_pic_url": profileUrl,
            "profile_pic_url": profileUrl,
            "user": [ "id": currUser["id"],
                           "profile_pic_url": profileUrl,
                           "first_name": currUser["first_name"] as! String,
                           "last_name": currUser["last_name"] as! String
                        ]
            ] as [String : Any]
  
        inputBar.inputTextView.text = nil
        socket.emit("new message", newMessage)
    }
    
    // MARK: - Keyboard View Insets
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        if(messagesCollectionView.contentInset.bottom == 0) {
            messagesCollectionView.contentInset.bottom = messageInputBar.frame.height
            messagesCollectionView.verticalScrollIndicatorInsets.bottom = messageInputBar.frame.height
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        if(messagesCollectionView.contentInset.bottom != 0) {
           messagesCollectionView.contentInset.bottom = 0
            messagesCollectionView.verticalScrollIndicatorInsets.bottom = 0
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        inputAccessoryView?.endEditing(true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get chat settings view conytroller
        let chatSettings = segue.destination as! ChatDetailsViewController
        
        // Set chatSettings variables
        chatSettings.groupId = self.groupId
        chatSettings.group = self.group
    }
}
