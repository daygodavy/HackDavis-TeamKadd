//
//  MessageManager.swift
//  Listener
//
//  Created by Daniel Weatrowski on 1/18/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import Foundation
import UIKit

class Message {
    let body: String?
    let wasSent: Bool
    
    init() {
        body = ""
        wasSent = false
    }
    
    init(body: String, wasSent: Bool) {
        self.body = body
        self.wasSent = wasSent
    }
    
    
}
