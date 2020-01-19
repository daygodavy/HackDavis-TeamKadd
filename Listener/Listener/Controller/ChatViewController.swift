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

    @IBOutlet weak var disconnectButton: UIBarButtonItem!
    
    // Firebase
    let rootRef = Database.database().reference(fromURL: "https://teamkaddhackdavis2020.firebaseio.com/")
    var user = Auth.auth().currentUser
    
    var currUser = User()
    var listenerMode: String = "0"
    var currStatus: String = "1"
    var chatOccupied: String = "0"
    var LM_UA_OCC: String = "000"
    var speakerUID: String = ""
    var postRefHandle: DatabaseHandle!
    var postsRef: DatabaseReference!
    
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
        generateStartUpMessages()
        enableActivityMonitor()
        configUserChat()
        // FOR SPEAKER: FIRST EMPTY MESSAGE WITH FLAGS

//        setUserStatus(status: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messageTF.becomeFirstResponder()

    }
    
    // MARK: - Actions
    @IBAction func didTapReport(_ sender: Any) {
        let alertController = UIAlertController(title: "Report User", message: "Please specify reasoning below.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                // do something bad to user
                self.disconnect()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Language, Abuse, Rude, etc."
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func didTapDisconnect(_ sender: Any) {
        let alert = UIAlertController(title: "Disconnect from user?", message: "", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            // end chat
            self.currStatus = "0"
            self.LM_UA_OCC = self.listenerMode + self.currStatus + self.chatOccupied
//            self.configSpeaker()
            self.clearChatHistory()
            // RIGHT HERE: SEND LAST MESSAGE TO OTHER USER TO INDICATE DISCONNECT
            self.currUser.messageCount = 0
            self.postsRef.removeObserver(withHandle: self.postRefHandle!)
            // segue to rating if speaker
            if (self.listenerMode == "1") {
                let storyboard  = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "UserRating") as UserRatingViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
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
//        generateMessage()
    }
    func disconnect() {
        self.currStatus = "0"
        self.LM_UA_OCC = self.listenerMode + self.currStatus + self.chatOccupied
        self.configSpeaker()
        self.clearChatHistory()
        // RIGHT HERE: SEND LAST MESSAGE TO OTHER USER TO INDICATE DISCONNECT
        self.currUser.messageCount = 0
        
        // segue to rating if speaker
        if (self.listenerMode == "1") {
            let storyboard  = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "UserRating") as UserRatingViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Private Functions
    
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // observer functions
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.messageBottomConstraint.constant = keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            //self.messageBottomConstraint.constant -= keyboardSize.height
        }
    }
    
    func generateMessage(text: String) {
//        let message = Message(body: "Hello, Daniel. How is it going? You look very nice this evening.", wasSent: false)
        let message = Message(body: text, wasSent: false)
       // let message = "Target Acquirred"
        conversation.insert(message, at: 0)
        tableView.reloadData()
    }
    
    func generateStartUpMessages() {
        // listener
        if (self.listenerMode == "1") {
            var body = "You're now listening. You're not here to solve problems. All you need is your presence and perspective.\n"
            body += "- NeverAlone Team"
            let message = Message(body: body, wasSent: false)
            conversation.insert(message, at: 0)
            tableView.reloadData()
        } else {
            var body = "You're connected. Feel free to say what's on your mind - you're never alone.\n"
            body += "- NeverAlone Team"
            let message = Message(body: body, wasSent: false)
            conversation.insert(message, at: 0)
            tableView.reloadData()
        }
    }
    
    func storeMessage(message: String) {
        currUser.messageCount += 1
            if let user = user?.uid {
                let chat = self.rootRef.child("chat").childByAutoId()
                LM_UA_OCC = listenerMode + currStatus + chatOccupied
                chat.updateChildValues(["LM_UA_OCC" : LM_UA_OCC])
                chat.updateChildValues(["Text" : message])
                chat.updateChildValues(["MessageCount" : currUser.messageCount])
                chat.updateChildValues(["UID" : speakerUID])
            }
    }
    
    func configUserChat() {
        LM_UA_OCC = listenerMode + currStatus + chatOccupied
        // FOR SPEAKER: FIRST EMPTY MESSAGE WITH FLAGS
        if listenerMode == "1" {
            // configure listener
            findActiveSpeaker()
            
        }
        else {
            // configure speaker
            configSpeaker()
        }
//        readMessage()
//        print("JUST READ MESSAGE")
        // DEST1
        self.readMessage()
    }
    
    func findActiveSpeaker() {
        let chat = self.rootRef.child("chat")
        chat.queryOrdered(byChild: "LM_UA_OCC").queryEqual(toValue: "010").observeSingleEvent(of: DataEventType.value) { (snapshot) in
//            if snapshot.exists() {
//                snapshot.
//            }
            
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
                    // DEST2
                    self.configListener(messageCount: otherMessageCount)
                    //self.readMessage()
                    break
                }
                
                // HANDLE NO MATCH!!!!!!!!
                // set boolean or lock keyboard so that listener cannot send message if not occupied
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
        chatOccupied = "1"
        LM_UA_OCC = listenerMode + currStatus + chatOccupied
//        if let user = user?.uid {
        let chat = self.rootRef.child("chat").childByAutoId()
        
//        chat.updateChildValues(["UID" : self.speakerUID])
        print("HERE1")
        chat.updateChildValues(["LM_UA_OCC" : LM_UA_OCC])
        print("HERE2")
        // no text first message?
            chat.updateChildValues(["Text" : " "])
        chat.updateChildValues(["MessageCount" : currUser.messageCount])
        print("HERE3")
        chat.updateChildValues(["UID" : self.speakerUID])
//        }
    }
    
    func configSpeaker() {
        // initiate "first" chat message
        currUser.messageCount += 1
//        LM_UA_OCC = listenerMode + currStatus + chatOccupied
        if let user = user?.uid {
            self.speakerUID = user
            let chat = self.rootRef.child("chat").childByAutoId()
//            chat.childByAutoId()
            
            chat.updateChildValues(["UID" : speakerUID])
            chat.updateChildValues(["LM_UA_OCC" : LM_UA_OCC])
            // no text first message?
            chat.updateChildValues(["Text" : " "])
            chat.updateChildValues(["MessageCount" : currUser.messageCount])
//            self.readMessage()
        }
    }
    
    func readMessage() {

        let chat = self.rootRef.child("chat")

        print("speakerUID: \(speakerUID)")
        self.postsRef = chat
        self.postRefHandle = postsRef.queryOrdered(byChild: "UID").queryEqual(toValue: speakerUID).observe(DataEventType.childAdded) { (snapshot) in
            let snap = snapshot as! DataSnapshot
            let dict = snap.value as! [String: Any]
            print(dict)
//            let newCount = dict["MessageCount"] as! Int
            let newMessage = dict["Text"] as! String
            var otherUID = dict["LM_UA_OCC"] as! String
            var userType = otherUID.removeFirst()
            if String(userType) != self.listenerMode {
                self.generateMessage(text: newMessage)
            }
            
        }
        
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
//        configSpeaker()
        clearChatHistory()
        // RIGHT HERE: SEND LAST MESSAGE TO OTHER USER TO INDICATE DISCONNECT
        currUser.messageCount = 0
        // segue to homeVC (tab bar)
        self.postsRef.removeObserver(withHandle: self.postRefHandle!)
        dismiss(animated: true, completion: nil)
    }
    
    func clearChatHistory() {
        let chat = self.rootRef.child("chat")
        chat.queryOrdered(byChild: "UID").queryEqual(toValue: speakerUID).observeSingleEvent(of: DataEventType.value) { (snapshot) in
        //            if snapshot.exists() {
        //                snapshot.
        //            }
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                snap.ref.parent?.removeValue()
//                let dict = snap.value as! [String: Any]
//                let otherUID = dict["UID"] as! String
//                let otherLM_UA_OCC = dict["LM_UA_OCC"] as! String
//                let otherMessageCount = dict["MessageCount"] as! Int
//
//                // match found
//                if otherLM_UA_OCC == "010" {
//        //                    self.configChat()
//                    self.speakerUID = otherUID
//                    // DEST2
//                    self.configListener(messageCount: otherMessageCount)
//                }
                
                // HANDLE NO MATCH!!!!!!!!
                // set boolean or lock keyboard so that listener cannot send message if not occupied

              }
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
            cell.bgView.backgroundColor = .systemBlue
            cell.textLabel?.textAlignment = .left
        } else {
            cell.formatRecievedMessage()
            cell.bgView.backgroundColor = .systemGray6
            cell.textLabel?.textAlignment = .right
            
        }
        cell.messageLabel.text = message.body
        cell.bgView.layer.cornerRadius = 8.0
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
    
}
