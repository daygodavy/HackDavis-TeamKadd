//
//  DidConnectViewController.swift
//  Listener
//
//  Created by Daniel Weatrowski on 1/19/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class DidConnectViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var symptomLabel: UILabel!
    @IBOutlet weak var faceView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func setupUI() {
        confirmButton.layer.cornerRadius = 15.0
        // TODO: mood and symptoms
    }
    
    // MARK: - Actions
    @IBAction func didTapConfirm(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
