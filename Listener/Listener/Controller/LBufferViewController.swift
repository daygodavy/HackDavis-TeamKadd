//
//  LBufferViewController.swift
//  Listener
//
//  Created by Daniel Weatrowski on 1/18/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LBufferViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.color = UIColor(named: "custom-white")!
        activityIndicator.type = .ballBeat
        activityIndicator.startAnimating()

        // Do any additional setup after loading the view.
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
