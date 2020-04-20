//
//  FriendsViewController.swift
//  Syncopate
//
//  Created by Shafer Hess on 4/7/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

var cellCount: Int = -1
// MARK: - Badge Notification

extension CAShapeLayer {
    public func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

private var handle: UInt8 = 0;

extension UIBarButtonItem {
    
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        badgeLayer?.removeFromSuperlayer()
        
        var badgeWidth = 8
        var numberOffset = 4
        
        if number > 9 {
            badgeWidth = 12
            numberOffset = 6
        }
        
        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(7)
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = "\(number)"
        label.alignmentMode = CATextLayerAlignmentMode.center
        label.fontSize = 11
        label.frame = CGRect(origin: CGPoint(x: location.x - CGFloat(numberOffset), y: offset.y), size: CGSize(width: badgeWidth, height: 16))
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func removeBadge() {
         badgeLayer?.removeFromSuperlayer()
     }
}

// MARK: - End Badge Notification

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // Outlets
    @IBOutlet weak var addFriendButton: UIBarButtonItem!
    @IBOutlet weak var friendsTableView: UITableView!
    var friends: NSArray = []
    var friendRequests: NSArray = []
    
    @IBOutlet weak var notificationButton: UIBarButtonItem!
    
    @IBAction func addFriendActionButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controller = false
        getIncomingRequest()
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        friendsTableView.rowHeight = UITableView.automaticDimension
        friendsTableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getFriendsList()
        getIncomingRequest()
        getBadge()
        friendsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendsTableView.dequeueReusableCell(withIdentifier: "FriendsCell") as! FriendsCell
        
        // Retrieve friends info
        let friend = friends[indexPath.row] as! NSDictionary
 
        // Populate cells
        let baseURL = "http://18.219.112.140/images/avatars/"
        let picURL = (friend["profile_pic_url"] as? String)!
        let imageURL = URL(string: (baseURL + picURL))!
        let first_name = friend["first_name"] as? String
        let last_name = friend["last_name"] as? String
        let email = friend["email"] as? String
        let username = (email?.replacingOccurrences(of: "@purdue.edu", with: ""))!
        
        cell.nameLabel.text = ((first_name)!) + " " + ((last_name)!)
        cell.profileImage.af.setImage(withURL: imageURL)
        cell.usernameLabel.text = username 
        
        // Make the profile pic circular
        cell.profileImage.layer.masksToBounds = false
        cell.profileImage.layer.cornerRadius = cell.profileImage.frame.height / 2
        cell.profileImage.clipsToBounds = true
        
        return cell
    }
    
    func getFriendsList() {
        // Friends List Endpoint
        let url = "http://18.219.112.140:8000/api/v1/load-friends/"

        // HTTP Request
        AF.request(url, method: .post, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        self.friends = data["friends"] as! NSArray
                        self.friendsTableView.reloadData()
                    }
                
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func getIncomingRequest() {
        // Incoming request endpoint
        let url = "http://18.219.112.140:8000/api/v1/requests/"
            
        // HTTP request
        AF.request(url, method: .post, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        self.friendRequests = data["requests"] as! NSArray
                        cellCount = self.friendRequests.count
                        self.getBadge()
                        if controller {
                            self.friendsTableView.reloadData()
                            controller = false
                        }
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    // Count for notifications
    func getCount() -> Int {
        return cellCount
    }
    
    // Get notification count and badge
    func getBadge() {
        let notificationCount = getCount()
        // Only display badge if there is a notification
        if notificationCount > 0 {
            self.notificationButton.addBadge(number: notificationCount)
        }
        else {
            self.notificationButton.removeBadge()
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "NotificationsSegue" {
            let requests = friendRequests
            
            let notificationViewController = segue.destination as! NotificationsViewController
            notificationViewController.requests = requests
        }
        // Pass the friend requests to the next view controller
    }
}
