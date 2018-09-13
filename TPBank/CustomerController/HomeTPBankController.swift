//
//  HomeTPBankController.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/20/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit
import Firebase
class HomeTPBankController: UIViewController {
    @IBOutlet weak var tbMessage: UITableView!
    var listMessage:Array<String> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tbMessage.delegate = self
        tbMessage.dataSource = self
        var refchild = Database.database().reference().child("Message")
        refchild.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            let postDict = snapshot.value as! [String: AnyObject]
            if postDict != nil {
                let message = (postDict["Message"])! as! String
                self.listMessage.append(message)
                self.tbMessage.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "ScreenHomeCustomer")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
}
extension HomeTPBankController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMessage") as! CellMessageViewCell
        cell.lblMessage.text = listMessage[indexPath.row]
        return cell
    }
}

class ChangePassword: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var lblPassOld: UITextField!
    @IBOutlet weak var lblNewPass: UITextField!
    @IBOutlet weak var lblRePass: UITextField!
    var Password:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPassOld.delegate = self
        lblNewPass.delegate = self
        lblRePass.delegate = self
        var refchild = Database.database().reference().child("Authentication")
        refchild.observe(.value, with: { (snapshot) in
            let postDict = snapshot.childSnapshot(forPath: "\(currentUser.accountNumber!)").value as! [String: AnyObject]
            if postDict != nil {
                self.Password = (postDict["Password"])! as! String
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
        lblRePass.resignFirstResponder()
        lblPassOld.resignFirstResponder()
        lblNewPass.resignFirstResponder()
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
    @IBAction func btnSusscess(_ sender: Any) {
        if lblRePass.text != "" || lblNewPass.text != "" || lblRePass.text != "" {
            if lblPassOld.text == Password {
                if lblNewPass.text == lblRePass.text {
                    let refchild = Database.database().reference().child("Authentication")
                    refchild.child("\(currentUser.accountNumber!)/Password").setValue(lblNewPass.text)
                    let alert = UIAlertController(title: "Thông báo", message: "Đổi mật khẩu thành công", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Thông báo", message: "Mật khẩu nhập lại không chính xác", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }else{
                let alert = UIAlertController(title: "Thông báo", message: "Mật khẩu cũ không chính xác", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Thông báo", message: "Bạn phải điền đầy đủ thông tin để đôi mật khẩu", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func hideKB(_ sender: UITapGestureRecognizer) {
        hideKeyBoard()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
