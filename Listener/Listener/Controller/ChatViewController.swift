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
    
    var currUser = User()
    var listenerMode: String = "0"
    var currStatus: String = "1"
    var chatOccupied: String = "0"
    var LM_UA_OCC: String = "000"
    var speakerUID: String = ""
    
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
        configUserChat()
        // FOR SPEAKER: FIRST EMPTY MESSAGE WITH FLAGS

//        setUserStatus(status: true)
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
        storeMessage(message: text)
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
    
    func storeMessage(message: String) {
        currUser.messageCount += 1
            if let user = user?.uid {
                let chat = self.rootRef.child("chat").childByAutoId()
    //            chat.childByAutoId()
                LM_UA_OCC = listenerMode + currStatus + chatOccupied
                chat.updateChildValues(["UID" : user])
                //***** CHANGE OCCUPIED WHEN CONNECTED
                chat.updateChildValues(["LM_UA_OCC" : LM_UA_OCC])
                // no text first message?
                chat.updateChildValues(["Text" : message])
                chat.updateChildValues(["MessageCount" : currUser.messageCount])
            }
    }
    
    func configUserChat() {
        LM_UA_OCC = listenerMode + currStatus + chatOccupied
        // FOR SPEAKER: FIRST EMPTY MESSAGE WITH FLAGS
        if listenerMode == "1" {
            // configure listener
            findActiveSpeaker()
            
//            configListener()
        }
        else {
            // configure speaker
            configSpeaker()
        }
    }
    
    func findActiveSpeaker() {
        let chat = self.rootRef.child("chat")
        chat.queryOrdered(byChild: "LM_UA_OCC").queryEqual(toValue: "010").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String: Any]
                let otherUID = dict["UID"] as! String
                let otherLM_UA_OCC = dict["LM_UA_OCC"] as! String
                let otherMessageCount = dict["MessageCount"] as! Int
                
                // match found
                if otherLM_UA_OCC == "010" {
//                    self.configChat()
                    self.speakerUID = otherUID
                    self.configListener(messageCount: otherMessageCount)
                }
                
                // HANDLE NO MATCH!!!!!!!!
                print("!!!!!OTHER USER: \(otherUID), \(otherMessageCount)")
              }
            
            // HANDLE NO MATCH HERE
//            if snapshot.exists() {
//
//            }
//            else {
//                // no active speakers or no unoccupied chatrooms
//            }
        }
    }
    
    func configListener(messageCount: Int) {
        currUser.messageCount = messageCount + 1
//        if let user = user?.uid {
        let chat = self.rootRef.child("chat").childByAutoId()
        
        chat.updateChildValues(["UID" : speakerUID])
        chat.updateChildValues(["LM_UA_OCC" : LM_UA_OCC])
        // no text first message?
//            chat.updateChildValues(["Text" : ])
        chat.updateChildValues(["MessageCount" : currUser.messageCount])
//        }
    }
    
    func configSpeaker() {
        // initiate "first" chat message
        currUser.messageCount += 1
        chatOccupied = "1"
        LM_UA_OCC = listenerMode + currStatus + chatOccupied
        if let user = user?.uid {
            self.speakerUID = user
            let chat = self.rootRef.child("chat").childByAutoId()
//            chat.childByAutoId()
            
            chat.updateChildValues(["UID" : speakerUID])
            chat.updateChildValues(["LM_UA_OCC" : LM_UA_OCC])
            // no text first message?
//            chat.updateChildValues(["Text" : ])
            chat.updateChildValues(["MessageCount" : currUser.messageCount])
        }
    }
    
    func readMessage() {
        rootRef.child("chat").queryOrdered(byChild: "UID").queryEqual(toValue: speakerUID).observe(.value, with:{ (snapshot: DataSnapshot) in
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String: Any]
//                    let otherUID = dict["UID"] as! String
                    let otherLM_UA_OCC = dict["LM_UA_OCC"] as! String
                    let otherMessageCount = dict["MessageCount"] as! Int
                    let otherMessage = dict["Text"] as! String
                    

//                    // match found
//                    if otherLM_UA_OCC == "010" {
//                    //                    self.configChat()
//                        self.speakerUID = otherUID
//                        self.configListener(messageCount: otherMessageCount)
//                    }
//
//                    // HANDLE NO MATCH!!!!!!!!
//                    print("!!!!!OTHER USER: \(otherUID), \(otherMessageCount)")
                }
        })
    }
    
    func enableActivityMonitor() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        // SEND BLANK MESSAGE FOR DISABLING CHAT... ACTIVE = FALSE
//        configSpeaker(disable: true)
        currStatus = "0"
        LM_UA_OCC = listenerMode + currStatus + chatOccupied
        configSpeaker()
        currUser.messageCount = 0

        // segue to homeVC (tab bar)
        dismiss(animated: true, completion: nil)
    }
    
//    func setUserStatus(status: Bool) {
//        if let uid = user?.uid {
//            let users = self.rootRef.child("users")
//            users.child(uid).updateChildValues(["userActive" : currStatus])
//        }
//    }

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
