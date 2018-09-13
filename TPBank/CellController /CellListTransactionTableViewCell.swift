//
//  CellListTransactionTableViewCell.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/15/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit

class CellListTransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var TimeTransactionIn: UILabel!
    @IBOutlet weak var MoneyTransactionIn: UILabel!
    @IBOutlet weak var ContentTransactionIn: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
