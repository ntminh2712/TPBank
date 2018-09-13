//
//  AddSuccessViewController.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/5/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit

class AddSuccessViewController: UIViewController {
    @IBOutlet weak var lblAcountNumber: UILabel!
    @IBOutlet weak var lblNameUser: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblSurplus: UILabel!
    @IBOutlet weak var lblOverdraftLimit: UILabel!
    @IBOutlet weak var lblTotalAvailability: UILabel!
    var accountNumber:String!
    var userName:String!
    var address:String!
    var surplus:String!
    var overdraftLimit:String!
    var totalAvailability:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(accountNumber)
        lblAcountNumber.text = accountNumber
        lblNameUser.text = userName
        lblAddress.text = address
        lblSurplus.text = surplus
        lblOverdraftLimit.text = overdraftLimit
        lblTotalAvailability.text = surplus
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func btnSuccess(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "HomeStaff")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
   

}
