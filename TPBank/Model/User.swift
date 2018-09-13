//
//  User.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/5/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import Foundation
import UIKit
struct User {
    let accountNumber:String!
    let Username:String!
    let Phone:String!
    let Password:String!
    let Email:String!
    let Address:String!
    let IdentifyCard:String!
    let Surplus:String!
    let OverdraftLimit:String!
    
    init() {
        accountNumber = ""
        Username = ""
        Phone = ""
        Password = ""
        Email = ""
        Address = ""
        IdentifyCard = ""
        Surplus = ""
        OverdraftLimit = ""
    }
    init(accountNumber:String, Username:String, Phone:String, Password:String,Email:String, Address:String, IdentifyCard:String, Surplus:String, OverdraftLimit:String ) {
        self.accountNumber = accountNumber
        self.Username = Username
        self.Phone = Phone
        self.Password = Password
        self.Email = Email
        self.Address = Address
        self.IdentifyCard = IdentifyCard
        self.Surplus = Surplus
        self.OverdraftLimit = OverdraftLimit
    }
    
}


















