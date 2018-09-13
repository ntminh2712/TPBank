//
//  ViewController.swift
//  TPBank
//
//  Created by Tuấn Minh on 7/30/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
var ref:DatabaseReference!
var activity:UIActivityIndicatorView = UIActivityIndicatorView()
var currentUser:User!
class LoginController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.delegate = self
        txtEmail.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    @objc func keyboardWillChange(notification : Notification){
        print(notification.name.rawValue)
    }
    func hideKeyBoard(){
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
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
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        activityStart()
        if txtPassword.text != "" || txtEmail.text != "" {
            var email = txtEmail.text!
            var password = txtPassword.text!
            if isValidEmail(testStr: email){
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    self.activityStart()
                    if error == nil {
                        let alertLogin = UIAlertController(title: "Thông báo", message: "Đăng nhập thành công !", preferredStyle: UIAlertControllerStyle.alert)
                        alertLogin.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "HomeStaff")
                        appDelegate.window?.rootViewController = initialViewController
                        appDelegate.window?.makeKeyAndVisible()
                        self.activityStop()
                    } else {
                        let alert = UIAlertController(title: "Thông báo", message: "Đăng nhập không thành công !", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print("Đăng Nhập không thành công !")
                        self.activityStop()                    }
                }
            }else {
                let refchild = Database.database().reference().child("Authentication")
                refchild.observe(.value, with: { (snapshot) in
                    if snapshot.hasChild("\(email)") != false {
                    let postDict = snapshot.childSnapshot(forPath: "\(email)").value as! [String: AnyObject]
                    if ((postDict["Password"])! as! String) == password {
                        let AccountNumber:String = (postDict["AccountNumber"])! as! String
                        let Username:String = (postDict["Username"])! as! String
                        let Address:String = (postDict["Address"])! as! String
                        let Email:String = (postDict["Email"])! as! String
                        let IdentifyCard:String = (postDict["IdentifyCard"])! as! String
                        let Password:String = (postDict["Password"])! as! String
                        let Phone:String = (postDict["Phone"])! as! String
                        let Surplus:String = (postDict["Surplus"])! as! String
                        let OverdraftLimit:String  = (postDict["OverdraftLimit"])! as! String
                        currentUser = User(accountNumber: AccountNumber, Username: Username, Phone: Phone, Password: Password, Email: Email, Address: Address, IdentifyCard: IdentifyCard, Surplus: Surplus, OverdraftLimit: OverdraftLimit)
                        let alertLogin = UIAlertController(title: "Thông báo", message: "Đăng nhập thành công !", preferredStyle: UIAlertControllerStyle.alert)
                        alertLogin.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alertLogin, animated: true, completion: nil)
                        print("Đăng Nhập thành công !")
                        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "ScreenHomeCustomer")
                        appDelegate.window?.rootViewController = initialViewController
                        appDelegate.window?.makeKeyAndVisible()
                        self.activityStop()
                    }else
                    {
                        let alert = UIAlertController(title: "Thông báo", message: "Đăng nhập không thành công !", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        print("Đăng Nhập không thành công !")
                        self.activityStop()
                    }
                    }else{
                        let alert = UIAlertController(title: "Thông báo", message: "Tài khoản đăng nhập sai !", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.activityStop()
                    }
                })
            }
        }else{
            let alert = UIAlertController(title: "Thông báo", message: "Điền đầy đủ thông tin để đăng nhập !", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            print("Đăng nhập không thành công !")
            self.activityStop()
        }
    }
    
}
extension UIView {
    
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }
    
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
}
