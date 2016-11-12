//
//  RemarkViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/9.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD


class RemarkViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var averageRemarkHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var averageRemarkLabel: UILabel!
    
    @IBOutlet weak var navigationTitle: UILabel!
    var coachInfo: CoachInfo?
    var clubInfo: ClubInfo?
    var remarks: [UserRemark] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        initUI()
        postShow(0)

    }
    
    func initUI() {
        self.setBackButton()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 97
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        tableView.registerNib(UINib(nibName: "ClubAppraiseTableViewCell", bundle: nil), forCellReuseIdentifier: ClubAppraiseTableViewCell.id)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentDidchange(_:)), forControlEvents: UIControlEvents.ValueChanged)
        if userInfoStore.userType == 0 {
            segment.hidden = true
            navigationTitle.text = "我的评价"
            averageRemarkHeightConstraint.constant = 0
        } else if userInfoStore.userType == 1 {
            segment.hidden = true
            navigationTitle.text = "会馆评价"
        } else {
            navigationTitle.hidden = true
        }
    }
    
    func segmentDidchange(segmented: UISegmentedControl){
        
        postShow(segmented.selectedSegmentIndex)
        
    }
    
    func postShow(actType: Int){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        var url = getRemarkListForNormalUser
        var params = ["username": userInfoStore.userName  ,"password": encryptPassword(userInfoStore.password), "userType": userInfoStore.userType, "pageNo":1 , "pageSize":1000 ] as! [String : AnyObject]
        
        if actType > 0 {
            params["actType"] = actType
        }

        if userInfoStore.userType == 1 {
            url = getRemarkListForHg
            params["hgId"] = self.clubInfo?.id ?? 0
        } else if userInfoStore.userType == 2 {
            url = getRemarkListForJl
            params["jlId"] = self.coachInfo?.id ?? 0
        }
        doRequest(url, parameters: params , praseMethod: praseResult)
        
    }
    
    func praseResult(json: SwiftyJSON.JSON){
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        guard let success = json["success"].bool where success == true else {
            let message = json["message"].string ?? "出现网络错误"
            displayAlertControllerWithMessage(message)
            return
        }
        
        guard let records = json["remarkList"].array where records.count > 0 else {
            averageRemarkHeightConstraint.constant = 0
            remarks.removeAll()
            self.tableView.reloadData()
            return
        }
        if userInfoStore.userType != 0 {
            let averageRemark = json["averageRemark"].int ?? 0
            if averageRemark > 0 {
                averageRemarkLabel.text = "平均评价 \(averageRemark)"
                averageRemarkHeightConstraint.constant = 56
            } else {
                averageRemarkHeightConstraint.constant = 0
            }
        }
        self.remarks =  records.flatMap{ UserRemark(json: $0) }
        self.tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.remarks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ClubAppraiseTableViewCell.id, forIndexPath: indexPath) as! ClubAppraiseTableViewCell
        cell.dataBindWithUserRemark(self.remarks[indexPath.row])
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 97
//    }

}
