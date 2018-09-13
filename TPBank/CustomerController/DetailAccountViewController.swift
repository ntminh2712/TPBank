//
//  DetailAccountViewController.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/8/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class DetailAccountViewController: UIViewController {
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblSurplus: UILabel!
    @IBOutlet weak var lblOverdrafLimit: UILabel!
    @IBOutlet weak var lblTotalMoney: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let refchild = Database.database().reference().child("Authentication")
        refchild.observe(.value, with: { (snapshot) in
            let postDict = snapshot.childSnapshot(forPath: "\(currentUser.accountNumber!)").value as! [String: AnyObject]
            if postDict != nil {
                self.lblAccountNumber.text = (postDict["AccountNumber"])! as! String
                self.lblUserName.text = (postDict["Username"])! as! String
                self.lblAddress.text = (postDict["Address"])! as! String
                let Email:String = (postDict["Email"])! as! String
                let IdentifyCard:String = (postDict["IdentifyCard"])! as! String
                let Password:String = (postDict["Password"])! as! String
                let Surplus:String = postDict["Surplus"] as! String
                self.lblTotalMoney.text = Surplus
                self.lblSurplus.text = Surplus
                self.lblOverdrafLimit.text  = (postDict["OverdraftLimit"])! as? String
            }
        })
    }
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "AccountView")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
