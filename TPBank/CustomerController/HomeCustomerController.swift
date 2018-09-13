//
//  HomeController.swift
//  TPBank
//
//  Created by Tuấn Minh on 7/31/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit

class HomeCustomerController: UIViewController {

    @IBOutlet var ViewBG: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewBG.backgroundColor = UIColor(patternImage: UIImage(named: "background-1")!)
        self.lblUserName.text = currentUser.Username
    }
    override func viewWillAppear(_ animated: Bool) {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        lblDateTime.text = "Ngày \(components.day!), Tháng \(components.month!), Năm \(components.year!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
