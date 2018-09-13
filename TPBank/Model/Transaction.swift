//
//  Transaction.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/15/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import Foundation
import UIKit

struct Transaction {
    let TimeTransaction:String!
    let Content:String!
    let Money:String!
    let Category:CategoryTransaction
    let CodeTransaction:String
    
    init(TimeTransaction:String,Content:String,Money:String,Category:CategoryTransaction,CodeTransaction:String) {
        self.TimeTransaction = TimeTransaction
        self.Content = Content
        self.Money = Money
        self.Category = Category
        self.CodeTransaction = CodeTransaction
    }
    
}
enum CategoryTransaction:String {
    case Banking = "Banking"
    case CardPhone = "CardPhone"
}
