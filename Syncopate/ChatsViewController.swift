//
//  ChatsViewController.swift
//  Syncopate
//
//  Created by Shafer Hess on 4/5/20.
//  Copyright © 2020 Syncopate. All rights reserved.
//

import Alamofire
import UIKit

class ChatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Outlets
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBOutlet weak var chatsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.chatsTableView.delegate = self
        self.chatsTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatsTableView.dequeueReusableCell(withIdentifier: "ChatsCell") as! ChatsCell
        
        return cell
    }
    
    // Logout HTTP Request
    @IBAction func onLogout(_ sender: Any) {
        // Login Endpoint
        let url = "http://18.219.112.140:8000/api/v1/logout/"
        
        // Login HTTP Request
        AF.request(url, method: .post, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any] {
                        if(data["status"] as! String == "success") {
                            UserDefaults.standard.set(false, forKey: "loggedIn")
                            self.dismiss(animated: true, completion: nil)
                        } else {
                            print("Error Logging Out")
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
