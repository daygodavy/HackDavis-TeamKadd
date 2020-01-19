//
//  UserModeViewController.swift
//  Listener
//
//  Created by Davy Chuon on 1/18/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import Firebase

class UserModeViewController: UIViewController {

//     idx 0 = Listener, idx 1 = Speaker
    @IBOutlet var userMode: [UIButton]!
    var currUser: User = User()
    // Firebase
    let rootRef = Database.database().reference(fromURL: "https://teamkaddhackdavis2020.firebaseio.com/")
    var user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func userModeSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let idx = userMode.firstIndex(of: sender)!
        switch idx {
        case 0:
            currUser.listenerMode = "1"
        case 1:
            currUser.listenerMode = "0"
        default:
            break
        }
        // store user mode into firebase
//        storeUserMode(userMode: currUser.listenerMode)
        navigateToUserModeVC(mode: currUser.listenerMode)
    }

//    func storeUserMode(userMode: Bool) {
////        if let uid = user?.uid {
////            let users = self.rootRef.child("users")
////            users.child(uid).updateChildValues(["ListenerMode" : userMode])
////        }
//        if !userMode {
//            // put speaker into chatroom
//            navigateToUserModeVC(mode: userMode)
//        }
//        else {
//            findActiveSpeaker()
//            // connect the listeners to a speaker chatroom
//        }
//    }
    
    func navigateToUserModeVC(mode: String) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let nextView = sb.instantiateViewController(identifier: "ChatViewController")

        let chatVC = nextView as! ChatViewController
        chatVC.listenerMode = mode
        print("SEEEEEEEEEENDDDDD")
        chatVC.modalPresentationStyle = .fullScreen
        self.present(chatVC, animated: true, completion: nil)
    }
    
//    func findActiveSpeaker() {
//
//    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
