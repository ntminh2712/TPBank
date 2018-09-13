//
//  PhoneSusscessViewController.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/13/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit
import Firebase
class PhoneSusscessViewController: UIViewController {
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblMoneyCard: UILabel!
    @IBOutlet weak var lblTotalTransaction: UILabel!
    @IBOutlet weak var lblSurplus: UILabel!
    var CodePhoneTransaction:String!
    
    func fillInitData() {
        CodePhoneTransaction = codePhoneCard!
        lblUserName.text = currentUser.Username
        lblAccountNumber.text = currentUser.accountNumber
        lblCategory.text = "Nạp thẻ điện thoại"
    }
    
    func requestDatabase() {
        let refchild = ref.child("Transaction History")
        refchild.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.childSnapshot(forPath: currentUser.accountNumber).value as?  [String : AnyObject]
            if postDict != nil {
                let CodeTransaction:String = (postDict?["CodeTransaction"])! as! String
                if CodeTransaction == self.CodePhoneTransaction {
                    self.lblMoneyCard.text = (postDict!["MoneyTransaction"])! as! String
                    self.lblPhone.text = (postDict!["Content"])! as! String
                    self.lblTotalTransaction.text = (postDict!["MoneyTransaction"])! as! String
                }else {
                    print("lỗi load lịch sử giao dịch")
                }
                
            }else{
                print("error load ")
            }
            
        })
        ref = Database.database().reference()
        let table = ref.child("Authentication")
        table.observe(.value, with:{ (snapshot) in
            let post = snapshot.childSnapshot(forPath: currentUser.accountNumber!).value as? [String: AnyObject]
            if post != nil{
                self.lblSurplus.text = (post!["Surplus"])! as! String
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fillInitData()
       requestDatabase()
        
    }
    @IBAction func btnCompleted(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "ScreenHomeCustomer")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
