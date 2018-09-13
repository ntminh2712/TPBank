//
//  GetDetailTransactionController.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/18/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class GetDetailPhoneCardController: UIViewController {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblCardMoney: UILabel!
    @IBOutlet weak var lblTimeTransaction: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let refchild = ref.child("Transaction History")
        refchild.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.childSnapshot(forPath: currentUser.accountNumber).value as?  [String : AnyObject]
            if postDict != nil {
                let CodeTransaction:String = (postDict!["CodeTransaction"])! as! String
                print(CodeTransaction)
                if CodeTransaction == CodeCardPhone {
                    self.lblAccountNumber.text = (postDict!["AccountNumber"])! as! String
                    self.lblUserName.text = currentUser.Username
                    self.lblFee.text = (postDict!["FeeTransaction"])! as! String
                    self.lblPhoneNumber.text = (postDict!["Content"])! as! String
                    self.lblCardMoney.text = (postDict!["MoneyTransaction"])! as! String
                    self.lblTimeTransaction.text = (postDict!["TimeTransaction"])! as! String
                    
                }
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "ListTransaction")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }


}

class GetDetailBankingController: UIViewController {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblTimeTransaction: UILabel!
    @IBOutlet weak var lblAccountDestination: UILabel!
    @IBOutlet weak var lblContent: UITextView!
    @IBOutlet weak var lblMoneyBanking: UILabel!
    @IBOutlet weak var lblNameBanking: UILabel!
    @IBOutlet weak var lblTotalTransaction: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let refchild = ref.child("Transaction History")
        refchild.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.childSnapshot(forPath: currentUser.accountNumber).value as?  [String : AnyObject]
            if postDict != nil {
                let CodeTransaction:String = (postDict!["CodeTransaction"])! as! String
                if CodeTransaction == CodeBanking {
                    self.lblAccountNumber.text = (postDict!["AccountBanking"])! as? String
                    self.lblUserName.text = (postDict!["NameDestination"])! as? String
                    self.lblFee.text = (postDict!["FeeTransaction"])! as? String
                    self.lblContent.text = (postDict!["Content"])! as! String
                    self.lblMoneyBanking.text = (postDict!["MoneyTransaction"])! as? String
                    self.lblTimeTransaction.text = (postDict!["TimeTransaction"])! as? String
                    self.lblNameBanking.text = (postDict!["NameBanking"])! as? String
                    let fee = Int(self.lblFee.text!)
                    let money = Int(self.lblMoneyBanking.text!)
                    self.lblTotalTransaction.text = String(fee! + money!)
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
//    
//    @IBAction func hideKB(_ sender: UITapGestureRecognizer) {
//        hideKeyBoard()
//    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "ListTransaction")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
}
