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
    var listenerMode: String
//    var activeStatus: String
    var messageCount: Int

    init() {
        self.uid = ""
        self.moodRating = 0.0
        self.listenerMode = "0"
        self.messageCount = 0
    }

//    init(uid: String, moodRating: Double, listenerMode: Bool ) {
//        self.uid = uid
//        self.moodRating = moodRating
//        self.listenerMode = listenerMode
//    }
}
