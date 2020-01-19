//
//  UserModel.swift
//  Listener
//
//  Created by Davy Chuon on 1/18/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import Foundation

class User {
    var uid: String
    var moodRating: Double

    init() {
        self.uid = ""
        self.moodRating = 0.0
    }

    init(uid: String, moodRating: Double) {
        self.uid = uid
        self.moodRating = moodRating
    }
}
