//
//  AddMoneyViewController.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/24/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit
import Firebase
class AddMoneyViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtmoney: UITextField!
    @IBOutlet weak var lblSurplus: UILabel!
    var tableName: DatabaseReference!
    var Username:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtmoney.delegate = self
        ref = Database.database().reference()
        tableName = ref.child("Transaction History")
        let refchild = ref.child("Authentication")
        refchild.observe(.value, with: { (snapshot) in
            let postDict = snapshot.childSnapshot(forPath: "\(AccountDetail!)").value as! [String: AnyObject]
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
                self.lblSurplus.text = Surplus
            }
        })
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
        txtmoney.resignFirstResponder()
        
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
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "DetailUserStaff")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    @IBAction func btnAdd(_ sender: Any) {
        activityStart()
        var money = txtmoney.text
        if money != "" {
            if (money?.isNumber)! {
                if Int(money!)! > 50000 {
                    let CodeTransaction =  randomInt(min: 1000000, max: 9999999)
                    let SurplusInt:Int = Int(lblSurplus.text!)!
                    let money:Int = Int(txtmoney.text!)!
                    let Balance:Int = SurplusInt + money
                    let refchild = Database.database().reference().child("Authentication")
                    let todaysDate:NSDate = NSDate()
                    let dateFormatter:DateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                    let DateInFormat:String = dateFormatter.string(from: todaysDate as Date)
                    let inforTransaction:Dictionary<String,String> = ["AccountBanking":"CodeTransaction","NameDestination":Username,"Category":"Banking","CodeTransaction":CodeTransaction,"AccountDestination":"\(AccountDetail!)","Content":"Chuyển tiền cá nhân","NameBanking":Username,"FeeTransaction":"0","MoneyTransaction":String(money),"TimeTransaction":DateInFormat]
                    self.tableName.childByAutoId().child("\(AccountDetail!)").setValue(inforTransaction)
                    refchild.child("\(AccountDetail!)/Surplus").setValue(String(Balance))
                    let alert = UIAlertController(title: "Thông báo",message:"Nạp Thêm Tiền Thành công !",preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: { action in
                        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "DetailUserStaff")
                        appDelegate.window?.rootViewController = initialViewController
                        appDelegate.window?.makeKeyAndVisible()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    activityStop()
                }else{
                    let alert = UIAlertController(title: "Thông báo",message:"Số tiền bạn nhập quá ít. Không thể thực hiện giao dịch !",preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    activityStop()
                }
            }else{
                let alert = UIAlertController(title: "Thông báo",message:"Số tiền phải được viết dưới dạng số !",preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                activityStop()
            }
        }else{
            let alert = UIAlertController(title: "Thông báo",message:"Bạn phải điền đủ thông tin !",preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            activityStop()
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
