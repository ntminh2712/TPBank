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
class GetDetailPhoneCardStaffController: UIViewController {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblCardMoney: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblTimeTransaction: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        let table = ref.child("Authentication")
        table.observe(.value, with:{ (snapshot) in
            let post = snapshot.childSnapshot(forPath: AccountNumberSearch!).value as? [String: AnyObject]
            if post != nil{
                self.lblUserName.text = (post!["Username"])! as! String
            }
        })
        let refchild = ref.child("Transaction History")
        refchild.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.childSnapshot(forPath: AccountNumberSearch!).value as?  [String : AnyObject]
            if postDict != nil {
                print(CodeCardPhone)
                let CodeTransaction:String = (postDict!["CodeTransaction"])! as! String
                if CodeTransaction == CodeCardPhone {
                    self.lblAccountNumber.text = (postDict!["AccountNumber"])! as! String
                    self.lblFee.text = (postDict!["FeeTransaction"])! as! String
                    self.lblPhoneNumber.text = (postDict!["Content"])! as! String
                    self.lblCardMoney.text = (postDict!["MoneyTransaction"])! as! String
                    self.lblTimeTransaction.text = (postDict!["TimeTransaction"])! as! String
                    
                }else {
                    print("lỗi load lịch sử giao dịch")
                }
                
            }else{
                print("error load ")
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "ListTransactionStaff")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
}

class GetDetailBankingStaffController: UIViewController {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblTimeTransaction: UILabel!
    @IBOutlet weak var lblAccountDestination: UILabel!
    @IBOutlet weak var lblContent: UITextView!
    @IBOutlet weak var lblMoneyBanking: UILabel!
    @IBOutlet weak var lblNameBanking: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    @IBOutlet weak var lblTotalTransaction: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let refchild = ref.child("Transaction History")
        let table = ref.child("Authentication")
        table.observe(.value, with:{ (snapshot) in
            let post = snapshot.childSnapshot(forPath: AccountNumberSearch!).value as? [String: AnyObject]
            if post != nil{
                self.lblUserName.text = (post!["Username"])! as! String
            }
        })
        refchild.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.childSnapshot(forPath: AccountNumberSearch!).value as?  [String : AnyObject]
            if postDict != nil {
                let CodeTransaction:String = (postDict!["CodeTransaction"])! as! String
                if CodeTransaction == CodeBanking {
                    self.lblAccountDestination.text = (postDict!["AccountDestination"])! as! String
                    self.lblFee.text = (postDict!["FeeTransaction"])! as! String
                    self.lblContent.text = (postDict!["Content"])! as! String
                    self.lblMoneyBanking.text = (postDict!["MoneyTransaction"])! as! String
                    self.lblTimeTransaction.text = (postDict!["TimeTransaction"])! as! String
                    self.lblNameBanking.text = (postDict!["NameBanking"])! as! String
                    
                }else {
                    print("lỗi load lịch sử giao dịch")
                }
                
            }else{
                print("error load ")
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "ListTransactionStaff")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
}
