//
//  SentFRQCell.swift
//  MyStatus
//
//  Created by GKB on 4/29/17.
//  Copyright © 2017 MyStatus. All rights reserved.
//

import UIKit

class SentFRQCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var SuserImageView: UIImageView!
    @IBOutlet weak var SfullNameLabel: UILabel!
    @IBOutlet weak var SUserNameLabel: UILabel!
    @IBOutlet weak var SStatusLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
