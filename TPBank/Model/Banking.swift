//
//  Transaction.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/15/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import Foundation
import UIKit

struct Banking {
    let AccountBanking:String!
    let Category:String!
    let CodeTransaction:String!
    let AccountDestination:String!
    let Content:String!
    let FeeTransaction:String!
    let MoneyBanking:String!
    let TimeTransaction:String!
    
    init() {
        AccountBanking = ""
        Category = ""
        CodeTransaction = ""
        AccountDestination = ""
        Content = ""
        FeeTransaction = ""
        MoneyBanking = ""
        TimeTransaction = ""
    }
    init(AccountBanking:String,Category:String,CodeTransaction:String,AccountDestination:String,Content:String,FeeTransaction:String,MoneyBanking:String,TimeTransaction:String) {
        self.AccountBanking = AccountBanking
        self.Category = Category
        self.CodeTransaction = CodeTransaction
        self.AccountDestination = AccountDestination
        self.Content = Content
        self.FeeTransaction = FeeTransaction
        self.MoneyBanking = MoneyBanking
        self.TimeTransaction = TimeTransaction
    }
}
