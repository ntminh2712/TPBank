//
//  BankingSuccessViewController.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/12/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit
import Firebase
class BankingSuccessViewController: UIViewController {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblContent: UITextView!
    @IBOutlet weak var lblFee: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblNameBanking: UILabel!
    @IBOutlet weak var lblMoneyBanking: UILabel!
    @IBOutlet weak var lblTotalMoneyBanking: UILabel!
    var accountNumber:String!
    var userName:String!
    var fee:String!
    var moneybanking:String!
    var content:String!
    var namebanking:String!
    var totalmoneybanking:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblUserName.text = userName
        self.lblContent.text = content
        self.lblFee.text = fee
        self.lblAccountNumber.text = accountNumber
        self.lblNameBanking.text = namebanking
        self.lblMoneyBanking.text = moneybanking
        self.lblTotalMoneyBanking.text = totalmoneybanking
        
        let refchild = ref.child("Transaction History")
        let table = ref.child("Authentication")
        refchild.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.childSnapshot(forPath: currentUser.accountNumber).value as?  [String : AnyObject]
            if postDict != nil {
                let CodeTransaction:String = (postDict!["CodeTransaction"])! as! String
                if CodeTransaction == CodeBanking {
                    self.lblAccountNumber.text = (postDict!["AccountDestination"])! as? String
                    self.lblFee.text = (postDict!["FeeTransaction"])! as? String
                    self.lblContent.text = (postDict!["Content"])! as! String
                    self.lblMoneyBanking.text = (postDict!["MoneyTransaction"])! as? String
                    self.lblNameBanking.text = (postDict!["NameBanking"])! as? String
                    let money:Int = Int((postDict!["MoneyTransaction"])! as! String)!
                    let fee:Int = Int((postDict!["FeeTransaction"])! as! String)!
                    self.lblTotalMoneyBanking.text = String(money + fee)
                    self.lblUserName.text = currentUser.Username
                }else {
                    print("lỗi load lịch sử giao dịch")
                }
            }else{
                print("error load ")
            }

        })
       
    }
   
    @IBAction func btnCompleted(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "ScreenHomeCustomer")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
  

}
