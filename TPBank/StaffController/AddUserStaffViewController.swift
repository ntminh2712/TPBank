//
//  AddUserStaffViewController.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/3/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class AddUserStaffViewController: UIViewController,UITextFieldDelegate {
    var tableName: DatabaseReference!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtNameUser: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtIdentifyCard: UITextField!
    @IBOutlet weak var txtSurplus: UITextField!
    @IBOutlet weak var txtOverdraftLimit: UITextField!
    var accountNumber = ""
    var userName = ""
    var address = ""
    var surplus:String!
    var overdraftLimit = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        ref = Database.database().reference()
        tableName = ref.child("Authentication")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
    }
    func randomInt(min: Int, max:Int) -> String {
        let AccountNumber1 = min + Int(arc4random_uniform(UInt32(max - min + 1)))
        let AccountNumber2 = min + Int(arc4random_uniform(UInt32(max - min + 1)))
        let AccountNumber = "\(AccountNumber1)\(AccountNumber2)"
        return AccountNumber
    }
    @objc func keyboardWillChange(notification : Notification){
        print(notification.name.rawValue)
    }
    func setup(){
        txtPhone.delegate = self
        txtNameUser.delegate = self
        txtEmail.delegate = self
        txtAddress.delegate = self
        txtIdentifyCard.delegate = self
        txtSurplus.delegate = self
        txtOverdraftLimit.delegate = self
    }
    func hideKeyBoard(){
        txtPhone.resignFirstResponder()
        txtNameUser.resignFirstResponder()
        txtEmail.resignFirstResponder()
        txtAddress.resignFirstResponder()
        txtIdentifyCard.resignFirstResponder()
        txtSurplus.resignFirstResponder()
        txtOverdraftLimit.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyBoard()
        return true
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    @IBAction func btnContinue(_ sender: Any) {
        userName = txtNameUser.text!
        address = txtAddress.text!
        surplus = txtSurplus.text!
        overdraftLimit = txtOverdraftLimit.text!
        accountNumber = randomInt(min: 100000, max: 999999)
        let inforUser:Dictionary<String,String> = ["AccountNumber":"\(accountNumber)","Username":userName,"Phone":txtPhone.text!,"Password":txtIdentifyCard.text!,"Email":txtEmail.text!,"Address":txtAddress.text!,"IdentifyCard":txtIdentifyCard.text!,"Surplus":txtSurplus.text!,"OverdraftLimit":txtOverdraftLimit.text!]
        tableName.child("\(accountNumber)").setValue(inforUser)
        
        performSegue(withIdentifier:"AddUser", sender: self)
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddSuccess")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        hideKeyBoard()
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "HomeStaff")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultVC = segue.destination as! AddSuccessViewController
        resultVC.accountNumber = accountNumber
        resultVC.address = address
        resultVC.userName = userName
        resultVC.surplus = surplus
        resultVC.overdraftLimit = overdraftLimit
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func hideKB(_ sender: UITapGestureRecognizer) {
        hideKeyBoard()
    }

}
