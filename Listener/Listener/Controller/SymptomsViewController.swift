//
//  SymptomsViewController.swift
//  Listener
//
//  Created by Daniel Weatrowski on 1/19/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class SymptomsViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet var views: [UIView]!
    // 0-4 starting with Lonely
    @IBOutlet var buttons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        

    }
    func setupUI() {
        for view in views {
            view.layer.cornerRadius = 15.0
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
