//
//  ListUserViewController.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/5/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
var AccountDetail:String!
class ListUserViewController: UIViewController,UISearchBarDelegate {
    @IBOutlet weak var searchUser: UISearchBar!
    @IBOutlet weak var tbListUser: UITableView!
    var ListUser:Array<User> = Array<User>()
    var currentListUser:Array<User> = Array<User>()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchUser.delegate = self
        tbListUser.delegate = self
        tbListUser.dataSource = self
        
        let refchild = Database.database().reference().child("Authentication")
        refchild.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            let postDict = snapshot.value as! [String: AnyObject]
            if postDict != nil {
                let AccountNumber:String = (postDict["AccountNumber"])! as! String
                let Username:String = (postDict["Username"])! as! String
                let Address:String = (postDict["Address"])! as! String
                let Email:String = (postDict["Email"])! as! String
                let IdentifyCard:String = (postDict["IdentifyCard"])! as! String
                let Password:String = (postDict["Password"])! as! String
                let Phone:String = (postDict["Phone"])! as! String
                let Surplus:String = (postDict["Surplus"])! as! String
                let OverdraftLimit:String  = (postDict["OverdraftLimit"])! as! String
                let user:User = User(accountNumber: AccountNumber, Username: Username, Phone: Phone, Password: Password, Email: Email, Address: Address, IdentifyCard: IdentifyCard, Surplus: Surplus, OverdraftLimit: OverdraftLimit)
                self.ListUser.append(user)
                self.currentListUser = self.ListUser
                self.tbListUser.reloadData()
            }else{
                print("error load status")
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
        searchUser.resignFirstResponder()
        
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
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentListUser = ListUser
            tbListUser.reloadData()
            return
        }
        currentListUser = ListUser.filter({ (user) -> Bool in
            user.Username.lowercased().contains(searchText.lowercased())
        })
        tbListUser.reloadData()
    }
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        hideKeyBoard()
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "HomeStaff")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    @IBAction func hideKB(_ sender: UITapGestureRecognizer) {
//        hideKeyBoard()
//    }
    
}
extension ListUserViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return currentListUser.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellListUser",for: indexPath) as! CellListUserTableViewCell
        cell.userName.text = currentListUser[indexPath.row].Username
        cell.accountNumber.text = currentListUser[indexPath.row].accountNumber
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AccountDetail = currentListUser[indexPath.row].accountNumber
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "DetailUserStaff")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
}
class DetailUserController: UIViewController {
    
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
            let postDict = snapshot.childSnapshot(forPath: "\(AccountDetail!)").value as! [String: AnyObject]
            if postDict != nil {
                self.lblAccountNumber.text   = (postDict["AccountNumber"])! as! String
                self.lblUserName.text   = (postDict["Username"])! as! String
                self.lblAddress.text   = (postDict["Address"])! as! String
                self.lblSurplus.text   = (postDict["Surplus"])! as! String
                self.lblOverdrafLimit.text  = (postDict["OverdraftLimit"])! as! String
                self.lblTotalMoney.text = (postDict["Surplus"])! as! String
            }else{
                print("error load status")
            }
        })
    }
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "AccountViewStaff")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
        
    }

    @IBAction func btnAddMoney(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddMoney")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
class AddMessageController: UIViewController,UITextFieldDelegate {
   var tableName: DatabaseReference!
    @IBOutlet weak var txtContent: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtContent.delegate = self
        ref = Database.database().reference()
        tableName = ref.child("Message")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
    }
    
    @IBAction func btnSend(_ sender: Any) {
        let message = txtContent.text
        if message != "" {
            var Message:Dictionary<String,String> = ["Message":message!]
           tableName.childByAutoId().setValue(Message)
            let alert = UIAlertController(title: "Thông báo",message:"Gửi thông báo thành công !",preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Thông báo",message:"Bạn phải điền đủ thông tin !",preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func keyboardWillChange(notification : Notification){
        print(notification.name.rawValue)
    }
    func hideKeyBoard(){
        txtContent.resignFirstResponder()
        
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
    @IBAction func hideKB(_ sender: UITapGestureRecognizer) {
        hideKeyBoard()
    }
}




