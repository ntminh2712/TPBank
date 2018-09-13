//
//  HomeStaffViewController.swift
//  TPBank
//
//  Created by Tuấn Minh on 8/1/18.
//  Copyright © 2018 Tuấn Minh. All rights reserved.
//

import UIKit
import Firebase
class HomeStaffViewController: UIViewController {

    @IBOutlet var ViewBG: UIView!
    @IBOutlet weak var lblNameStaff: UILabel!
    @IBOutlet weak var lblDateStaff: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
      ViewBG.backgroundColor = UIColor(patternImage: UIImage(named: "background-1")!)
        
        }
    override func viewDidAppear(_ animated: Bool) {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        lblDateStaff.text = "Ngày \(components.day!), Tháng \(components.month!), Năm \(components.year!)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
