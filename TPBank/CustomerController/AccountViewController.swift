//
//  AccountViewController.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/8/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class AccountViewController: UIViewController {    @IBOutlet weak var lblSurplus: UILabel!
    @IBOutlet weak var lblTotalSurplus: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    var userShow:User!
    override func viewDidLoad() {
        super.viewDidLoad()
        let refchild = Database.database().reference().child("Authentication")
        refchild.observe(.value, with: { (snapshot) in
            let postDict = snapshot.childSnapshot(forPath: "\(currentUser.accountNumber!)").value as! [String: AnyObject]
            if postDict != nil {
                let AccountNumber:String = (postDict["AccountNumber"])! as! String
                let Username:String = (postDict["Username"])! as! String
                let Address:String = (postDict["Address"])! as! String
                let Email:String = (postDict["Email"])! as! String
                let IdentifyCard:String = (postDict["IdentifyCard"])! as! String
                let Password:String = (postDict["Password"])! as! String
                let Phone:String = (postDict["Phone"])! as! String
                let Surplus:String = (postDict["Surplus"])! as! String
                var OverdraftLimit:String  = (postDict["OverdraftLimit"])! as! String
                self.userShow = User(accountNumber: AccountNumber, Username: Username, Phone: Phone, Password: Password, Email: Email, Address: Address, IdentifyCard: IdentifyCard, Surplus: Surplus, OverdraftLimit: OverdraftLimit)
                self.lblSurplus.text = String(self.userShow.Surplus)
                self.lblTotalSurplus.text = String(self.userShow.Surplus)
                self.lblAccountNumber.text = self.userShow.accountNumber                
            }
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    @IBAction func btnShowDetail(_ sender: UITapGestureRecognizer) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "DetailAccount")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
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
