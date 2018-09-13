//
//  CellListUserTableViewCell.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/5/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit

class CellListUserTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var accountNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initializatiosn code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
