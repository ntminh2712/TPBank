//
//  ListTransactionsController.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/15/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
var CodeCardPhone:String!
var CodeBanking:String!
class TransactionsController: UIViewController{
    @IBOutlet weak var SearchTransaction: UISearchBar!
    @IBOutlet weak var tbListTransaction: UITableView!
    var ListTransactions:Array<Transaction> = Array<Transaction>()
    var currentListTransactions:Array<Transaction> = Array<Transaction>()
    var AccountNumber = currentUser.accountNumber!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        activityStart()
        SearchTransaction.placeholder = "Nhập thông tin để tìm kiếm"
        ref = Database.database().reference()
        let refchild = ref.child("Transaction History")
        refchild.observe(.childAdded, with: { (snapshot) in
            let postDict = snapshot.childSnapshot(forPath: currentUser.accountNumber).value as?  [String : AnyObject]
            if postDict != nil {
                let Category:String = (postDict!["Category"])! as! String
                let CodeTransaction:String = (postDict!["CodeTransaction"])! as! String
                var MoneyTransaction:String = (postDict!["MoneyTransaction"])! as! String
                if ((postDict?["AccountDestination"]) as! String) != nil {
                    let AccountDestination:String = (postDict?["AccountDestination"]) as! String
                    if AccountDestination != currentUser.accountNumber {
                        MoneyTransaction = "-\(MoneyTransaction)"
                    }else{
                        MoneyTransaction = "+\(MoneyTransaction)"
                    }
                }else if Category == "CardPhone" {
                     MoneyTransaction = "-\(MoneyTransaction)"
                }
                let Content:String = (postDict!["Content"])! as! String
                let FeeTransaction:String = (postDict!["FeeTransaction"])! as! String
                let TimeTransaction:String = (postDict!["TimeTransaction"])! as! String
                if Category == "Banking" {
                    let transaction:Transaction = Transaction(TimeTransaction: TimeTransaction, Content: Content, Money: String(MoneyTransaction), Category:.Banking, CodeTransaction:CodeTransaction)
                    self.currentListTransactions.append(transaction)
                }else{
                    let transaction:Transaction = Transaction(TimeTransaction: TimeTransaction, Content: Content, Money: String(MoneyTransaction), Category: .CardPhone, CodeTransaction: CodeTransaction)
                    self.currentListTransactions.append(transaction)
                }
                self.ListTransactions = self.currentListTransactions
                self.tbListTransaction.reloadData()
            }else{
                print("error load ")
            }
          
        })
        activityStop()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
    }
    @objc func keyboardWillChange(notification : Notification){
        print(notification.name.rawValue)
    }
    func hideKeyBoard(){
        SearchTransaction.resignFirstResponder()
    }
//    @IBAction func hideKB(_ sender: UITapGestureRecognizer) {
//        hideKeyBoard()
//    }
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
    func setup() {
        SearchTransaction.delegate = self
        tbListTransaction.delegate = self
        tbListTransaction.dataSource = self
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
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        hideKeyBoard()
        let appDelegate = UIApplication.shared.delegate! as! AppDelegate
        let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "ScreenHomeCustomer")
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
        
    }
}
extension TransactionsController : UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentListTransactions = ListTransactions.filter({ (transaction) -> Bool in
            switch searchBar.selectedScopeButtonIndex {
            case 0:
                if searchText.isEmpty { return true }
                return transaction.Content.lowercased().contains(searchText.lowercased())
            case 1:
                if searchText.isEmpty { return transaction.Category == .Banking}
                return transaction.Content.lowercased().contains(searchText.lowercased()) && transaction.Category == .Banking
            case 2:
                if searchText.isEmpty { return transaction.Category == .CardPhone}
                return transaction.Content.lowercased().contains(searchText.lowercased()) && transaction.Category == .CardPhone
            default: return false
            }
        })
        tbListTransaction.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        case 0:
            currentListTransactions = ListTransactions
        case 1:
            currentListTransactions = ListTransactions.filter({ (transaction) -> Bool in
                transaction.Category == CategoryTransaction.Banking
            })
        case 2:
            currentListTransactions = ListTransactions.filter({ (transaction) -> Bool in
                transaction.Category == CategoryTransaction.CardPhone
            })
        default:
            break
        }
        tbListTransaction.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentListTransactions.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellListTransaction") as! CellListTransactionTableViewCell
        cell.TimeTransactionIn.text = currentListTransactions[indexPath.row].TimeTransaction
        cell.ContentTransactionIn.text = currentListTransactions[indexPath.row].Content
        cell.MoneyTransactionIn.text = currentListTransactions[indexPath.row].Money
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentListTransactions[indexPath.row].Category == .Banking{
        CodeBanking = currentListTransactions[indexPath.row].CodeTransaction
            if CodeBanking != nil {
                let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "BankingDetail")
                appDelegate.window?.rootViewController = initialViewController
                appDelegate.window?.makeKeyAndVisible()
            }
            else{
                print("error load banking")
            }
        }else{
            CodeCardPhone = currentListTransactions[indexPath.row].CodeTransaction
            if CodeCardPhone != nil {
                let appDelegate = UIApplication.shared.delegate! as! AppDelegate
                let initialViewController = self.storyboard!.instantiateViewController(withIdentifier: "CardPhoneDetail")
                appDelegate.window?.rootViewController = initialViewController
                appDelegate.window?.makeKeyAndVisible()
            }else{
                print("error load cardphone")
            }
        }
    }
}
