//
//  ChatViewController.swift
//  parseChat
//
//  Created by Claudia Nelson on 10/1/18.
//  Copyright © 2018 Claudia Nelson. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource {
    
    var messages: [PFObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initializing keyboard controls
        messageField.delegate = self
        
        //Setting a timer to run the onTimer method to update view
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)

        tableView.dataSource = self
        loadData()
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func logOut(_ sender: Any) {
        print("Trying to log out")
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = messageField.text ?? ""
        chatMessage["user"] = PFUser.current()
        print(PFUser.current() ?? "")
        
        chatMessage.saveInBackground { (success, error) in
            if success {
                print("The message was saved!")
                self.messageField.text = ""
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! MessageTableViewCell
        
        let message = messages[indexPath.row]
        
        print(message.object(forKey: "user") ?? "")

        if message["user"] != nil {
            let user = message["user"] as! PFUser
            cell.authorLabel.text = user.username
        } else {
            cell.authorLabel.text = "🎃"
        }
//        cell.authorLabel.text = "🎃"
        cell.messageLabel.text = message["text"] as? String
        return cell
    }
    
    @objc func onTimer() {
        loadData()
    }
    
    func loadData(){
        let query = PFQuery(className: "Message")
        query.addDescendingOrder("createdAt")
        query.includeKey("user")
        query.limit = 20
        
        query.findObjectsInBackground{ (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil{
                if let objects = objects{
                    print("My messages: \(objects)")
                    self.messages = objects
                }
            }else{
                print("Error \(String(describing: error?.localizedDescription))")
            }
        }
        self.tableView.reloadData()
    }

    
    //This dismisses the keyboard when hitting the 'done' button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageField.resignFirstResponder()
        return true
    }
    
    //This dismisses the keyboard when touching out of textField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    
    
    
    }
}
