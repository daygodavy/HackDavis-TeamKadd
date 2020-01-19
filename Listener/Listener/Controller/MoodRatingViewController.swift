//
//  MoodRatingViewController.swift
//  Listener
//
//  Created by Davy Chuon on 1/18/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class MoodRatingViewController: UIViewController {
    
    // Idx 0-4 corresponds to ratings 1-5
    @IBOutlet var moodRatings: [UIButton]!
    var currUser: User = User()
    // Firebase
    let rootRef = Database.database().reference(fromURL: "https://teamkaddhackdavis2020.firebaseio.com/")
    var isAnonymous: Bool = true
//    var userId: String = ""
    var user = Auth.auth().currentUser
    var result : [NSFetchRequestResult] = []
    var moodList : NSManagedObjectContext!
    var dataExist = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        moodList = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mood")

        request.returnsObjectsAsFaults = false
        do {
            result = try moodList.fetch(request)
            
            dataExist = true
            print("Data feteched")
        } catch {
            print("Failed to fetch data")
        }
        
        print("HEREEEEE \(user?.uid)")
        if (user?.uid == nil) {
            checkExistingUser()
        }
        else {
            currUser.uid = user!.uid
        }
    
        // Do any additional setup after loading the view.
    }
    
    func checkExistingUser() {
        Auth.auth().signInAnonymously() { (authResult, error) in
          // ...
            if let err = error {
                print("ERRRRRORRR \(err)")
            }
            else {
                guard let user = authResult?.user else { return }
                self.isAnonymous = user.isAnonymous  // true
                let uid = user.uid
                print("ASSIGN UID: \(uid)")
                self.currUser.uid = uid
//                self.userId = uid
            }
        }
    }
    
    @IBAction func moodRatingSelected(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let idx = moodRatings.firstIndex(of: sender)!
        switch idx {
        case 0:
            currUser.moodRating = 1
        case 1:
            currUser.moodRating = 2
        case 2:
            currUser.moodRating = 3
        case 3:
            currUser.moodRating = 4
        case 4:
            currUser.moodRating = 5
        default:
            break
        }
        storeMoodRating(moodRating: currUser.moodRating)
        if (dataExist) {
            let entity = NSEntityDescription.entity(forEntityName: "Mood", in: moodList)
            let newMood = NSManagedObject(entity: entity!, insertInto: moodList)
            newMood.setValue(currUser.moodRating, forKey: "mood")
            newMood.setValue(NSDate(), forKey: "date")
            do {
                try moodList.save()
                print("success?")
            } catch {
                print("failed saving")
            }
        }
    }
    
    func storeMoodRating(moodRating: Double) {
        //print("uid: \(user?.uid)")
        //print("date: \(Date())")
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let now = df.string(from: Date())
        if let uid = user?.uid {
            let users = self.rootRef.child("users")
            users.child(uid).child("MoodRating").updateChildValues([now : moodRating])
        }
        // SEGUE HERE
        navigateToHomeVC()
    }
    
    func navigateToHomeVC() {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? UITabBarController

        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
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
