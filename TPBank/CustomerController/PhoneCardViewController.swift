//
//  PhoneCardViewController.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/13/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
var codePhoneCard:String!
class PhoneCardViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var lblSurplus: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    var defaultPhone:Int!
    var tableName: DatabaseReference!
    var Username:String!
    var BalanceBanking:Int!
    var CodeTransaction:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPhone.delegate = self
        ref = Database.database().reference()
        tableName = ref.child("Transaction History")
        let refchild = Database.database().reference().child("Authentication")
        refchild.observe(.value, with: { (snapshot) in
            let postDict = snapshot.childSnapshot(forPath: "\(currentUser.accountNumber!)").value as! [String: AnyObject]
            if postDict != nil {
                let AccountNumber:String = (postDict["AccountNumber"])! as! String
                self.Username = (postDict["Username"])! as! String
                let Address:String = (postDict["Address"])! as! String
                let Email:String = (postDict["Email"])! as! String
                let IdentifyCard:String = (postDict["IdentifyCard"])! as! String
                let Password:String = (postDict["Password"])! as! String
                let Phone:String = (postDict["Phone"])! as! String
                let Surplus:String = (postDict["Surplus"])! as! String
                let OverdraftLimit:String  = (postDict["OverdraftLimit"])! as! String
                self.lblAccountNumber.text = AccountNumber
                self.lblCard.text = "100000"
                self.defaultPhone = Int(Phone)
                self.lblSurplus.text = Surplus
            }
        })
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
    }
    @objc func keyboardWillChange(notification : Notification){
        print(notification.name.rawValue)
    }
    func hideKeyBoard(){
        txtPhone.resignFirstResponder()
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
    func activityStart(){
        activity.center = self.view.center
        activity.hidesWhenStopped = true
        activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activity)
        activity.startAnimating()
    }
    func activityStop(){
        activity.stopAnimating()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func btn50k(_ sender: Any) {
        lblCard.text = "50000"
    }
    @IBAction func btn30k(_ sender: Any) {
        lblCard.text = "30000"
    }
    @IBAction func btn100k(_ sender: Any) {
        lblCard.text = "100000"
    }
    @IBAction func btn200k(_ sender: Any) {
        lblCard.text = "200000"
    }
    @IBAction func btn300k(_ sender: Any) {
        lblCard.text = "300000"
    }
    @IBAction func btn500k(_ sender: Any) {
        lblCard.text = "500000"
    }
    func randomInt(min: Int, max:Int) -> String {
        let AccountNumber1 = min + Int(arc4random_uniform(UInt32(max - min + 1)))
        let AccountNumber2 = min + Int(arc4random_uniform(UInt32(max - min + 1)))
        let AccountNumber = "\(AccountNumber1)\(AccountNumber2)"
        return AccountNumber
    }
    func isValidPhone(phone: String) -> Bool {
        
        let phoneRegex = "^[0-9]{6,14}$";
        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
        return valid
    }
    
    @IBAction func btnExcept(_ sender: Any) {
        
        activityStart()
        let surplus = Int(lblSurplus.text!)
        let moneycard = Int(lblCard.text!)
        let phone = txtPhone.text
        CodeTransaction =  randomInt(min: 1000000, max: 9999999)
        BalanceBanking =  surplus! - moneycard!
        let refchild = Database.database().reference().child("Authentication")
        let todaysDate:NSDate = NSDate()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let DateInFormat:String = dateFormatter.string(from: todaysDate as Date)
        if BalanceBanking >= 50000 {
        var inforTransaction:Dictionary<String,String>
        var alertPhoneCard = UIAlertController()
        if phone == "" {
            inforTransaction = ["AccountNumber":"\(self.lblAccountNumber.text!)","AccountDestination":"","CodeTransaction":CodeTransaction,"Content":String(defaultPhone),"PhoneTransaction":String(defaultPhone!),"Category":"CardPhone","MoneyTransaction":lblCard.text!,"FeeTransaction":"0","TimeTransaction": DateInFormat]
            alertPhoneCard = UIAlertController(title: "Bạn có chắc chắn nạp vào số điện thoại", message: "\(defaultPhone!)", preferredStyle: UIAlertControllerStyle.alert)
            }else{
            inforTransaction = ["AccountNumber":"\(self.lblAccountNumber.text!)","AccountDestination":"","CodeTransaction":CodeTransaction,"PhoneTransaction":phone!,"Category":"CardPhone","MoneyTransaction":lblCard.text!,"FeeTransaction":"0","Content":phone!,"TimeTransaction": DateInFormat]
            alertPhoneCard = UIAlertController(title: "Bạn có chắc chắn nạp vào số điện thoại", message: "\(phone!)", preferredStyle: UIAlertControllerStyle.alert)
                }
            alertPhoneCard.addAction(UIAlertAction(title: "Tiếp tục", style: UIAlertActionStyle.destructive, handler: { action in
                self.tableName.childByAutoId().child("\(self.lblAccountNumber.text!)").setValue(inforTransaction)
                refchild.child("\(self.lblAccountNumber.text!)/Surplus").setValue(String(self.BalanceBanking))
                codePhoneCard = self.CodeTransaction
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc  = storyboard.instantiateViewController(withIdentifier: "CardPhone") as! PhoneSusscessViewController
//                self.present(vc, animated: false, completion: nil)
//                self.performSegue(withIdentifier:"CardPhone", sender: self)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let view = storyboard.instantiateViewController(withIdentifier: "CardPhone") as! PhoneSusscessViewController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                //show window
                appDelegate.window?.rootViewController = view
            }))
            alertPhoneCard.addAction(UIAlertAction(title: "Hủy", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alertPhoneCard, animated: true, completion: nil)
            self.activityStop()
        }else{
            let alert = UIAlertController(title: "Thông báo", message: "Tài khoản của bạn không đủ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.activityStop()
            }
       
}
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        hideKeyBoard()
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "ScreenHomeCustomer")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()

    }
    
    @IBAction func hideKB(_ sender: UITapGestureRecognizer) {
        hideKeyBoard()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultVC = segue.destination as! PhoneSusscessViewController
        resultVC.CodePhoneTransaction = codePhoneCard
 
    }
    
}
