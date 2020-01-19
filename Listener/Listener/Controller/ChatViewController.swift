//
//  ChatViewController.swift
//  Listener
//
//  Created by Daniel Weatrowski on 1/18/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTF: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var leadingMessageConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingMessageConstraint: NSLayoutConstraint!
    
    // Firebase
    let rootRef = Database.database().reference(fromURL: "https://teamkaddhackdavis2020.firebaseio.com/")
    var user = Auth.auth().currentUser
    
    
    
    var sentMessages = [Message]()
    var receivedMessages = [Message]()
    var conversation = [Message]()
    
    var messageOffset = 80
    
    // MARK: - View Controls
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension;
        tableView.estimatedRowHeight = 300
        self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        messageView.layer.cornerRadius = 15.0
        addObservers()
        enableActivityMonitor()
        setUserStatus(status: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messageTF.becomeFirstResponder()

    }
    
    // MARK: - Actions
    @IBAction func didTapSend(_ sender: Any) {
        // unwrap textfield
        guard let text = messageTF.text else {return}
        if (text.isEmpty) {
            print("Text Field is empty")
            return
        }
        let message = Message(body: text, wasSent: true)
        conversation.insert(message, at: 0)
        tableView.reloadData()
        messageTF.text = ""
        generateMessage()
    }
    
    // MARK: - Private Functions
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // observer functions
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.messageBottomConstraint.constant += keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.messageBottomConstraint.constant -= keyboardSize.height
        }
    }
    
    func generateMessage() {
        let message = Message(body: "Hello, Daniel. How is it going? You look very nice this evening.", wasSent: false)
       // let message = "Target Acquirred"
        conversation.insert(message, at: 0)
        tableView.reloadData()
    }
    
    func enableActivityMonitor() {
        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        setUserStatus(status: false)
        // segue to homeVC (tab bar)
        dismiss(animated: true, completion: nil)
    }
    
    func setUserStatus(status: Bool) {
        if let uid = user?.uid {
            let users = self.rootRef.child("users")
            users.child(uid).updateChildValues(["userActive" : status])
        }
    }

}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "MessageCell",
          for: indexPath) as! MessageTableViewCell
        let message = conversation[indexPath.row]
        
        if (message.wasSent) {
            cell.formatSentMessage()
            cell.bgView.backgroundColor = .blue
            cell.textLabel?.textAlignment = .left
        } else {
            cell.formatRecievedMessage()
            cell.bgView.backgroundColor = .red
            cell.textLabel?.textAlignment = .right
            
        }
        cell.messageLabel.text = message.body
        cell.bgView.layer.cornerRadius = 8.0
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
    
}
