//
//  UserRatingViewController.swift
//  Listener
//
//  Created by Daniel Weatrowski on 1/19/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class UserRatingViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var greatButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var fairButton: UIButton!
    @IBOutlet weak var poorButton: UIButton!
    @IBOutlet weak var suckButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        greatButton.layer.cornerRadius = 15.0
        goodButton.layer.cornerRadius = 15.0
        fairButton.layer.cornerRadius = 15.0
        poorButton.layer.cornerRadius = 15.0
        suckButton.layer.cornerRadius = 15.0
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
