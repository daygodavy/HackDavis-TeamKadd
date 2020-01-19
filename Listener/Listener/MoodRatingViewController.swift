//
//  MoodRatingViewController.swift
//  Listener
//
//  Created by Davy Chuon on 1/18/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class MoodRatingViewController: UIViewController {
    
    @IBOutlet var moodRatings: [UIButton]!
    var currUser: User = User()
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(<#Bool#>)
//        moodRatings.forEach {
//            $0.setImage(moodRatingsOFF, for: .normal)
//            $0.setImage(BoxON, for: .selected)
//        }
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
