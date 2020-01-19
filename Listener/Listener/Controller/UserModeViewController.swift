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
//    var userId: String = ""
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
            currUser.listenerMode = true
        case 1:
            currUser.listenerMode = false
        default:
            break
        }
        // store user mode into firebase
        storeUserMode(userMode: currUser.listenerMode)
    }

    func storeUserMode(userMode: Bool) {
        if let uid = user?.uid {
            let users = self.rootRef.child("users")
            users.child(uid).updateChildValues(["ListenerMode" : userMode])
        }
        // SEGUE HERE
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
