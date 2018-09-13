//
//  CardPHone.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/15/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import Foundation
import UIKit
struct CardPhone {
    let AccountBanking:String!
    let Category:String!
    let PhoneTransaction:String!
    let CodeTransaction:String!
    let Content:String!
    let MoneyCard:String!
    let TimeTransaction:String!
    init() {
        AccountBanking = ""
        Category = ""
        CodeTransaction = ""
        PhoneTransaction = ""
        Content = ""
        MoneyCard = ""
        TimeTransaction = ""
        
    }
    init(AccountBanking:String,Category:String,CodeTransaction:String,PhoneTransaction:String,Content:String,MoneyCard:String,TimeTransaction:String) {
        self.AccountBanking = AccountBanking
        self.Category = Category
        self.CodeTransaction = CodeTransaction
        self.PhoneTransaction = PhoneTransaction
        self.Content = Content
        self.MoneyCard = MoneyCard
        self.TimeTransaction = TimeTransaction
    }
}
