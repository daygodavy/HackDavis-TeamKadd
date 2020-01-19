//
//  MessageTableViewCell.swift
//  Listener
//
//  Created by Daniel Weatrowski on 1/18/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var leadingMessageConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingMessageConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func formatRecievedMessage() {
        trailingMessageConstraint.constant = 75
        leadingMessageConstraint.constant = 8
    }
    func formatSentMessage() {
        trailingMessageConstraint.constant = 8
        leadingMessageConstraint.constant = 75
    }

}
