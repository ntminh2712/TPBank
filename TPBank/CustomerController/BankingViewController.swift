//
//  BankingViewController.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/8/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit
import Firebase
var codeBanking:String!
class BankingViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var tbBaking: UITableView!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblSurplus: UILabel!
    @IBOutlet weak var txtAccountBanking: UITextField!
    @IBOutlet weak var txtMoneyBanking: UITextField!
    @IBOutlet weak var btnFee: DLRadioButton!
    @IBOutlet weak var txtContent: UITextField!
    var feeInt:Int!
    var feeOut:Int!
    var SurplusInt:Int!
    var tableName: DatabaseReference!
    var MoneyBanking:Int!
    var NameBanking:String!
    var AccountNumber:String!
    var Username:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtAccountBanking.delegate = self
        txtMoneyBanking.delegate = self
        txtContent.delegate = self
        ref = Database.database().reference()
        tableName = ref.child("Transaction History")
        let refchild = Database.database().reference().child("Authentication")
        refchild.observe(.value, with: { (snapshot) in
            let postDict = snapshot.childSnapshot(forPath: "\(currentUser.accountNumber!)").value as! [String: AnyObject]
            if postDict != nil {
                self.AccountNumber = (postDict["AccountNumber"])! as! String
                self.Username = (postDict["Username"])! as! String
                let Address:String = (postDict["Address"])! as! String
                let Email:String = (postDict["Email"])! as! String
                let IdentifyCard:String = (postDict["IdentifyCard"])! as! String
                let Password:String = (postDict["Password"])! as! String
                let Phone:String = (postDict["Phone"])! as! String
                let Surplus:String = (postDict["Surplus"])! as! String
                let OverdraftLimit:String  = (postDict["OverdraftLimit"])! as! String
                self.lblAccountNumber.text = self.AccountNumber
                self.lblSurplus.text = String(Surplus)
                self.tbBaking.reloadData()
            }
        })
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
    }
    @IBAction func btnFree(_ sender: DLRadioButton) {
        feeInt = 5000
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
    func randomInt(min: Int, max:Int) -> String {
        let AccountNumber1 = min + Int(arc4random_uniform(UInt32(max - min + 1)))
        let AccountNumber2 = min + Int(arc4random_uniform(UInt32(max - min + 1)))
        let AccountNumber = "\(AccountNumber1)\(AccountNumber2)"
        return AccountNumber
    }
    @objc func keyboardWillChange(notification : Notification){
        print(notification.name.rawValue)
    }
    func hideKeyBoard(){
        txtAccountBanking.resignFirstResponder()
        txtMoneyBanking.resignFirstResponder()
        txtContent.resignFirstResponder()
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
   
    @IBAction func btnNext(_ sender: Any) {
        activityStart()
        if txtAccountBanking.text != "" || txtMoneyBanking.text != "" || txtContent.text != "" {
            if (txtMoneyBanking.text?.isNumber)! {
                if feeInt == nil {
                    let alert = UIAlertController(title: "Thông báo", message: "Bạn cần chọn hình thức trả phí !", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.activityStop()
                }else{
        let CodeTransaction =  randomInt(min: 1000000, max: 9999999)
        let refchild = Database.database().reference().child("Authentication")
        refchild.observe(.value, with: { (snapshot) in
            if snapshot.hasChild("\(self.txtAccountBanking.text!)") != false {
                let postDict = snapshot.childSnapshot(forPath:"\(self.txtAccountBanking.text!)").value as! [String: AnyObject]
                if postDict != nil {
                    let AccountBanking:String = (postDict["AccountNumber"])! as! String
                    self.NameBanking = (postDict["Username"])! as! String
                    let Address:String = (postDict["Address"])! as! String
                    let Email:String = (postDict["Email"])! as! String
                    let IdentifyCard:String = (postDict["IdentifyCard"])! as! String
                    let Surplus:String = (postDict["Surplus"])! as! String
                    var SurplusInt:Int! = Int(self.lblSurplus.text!)
                    var BalanceBanking:Int!
                    self.MoneyBanking = Int(self.txtMoneyBanking.text!)
                    BalanceBanking = (SurplusInt - self.MoneyBanking - self.feeInt)
                    var Balance:Int! = Int(Surplus)
                    Balance = (Balance + self.MoneyBanking)
                    if BalanceBanking! >= 50000 {
                        var todaysDate:NSDate = NSDate()
                        var dateFormatter:DateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                        var DateInFormat:String = dateFormatter.string(from: todaysDate as Date)
                        let inforTransaction:Dictionary<String,String> = ["AccountBanking":"\(self.lblAccountNumber.text!)","NameDestination":currentUser.Username,"Category":"Banking","CodeTransaction":CodeTransaction,"AccountDestination":AccountBanking,"NameBanking":self.NameBanking,"Content":self.txtContent.text!,"FeeTransaction":String(self.feeInt),"MoneyTransaction":self.txtMoneyBanking.text!,"TimeTransaction":DateInFormat]
                        let alert = UIAlertController(title: "Bạn có chắc chắn muốn chuyển tiền cho ", message: " \(self.NameBanking!)", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Tiếp tục", style: UIAlertActionStyle.destructive, handler: { action in
                            self.tableName.childByAutoId().child("\(self.lblAccountNumber.text!)").setValue(inforTransaction)
                            self.tableName.childByAutoId().child("\(AccountBanking)").setValue(inforTransaction)
                            refchild.child("\(self.lblAccountNumber.text!)/Surplus").setValue(String(BalanceBanking))
                            refchild.child("\(AccountBanking)/Surplus").setValue(String(Balance))
                            self.performSegue(withIdentifier:"Banking", sender: self)
                            codeBanking = CodeTransaction
                            
                        }))
                        alert.addAction(UIAlertAction(title: "Hủy", style: UIAlertActionStyle.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    
                    }else{
                        let alert = UIAlertController(title: "Thông báo", message: "Tài khoản của bạn không đủ để thực hiện giao dịch !", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                         self.present(alert, animated: true, completion: nil)
                        self.activityStop()
                    }
                }
            }else{
                let alert = UIAlertController(title: "Thông báo", message: "Tài khoản đích sai !", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.activityStop()
            }
        })
                }
            }else{
                let alert = UIAlertController(title: "Thông báo", message: "Số tiền giao dịch phải viết dưới dạng số", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.activityStop()
            }
        }else{
            let alert = UIAlertController(title: "Thông báo", message: "Bạn phải điền đầy đủ thông tin !", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.activityStop()
        }
    }
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "ScreenHomeCustomer")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    @IBAction func hideKB(_ sender: UITapGestureRecognizer) {
        hideKeyBoard()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultVC = segue.destination as! BankingSuccessViewController
        resultVC.accountNumber = txtAccountBanking.text!
        resultVC.userName = Username
        resultVC.fee = String(feeInt)
        resultVC.moneybanking = String(MoneyBanking)
        resultVC.content = txtContent.text!
        resultVC.namebanking = NameBanking
        resultVC.totalmoneybanking = String(Int(MoneyBanking) + feeInt)
    }
}
extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}
